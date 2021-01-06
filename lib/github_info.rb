require 'faraday'
require 'json'
require 'pry'

def get_and_parse(api_path)
  response = Faraday.get(api_path)
  JSON.parse(response.body, symbolize_names: true)
end

def find_repo(repos, target_repo_name)
  repos.find do |repo|
    repo[:name] == target_repo_name
  end
end

def get_repo_name
  parsed_repos = get_and_parse("https://api.github.com/users/foymikek/repos")
  esty_repo = find_repo(parsed_repos, 'little-esty-shop')
  esty_repo[:name]
end

def get_repo_contributor_usernames
  contributors = get_and_parse("https://api.github.com/repos/foymikek/little-esty-shop/contributors")
  contributors.map do |contributor|
    contributor[:login]
  end
end

#Repo Name
esty_repo_name = get_repo_name()

# Contributor User Names
contributor_usernames = get_repo_contributor_usernames()
