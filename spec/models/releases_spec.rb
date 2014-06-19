require 'spec_helper'

describe Release do
  it "should create a new instance given a valid attribute" do
    expect{ Release.create!(FactoryGirl.attributes_for(:release)) }.to change(Release, :count).by(1)
  end

  it "should require and validate presence of date" do
    no_date = Release.new(FactoryGirl.attributes_for(:invalid_release))
    no_date.should_not be_valid
  end

  it "should be valid with only a date" do
    only_date = Release.new(FactoryGirl.attributes_for(:release_only_date))
  end

  it "should return a specified apps version number for the previous release if no version number present for this release" do
    yesterdays_release = Release.create!(FactoryGirl.attributes_for(:release, date: Date.yesterday))
    tomorrows_release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow))
    expect( Release.version('mysageone', tomorrows_release) ).to eq("1.0")
  end

  it "should return a specified apps version number if there is a version present this release" do
    todays_release = Release.create!(FactoryGirl.attributes_for(:release, date: Date.yesterday))
    expect( Release.version('mysageone', todays_release) ).to eq("1.0")
  end

  it "should return a dash if no version number present for this release and specified app has no previous version numbers" do
    tomorrows_release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow))
    expect( Release.version('mysageone', tomorrows_release) ).to eq("-")
  end

  it "should return the last release" do
    yesterdays_release = Release.create!(FactoryGirl.attributes_for(:release, date: Date.yesterday))
    expect( Release.last_release).to eq(yesterdays_release)
  end

  it "should return the next release" do
    tomorrows_release = Release.create!(FactoryGirl.attributes_for(:release, date: Date.tomorrow))
    expect( Release.next_release).to eq(tomorrows_release)
  end

  it "deleting the release reduces the count" do
    release = Release.create!(FactoryGirl.attributes_for(:release))
    expect{ Release.destroy(release) }.to change(Release, :count).by(-1)
  end

  it "should default status to UAT" do
    release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow))
    expect(release.status).to eq("UAT")
  end

  it "should have a co-orindinator" do
    release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow, coordinator: 'Bob'))
    expect(release.coordinator).to eq("Bob")
  end

  it "should have a default co-ordinator if no value set" do
    release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow))
    expect(release.coordinator).to eq("Russell Craxford")
  end
end
