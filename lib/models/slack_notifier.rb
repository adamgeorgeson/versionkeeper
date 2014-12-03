module SlackNotifier
  def self.post_version_numbers(release, message, release_url)
    field_array = []
    Release.repositories.each do |repo|
      fields = {
        title: I18n.t("app.#{repo}"),
        value: Release.version(repo, release),
          short: true
      }
      field_array << fields
    end

    attachments = [
      {
      fallback: "#{message}: <#{release_url}|##{release.id} [#{release.date}]>.",
      title: "#{message}: <#{release_url}|##{release.id} [#{release.date}]>.",
      pretext: "Date: <#{release_url}|##{release.id} [#{release.date}]> | Status: #{release.status}",
      color: "good",
      fields: field_array
    }
    ]

    Slack::Post.post_with_attachments message, attachments
  end
end
