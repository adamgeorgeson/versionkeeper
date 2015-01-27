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

  def self.repositories
    ['mysageone', 'accountant_edition', 'accounts', 'accounts_extra',
        'addons', 'payroll', 'collaborate', 'accounts_production', 'help']
  end

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
      if repo == 'sage_one_gac_uki'
        sop_version = Octokit.contents("Sage/sage_one_advanced", :path => 'SOP_VERSION', :ref => "#{gac_version('accounts_extra', version)}").content
        unless sop_version
          sop_version = Octokit.contents("Sage/sage_one_advanced", :path => 'SOP_VERSION', :ref => "master").content
        end
      else
        sop_version = Octokit.contents("Sage/#{repo}", :path => 'SOP_VERSION', :ref => "v#{version}.rc1").content
        unless sop_version
          sop_version = Octokit.contents("Sage/#{repo}", :path => 'SOP_VERSION', :ref => "master").content
        end
      end
      Base64.decode64(sop_version)
    rescue
      "?"
    end
  end

  def self.gac_version(repo, version)
    begin
      gac_version = Octokit.contents("Sage/#{repo}", :path => 'CORE_VERSION', :ref => "v#{version}.rc1").content
      unless gac_version
        gac_version = Octokit.contents("Sage/#{repo}", :path => 'CORE_VERSION', :ref => "master").content
      end
      Base64.decode64(gac_version)
    rescue
      "?"
    end
  end

  def self.sopa_version(repo, version)
    begin
      sopa_version = Octokit.contents("Sage/#{repo}", :path => 'SOPA_VERSION', :ref => "v#{version}.rc1").content
      unless sopa_version
        sopa_version = Octokit.contents("Sage/#{repo}", :path => 'SOPA_VERSION', :ref => "master").content
      end
      Base64.decode64(sopa_version)
    rescue
      "?"
    end
  end
end

