require 'faraday'
require 'json'
require 'pry'

response = Faraday.get("https://api.github.com/users/foymikek/repos")
parsed_repos = JSON.parse(response.body, symbolize_names: true)
esty_repo = parsed_repos.find do |repo|
  repo[:name] === 'little-esty-shop'
end

#Repo Names
repo_name = esty_repo[:name]

# User Names
response = Faraday.get("https://api.github.com/repos/foymikek/little-esty-shop/collaborators")
binding.pry
