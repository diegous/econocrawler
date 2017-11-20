def gather_publications(base_url)
  (1..8).flat_map do |i|
    index_page = { pagina: i }

    result = Wombat.crawl do
      base_url base_url
      path "/numeros-anteriores.php"
      http_method :post
      data index_page

      publication "xpath=//tr/td[1][@class='indice']", :iterator do
        articles_path "xpath=//a[contains(., 'Ver resumen')]/@href"
        date          "xpath=../td[3]"
        download_path "xpath=//a[contains(., 'Descargar')]/@href"
        notes         "xpath=../td[4]"
        number        "xpath=../td[2]"
        volume        "xpath=../td[1]"
      end
    end

    result["publication"]
  end
end

def gather_articles(base_url, articles_path)
  result = Wombat.crawl do
    base_url base_url
    path "/#{articles_path}"

    articles "xpath=//td[@class='sombra-cuerpo']//td[@bgcolor='#E9E4E4']/table[@cellspacing='10' and @cellpadding='0' and @border='0' and @width='100%']", :iterator do
      article_path "xpath=./tr[3]//a[1]/@href"
      authors      "xpath=./tr[2]"
      title        "xpath=./tr[1]"
    end
  end

  # Gather article details
  articles = result["articles"]
  articles.map do |article|
    path = article["article_path"]
    extra_details = article_details(BASE_URL, path)
    article.merge extra_details
  end
end

def article_details(base_url, article_path)
  Wombat.crawl do
    base_url base_url
    path "/#{article_path}"

    abstract  "xpath=//strong[contains(., 'Abstract')]/../../following-sibling::p"
    jel_codes "xpath=//strong[contains(., 'JEL')]/../../following-sibling::p"
    language  "xpath=//strong[contains(., 'Idioma')]/../../text()", :text
    quote     "xpath=//strong[contains(., 'Cita del artículo')]/../../following-sibling::p"
    summary   "xpath=//strong[contains(., 'Resumen')]/../../following-sibling::p"
  end
end

