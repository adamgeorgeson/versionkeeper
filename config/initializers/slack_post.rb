Slack::Post.configure(
  subdomain: ENV['SLACK_SUBDOMAIN'],
  token: ENV['SLACK_TOKEN'],
  username: ENV['SLACK_USERNAME'],
  channel: ENV['SLACK_CHANNEL']
)
