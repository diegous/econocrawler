require 'erb'
require 'json'
require 'byebug'

# Retrieve JSON
json_file = File.read('./result.json')
json = JSON.parse(json_file)


@template = File.read('./article.html.erb')
todo_textto = ""

["autor 1", "autor 2", "autor 3"].each do |aut|
  @autor = aut
  @descarga = "un link"

  todo_textto << ERB.new(@template).result()
end

puts todo_textto
