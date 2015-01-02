class ReleaseNote < ActiveRecord::Base
  attr_accessible :release_id, :release_notes
  belongs_to :release

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
    return release.release_note.release_notes if release.release_note.present? && release.status == 'Production'

    mysageone = retrieve_release_notes('mysageone_uk', Release.version('mysageone',release)) + "\n" if release.mysageone.present?
    accounts = retrieve_release_notes('sage_one_accounts_uk', Release.version('accounts',release)) + "\n" if release.accounts.present?
    accounts_extra = retrieve_release_notes('sage_one_advanced', Release.version('accounts_extra',release)) + "\n" if release.accounts_extra.present?
    payroll = retrieve_release_notes('sage_one_payroll_ukie', Release.version('payroll',release)) + "\n" if release.payroll.present?
    addons = retrieve_release_notes('sage_one_addons_uk', Release.version('addons',release)) + "\n" if release.addons.present?
    collaborate = retrieve_release_notes('chorizo', Release.version('collaborate',release)) + "\n" if release.collaborate.present?
    accountant_edition = retrieve_release_notes('new_accountant_edition', Release.version('accountant_edition',release)) + "\n" if release.accountant_edition.present?
    accounts_production = retrieve_release_notes('sageone_accounts_production', Release.version('accounts_production',release)) + "\n" if release.accounts_production.present?

    release_notes = ''
    release_notes << '####My Sage One ' + mysageone if mysageone.present?
    release_notes << '####Accounts ' + accounts if accounts.present?
    release_notes << '####Accounts Extra ' + accounts_extra if accounts_extra.present?
    release_notes << '####Payroll ' + payroll if payroll.present?
    release_notes << '####Addons ' + addons if addons.present?
    release_notes << '####Collaborate ' + collaborate if collaborate.present?
    release_notes << '####Accountants Edition ' + accountant_edition if accountant_edition.present?
    release_notes << '####Final Accounts ' + accounts_production if accounts_production.present?

    release_notes.gsub! '### ', '##### '

    self.where(release_id: release.id).first_or_initialize.update_attribute(:release_notes, release_notes)

    if release_notes.present?
      release_notes
    else
      "There are no release notes ready yet. Try again later."
    end
  end

end
