require 'wombat'
require 'byebug'
require 'json'
require './crawlers'

BASE_URL = "http://economica.econo.unlp.edu.ar"

# Go through all the index pages gathering a link to each publication
publications = gather_publications(BASE_URL)

# Go through each Publication page getting information for each one of
# its articles
publications.map! do |publication|
  publication.merge "articles" => gather_articles(BASE_URL, publication["publication_path"])
end

File.open("result.json", "w") do |file|
  file.write(publications.to_json)
end
