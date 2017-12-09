require 'erb'
require 'json'
require 'byebug'

english = true
LANGUAGE = english ? 'english' : 'spanish'
BASE_URL = "http://economica.econo.unlp.edu.ar#{'/ing' if english}"

# Retrieve JSON
JSON_FILE = File.read("./result#{'_english' if english}.json")
publications = JSON.parse(JSON_FILE)

# Templates
PUBLICATION_TEMPLATE = File.read("./templates/#{LANGUAGE}/publication.md.erb")
ARTICLE_TEMPLATE = File.read("./templates/#{LANGUAGE}/article.html.erb")

# Create a file for each publication
publications.each do |publication|
  @publication = publication
  publication_text = ERB.new(PUBLICATION_TEMPLATE).result()
  file_indentifier = "#{publication["volume"]}_#{publication["number"]}"
  filename = "publication_#{file_indentifier.to_s.tr(' ', '_')}.md"

  File.open("./result_files/#{LANGUAGE}/#{filename}", "w") do |file|
    file.write(publication_text)
  end
end
