require 'erb'
require 'json'
require 'byebug'


BASE_URL = "http://economica.econo.unlp.edu.ar"

# Retrieve JSON
JSON_FILE = File.read('./result.json')
publications = JSON.parse(JSON_FILE)

# Templates
PUBLICATION_TEMPLATE = File.read('./templates/publication.md.erb')
ARTICLE_TEMPLATE = File.read('./templates/article.html.erb')

# Create a file for each publication
publications.each do |publication|
  @publication = publication
  publication_text = ERB.new(PUBLICATION_TEMPLATE).result()
  file_indentifier = "#{publication["volume"]}_#{publication["number"]}"
  filename = "publication_#{file_indentifier.to_s.tr(' ', '_')}.md"

  File.open("./result_files/#{filename}", "w") do |file|
    file.write(publication_text)
  end
end
