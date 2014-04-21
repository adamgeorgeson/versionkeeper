class Release < ActiveRecord::Base
  belongs_to :user
  attr_accessible :accounts, :accounts_extra, :addons, :collaborate, :date, :help, :mysageone, :notes, :payroll
  validates_presence_of :date
  paginates_per 10

  def self.version app, release
    if release[app].present?
      release[app]
    else
      @date = release.date
      self.where("#{app} != '' AND date <= ?", @date).pluck(app).sort_by(&:to_i).last || "-"
    end
  end

  def self.last_release
    self.where("date < '#{Date.today.strftime('%Y-%m-%d')}'").last
  end

  def self.next_release
    self.where("date >= '#{Date.today.strftime('%Y-%m-%d')}'").first
  end
end
