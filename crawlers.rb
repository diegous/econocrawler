def gather_publications(base_url)
  (1..8).flat_map do |i|
    index_page = { pagina: i }

    result = Wombat.crawl do
      base_url base_url
      path "/numeros-anteriores.php"
      http_method :post
      data index_page

      publication "xpath=//tr/td[1][@class='indice']", :iterator do
        date             "xpath=../td[3]"
        notes            "xpath=../td[4]"
        number           "xpath=../td[2]"
        publication_path "xpath=../td[1]/strong/a/@href"
        volume           "xpath=../td[1]"
      end
    end

    result["publication"]
  end
end

def gather_articles(base_url, publication_path, english = false)
  result = Wombat.crawl do
    base_url base_url
    path "/#{publication_path}"

    articles "xpath=//td[@class='sombra-cuerpo']//td[@bgcolor='#E9E4E4']/table[@cellspacing='10' and @cellpadding='0' and @border='0' and @width='100%']", :iterator do
      article_path  "xpath=./tr[3]/td/a[contains(., '#{english ? 'Abstract and Citation' : 'Ver resumen'}')]/@href"
      authors       "xpath=./tr[2]"
      download_path "xpath=./tr[3]/td/a[contains(., '#{english ? 'Full text' : 'Descargar'}')]/@href"
      title         "xpath=./tr[1]"
    end
  end

  # Gather article details
  articles = result["articles"]
  articles.map do |article|
    path = article["article_path"]
    extra_details = article_details(base_url, path, english)
    article.merge extra_details
  end
end

def article_details(base_url, article_path, english = false)
  Wombat.crawl do
    base_url base_url
    path "/#{article_path}"

    abstract  "xpath=//strong[contains(., 'Abstract')]/../../following-sibling::p"
    jel_codes "xpath=//strong[contains(., 'JEL')]/../../following-sibling::p"
    language  "xpath=//strong[contains(., '#{english ? 'Language' : 'Idioma'}')]/../../text()", :text
    quote     "xpath=//strong[contains(., '#{english ? 'Article Citation' : 'Cita del artículo'}')]/../../following-sibling::p"
    summary   "xpath=//strong[contains(., 'Resumen')]/../../following-sibling::p"
  end
end
