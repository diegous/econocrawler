def gather_publications(base_url)
  (1..8).flat_map do |i|
    index_page = { pagina: i }

    result = Wombat.crawl do
      base_url base_url
      path "/numeros-anteriores.php"
      http_method :post
      data index_page

      publication "xpath=//tr/td[1][@class='indice']", :iterator do
        volume "xpath=../td[1]"
        number "xpath=../td[2]"
        date "xpath=../td[3]"
        notas "xpath=../td[4]"
        # path_to_articles "xpath=./strong/a/@href"
        path_to_articles "xpath=//a[contains(., 'Ver resumen')]/@href"
        download_path "xpath=//a[contains(., 'Descargar')]/@href"
      end
    end

    result["publication"]
  end
end

def gather_articles(base_url, path_to_articles)
  result = Wombat.crawl do
    base_url base_url
    path "/#{path_to_articles}"

    articles "xpath=//td[@class='sombra-cuerpo']//td[@bgcolor='#E9E4E4']/table[@cellspacing='10' and @cellpadding='0' and @border='0' and @width='100%']", :iterator do
      title "xpath=./tr[1]"
      authors "xpath=./tr[2]"
      path_to_article_page "xpath=./tr[3]//a[1]/@href"
    end
  end

  # Gather article details
  articles = result["articles"]

  # byebug if path_to_articles == "detalle-numero-anterior.php?param=129"

  articles.map do |article|
    path = article["path_to_article_page"]
    extra_details = article_details(BASE_URL, path)
    article.merge extra_details
  end
end

def article_details(base_url, article_path)
  Wombat.crawl do
    base_url base_url
    path "/#{article_path}"

    quote         "xpath=//strong[contains(., 'Cita del artículo')]/../../following-sibling::p"
    summary       "xpath=//strong[contains(., 'Resumen')]/../../following-sibling::p"
    abstract      "xpath=//strong[contains(., 'Abstract')]/../../following-sibling::p"
    language      "xpath=//strong[contains(., 'Idioma')]/../../text()", :text
    jel_codes     "xpath=//strong[contains(., 'JEL')]/../../following-sibling::p"
  end
end

