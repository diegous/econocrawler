require 'wombat'
require 'byebug'
require 'json'
require './crawlers'

BASE_URL = "http://economica.econo.unlp.edu.ar"

# Go through all the index pages gathering a link to each publication
publications = gather_publications(BASE_URL)

# Go through each Publication page getting basic information of the
# articles and a link to each article page
publications.map! do |publication|
  publication.merge "articles" => gather_articles(BASE_URL, publication["path_to_articles"])
end

File.open("result.json", "w") do |f|
   f.write(publications.to_json)
end
