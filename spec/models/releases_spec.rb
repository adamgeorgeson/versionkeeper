require 'spec_helper'

describe Release do
  before :each do
    @attr = {
      :date => '01/01/2099',
      :mysageone => '1.0',
      :accounts => '1.0',
      :accounts_extra => '1.0',
      :addons => '1.0',
      :collaborate => '1.0',
      :help => '1.0',
      :payroll => '1.0'
    }
  end

  it "should create a new instance given a valid attribute" do
    expect{ Release.create!(@attr) }.to change(Release, :count).by(1)
  end

  it "should require and validate presence of date" do
    no_date = Release.new(@attr.merge(:date => ''))
    no_date.should_not be_valid
  end

  it "should be valid with only a date" do
    only_date = Release.new({ :date => '01/01/2099' })
  end

  it "should return a specified apps version number for the previous release if no version number present for this release" do
    Release.create!(@attr.merge(:date => Date.yesterday))
    Release.create!({ :date => Date.tomorrow })
    expect( Release.version('mysageone', Release.last) ).to eq("1.0")
  end

  it "should return a dash if no version number present for this release and specified app has no previous version numbers" do
    Release.create!({ :date => Date.tomorrow })
    expect( Release.version('mysageone', Release.last) ).to eq("-")
  end

  it "should return the last release" do
    yesterdays_release = Release.create!(@attr.merge(:date => Date.yesterday))
    expect( Release.last_release).to eq(yesterdays_release)
  end

  it "should return the next release" do
    tomorrows_release = Release.create!(@attr.merge(:date => Date.tomorrow))
    expect( Release.next_release).to eq(tomorrows_release)
  end

  it "should delete the release and reduce the count" do
    tomorrows_release = Release.create!(@attr.merge(:date => Date.tomorrow))
    expect{ Release.destroy(tomorrows_release) }.to change(Release, :count).by(-1)
  end
end
