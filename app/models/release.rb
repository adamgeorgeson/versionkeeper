class Release < ActiveRecord::Base
  attr_accessible :accounts, :accounts_extra, :addons,
    :date, :help, :mysageone,
    :notes, :payroll, :status, :coordinator,
    :collaborate, :accountant_edition, :accounts_production

  has_one :release_note

  validates_presence_of :date
  before_save :set_coordinator

  paginates_per 10

  scope :search_filter, lambda { |search_terms|
    return nil if search_terms.blank?
    search_terms = "%#{search_terms}%"
    where('release_notes.release_notes LIKE ? OR releases.notes LIKE ?', search_terms, search_terms).joins(:release_note)
  }


  def self.version(app, release)
    if release.present?
      if release[app].present?
        release[app]
      else
        @date = release.date
        where("#{app} != '' AND date <= ?", @date).pluck(app).sort_by{ |a| a.split('.').map(&:to_i) }.last || '-'
      end
    end
  end

  def self.last_release
    self.where("date < '#{Date.today.strftime('%Y-%m-%d')}'").order('date').last
  end

  def self.next_release
    self.where("date >= '#{Date.today.strftime('%Y-%m-%d')}'").order('date').first
  end

  def set_coordinator
    self.coordinator = 'Russell Craxford' if self.coordinator.blank?
  end

  def self.sop_version(repo, version)
    begin
      sop_version = Octokit.contents("Sage/#{repo}", :path => 'SOP_VERSION', :ref => "v#{version}.rc1").content
      Base64.decode64(sop_version)
    rescue
      "?"
    end
  end

  def self.post_to_slack(release, message, release_url)
    attachments = [
      {
      fallback: "#{message}: <#{release_url}|##{release.id} [#{release.date}]>.",
      title: "#{message}: <#{release_url}|##{release.id} [#{release.date}]>.",
      pretext: "Status: #{release.status}",
      color: "good",
        # Fields are displayed in a table on the message
        fields: [
          {
        title: "My Sage One",
        value: release.mysageone,
        short: true
      },
        {
        title: "Accountant Edition",
        value: release.accountant_edition,
        short: true
      },
        {
        title: "Accounts",
        value: release.accounts,
        short: true
      },
        {
        title: "Accounts Extra",
        value: release.accounts_extra,
        short: true
      },
        {
        title: "Addons",
        value: release.addons,
        short: true
      },
        {
        title: "Payroll",
        value: release.payroll,
        short: true
      },
        {
        title: "Collaborate",
        value: release.collaborate,
        short: true
      },
        {
        title: "Accounts Production",
        value: release.accounts_production,
        short: true
      },
        {
        title: "Help",
        value: release.help,
        short: true
      }
      ]
    }
    ]

    Slack::Post.post_with_attachments message, attachments
  end


end
