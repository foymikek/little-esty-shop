class GithubFacade
  def self.get_users
    results = GithubService.call_github('/repos/foymikek/little-esty-shop/stats/contributors')
    results.map do |user_data|
      GithubResults.new(user_data)
    end
  end

  def self.repo_name
    parsed_repo_info = GithubService.call_github('/repos/foymikek/little-esty-shop')
  end

  def self.total_repo_pr_count
    parsed_info = GithubService.call_github('https://api.github.com/repos/foymikek/little-esty-shop/pulls?state=all')
    merged_info = parsed_info.map do |info|
      info[:merged_at]
    end
    merged_info.


    require "pry"; binding.pry
  end

end
