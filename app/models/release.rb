class Release < ActiveRecord::Base
  attr_accessible :accounts, :accounts_extra, :addons,
    :collaborate, :date, :help, :mysageone,
    :notes, :payroll, :status, :coordinator

  validates_presence_of :date
  before_save :set_coordinator
  paginates_per 10

  def self.version(app, release)
    if release.present?
      if release[app].present?
        release[app]
      else
        @date = release.date
        where("#{app} != '' AND date <= ?", @date).pluck(app).sort_by(&:to_i).last || '-'
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
    self.coordinator = "Russell Craxford" if self.coordinator.blank?
  end

  def self.sop_version(repo, version)
    begin
      sop_version = Octokit.contents("Sage/#{repo}", :path => 'SOP_VERSION', :ref => "v#{version}.rc1").content
      Base64.decode64(sop_version)
    rescue
      "?"
    end
  end
end
