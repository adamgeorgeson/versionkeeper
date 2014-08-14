class Release < ActiveRecord::Base
  attr_accessible :accounts, :accounts_extra, :addons,
    :date, :help, :mysageone,
    :notes, :payroll, :status, :coordinator,
    :collaborate, :accountant_edition, :accounts_production,
    :release_notes

  validates_presence_of :date
  before_save :set_coordinator
  paginates_per 10

  def self.version(app, release)
    if release.present?
      if release[app].present?
        release[app]
      else
        @date = release.date
        where("#{app} != '' AND date <= ?", @date).pluck(app).sort_by{ |a| a.split('.').map &:to_i }.last || '-'
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

  def self.retrieve_release_notes(repo, version)
    case repo
    when 'mysageone_uk'
      path = 'RELEASENOTES.md'
      split = '# Version '
    when 'sage_one_accounts_uk'
      path = 'RELEASE_NOTES.md'
      split = '# Release '
    when 'sage_one_advanced'
      path = 'RELEASE_NOTES.md'
      split = '# Version '
    when 'sage_one_payroll_ukie'
      path = 'RELEASENOTES.txt'
      split = 'Release '
    when 'sage_one_addons_uk'
      path = "RELEASE_NOTES.md"
      split = "Version "
    when 'chorizo'
      path = 'RELEASENOTES.txt'
      split = 'Version '
    when 'new_accountant_edition'
      path = 'RELEASENOTES.md'
      split = 'Version '
    when 'sageone_accounts_production'
      path = 'ReleaseNotes.txt'
      split = 'Version '
    else
      path = "RELEASENOTES.md"
      split = "# Version "
    end

    begin
      release_notes = Octokit.contents("Sage/#{repo}", :path => path).content
      release_notes = Base64.decode64(release_notes)
      release_notes.split(split).keep_if { |r| r.include?("#{version}\n") }[0].to_s
    rescue
      return 'Could not retrieve release notes. Try again later.'
    end
  end

  def self.build_release_notes(release)
    return release.release_notes if release.release_notes.present? && release.status == 'Production'

    mysageone = Release.retrieve_release_notes('mysageone_uk', Release.version('mysageone',release)) + "\n" if release.mysageone.present?
    accounts = Release.retrieve_release_notes('sage_one_accounts_uk', Release.version('accounts',release)) + "\n" if release.accounts.present?
    accounts_extra = Release.retrieve_release_notes('sage_one_advanced', Release.version('accounts_extra',release)) + "\n" if release.accounts_extra.present?
    payroll = Release.retrieve_release_notes('sage_one_payroll_ukie', Release.version('payroll',release)) + "\n" if release.payroll.present?
    addons = Release.retrieve_release_notes('sage_one_addons_uk', Release.version('addons',release)) + "\n" if release.addons.present?
    collaborate = Release.retrieve_release_notes('chorizo', Release.version('collaborate',release)) + "\n" if release.collaborate.present?
    accountant_edition = Release.retrieve_release_notes('new_accountant_edition', Release.version('accountant_edition',release)) + "\n" if release.accountant_edition.present?
    accounts_production = Release.retrieve_release_notes('sageone_accounts_production', Release.version('accounts_production',release)) + "\n" if release.accounts_production.present?

    release_notes = ''
    release_notes << '####My Sage One ' + (mysageone.present? ? mysageone : "\n No release notes found for this version \n")
    release_notes << '####Accounts ' + (accounts.present? ? accounts : "\n No release notes found for this version \n")
    release_notes << '####Accounts Extra ' + (accounts_extra.present? ? accounts_extra : "\n No release notes found for this version \n")
    release_notes << '####Payroll ' + (payroll.present? ? payroll : "\n No release notes found for this version \n")
    release_notes << '####Addons ' + (addons.present? ? addons : "\n No release notes found for this version \n")
    release_notes << '####Collaborate ' + (collaborate.present? ? collaborate : "\n No release notes found for this version \n")
    release_notes << '####Accountants Edition ' + (accountant_edition.present? ? accountant_edition : "\n No release notes found for this version \n")
    release_notes << '####Accounts Production ' + (accounts_production.present? ? accounts_production : "\n No release notes found for this version \n")

    release_notes.gsub! '### ', '##### '
    release.update_attribute(:release_notes, release_notes)
    return release_notes
  end
end
