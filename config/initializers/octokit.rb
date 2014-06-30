# Provide authentication credentials
Octokit.configure do |c|
  c.login = ENV['OCTOKIT_LOGIN']
  c.password = ENV['OCTOKIT_PASSWORD']
end
