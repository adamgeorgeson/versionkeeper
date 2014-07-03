require 'spec_helper'

describe Release do
  it "should create a new instance given a valid attribute" do
    expect{ Release.create!(FactoryGirl.attributes_for(:release)) }.to change(Release, :count).by(1)
  end

  describe 'validation' do
    it "should require and validate presence of date" do
      no_date = Release.new(FactoryGirl.attributes_for(:invalid_release))
      no_date.should_not be_valid
    end

    it "should be valid with only a date" do
      only_date = Release.new(FactoryGirl.attributes_for(:release_only_date))
      only_date.should be_valid
    end
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

  describe :set_coordinator do
    it "should have a co-ordinator" do
      release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow, coordinator: 'Bob'))
      expect(release.coordinator).to eq("Bob")
    end

    it "should have a default co-ordinator if no value set" do
      release = Release.create!(FactoryGirl.attributes_for(:release_only_date, date: Date.tomorrow))
      expect(release.coordinator).to eq("Russell Craxford")
    end
  end

  describe :sop_version do
    it "returns a base64 decoded sop_version from github if present" do
      Octokit.stub_chain('contents', 'content').and_return 'MS40LjQK'
      expect(Release.sop_version('mysageone_uk', '2.14')).to eq("1.4.4\n")
    end

    it "returns a question mark if not present" do
      Octokit.stub_chain('contents', 'content').and_return nil
      expect(Release.sop_version('mysageone_uk', '2.14')).to eq('?')
    end
  end

  describe :release_notes do
    before :each do
      mysageone_uk_release_notes = Base64.encode64("# Version 2.15\n\n### Changes\n  * Allowing business access whilst business owner is blocked does not re-activated Zuora subscription [UKIEBUGS-366] (https://sageone.atlassian.net/browse/UKIEBUGS-366)\n  * Begin Rescue block when uploading mandate CSV to S3\n  * Fixes bug where client can not add new services if they only have collaborate [UKIEBUGS-322] (https://sageone.atlassian.net/browse/UKIEBUGS-322)\n  * Small change to remove variable assignment from rake datafixes:null_zuora_subscriptions\n  * Validate UK Bank Account Number on DD Form [UKIEBUGS-395] (https://sageone.atlassian.net/browse/UKIEBUGS-395)\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n# Version 2.14.1\n\n### Changes\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n# Version 2.14\n\n### Changes\n  * Fixes Duplicate charges in Zuora after account un blocked [UKIEBUGS-138] (https://sageone.atlassian.net/browse/UKIEBUGS-138)\n  * Fixes calculation of next chargable date [UKIEBUGS-299] (https://sageone.atlassian.net/browse/UKIEBUGS-299)\n  * Fixes bug relating to downgrade from standard to cashbook with JWT [UKIEBUGS-315] (https://sageone.atlassian.net/browse/UKIEBUGS-315)\n  * Fixes bug relating to upgrade from Cashbook to Accounts when previously had the service [UKIEBUGS-318] (https://sageone.atlassian.net/browse/UKIEBUGS-318)\n  * Fixes bug relating to downgrading to Accounts when has previously has Cashbook and Accounts Extra via JWT [UKIEBUGS-321] (https://sageone.atlassian.net/browse/UKIEBUGS-321)\n  * Resolve an issue with Zuora subscription by running null_zuora_subscriptions rake task [UKIEBUGS-314] (https://sageone-uat.sageone.biz/browse/UKIEBUGS-314)\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * bundle exec rake datafixes:null_zuora_subscriptions['ca8b06cd3c23ea14f69dd816f90621c1']\n\n#")

      Octokit.stub_chain('contents','content').and_return(mysageone_uk_release_notes)
    end

    it "returns release notes for the given repo and version" do
      expect(Release.release_notes('mysageone_uk','2.14.1')).to eq("2.14.1\n\n### Changes\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n")
      expect(Release.release_notes('mysageone_uk','2.14.1')).to_not include("2.15")
    end

    it "returns a question mark if no content found for given paramaters" do
      Octokit.stub_chain('contents','content').and_return(nil)
      expect(Release.release_notes('mysageone_uk','7000')).to eq("?")
    end

    xit "configures filename and splitter for a given repo" do
    end
  end
end
