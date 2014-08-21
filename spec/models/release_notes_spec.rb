require 'spec_helper'

describe ReleaseNote do
  subject { ReleaseNote }

  describe :retrieve_release_notes do
    before :each do
      mysageone_uk_release_notes = Base64.encode64("# Version 2.15\n\n### Changes\n  * Allowing business access whilst business owner is blocked does not re-activated Zuora subscription [UKIEBUGS-366] (https://sageone.atlassian.net/browse/UKIEBUGS-366)\n  * Begin Rescue block when uploading mandate CSV to S3\n  * Fixes bug where client can not add new services if they only have collaborate [UKIEBUGS-322] (https://sageone.atlassian.net/browse/UKIEBUGS-322)\n  * Small change to remove variable assignment from rake datafixes:null_zuora_subscriptions\n  * Validate UK Bank Account Number on DD Form [UKIEBUGS-395] (https://sageone.atlassian.net/browse/UKIEBUGS-395)\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n# Version 2.14.1\n\n### Changes\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n# Version 2.14\n\n### Changes\n  * Fixes Duplicate charges in Zuora after account un blocked [UKIEBUGS-138] (https://sageone.atlassian.net/browse/UKIEBUGS-138)\n  * Fixes calculation of next chargable date [UKIEBUGS-299] (https://sageone.atlassian.net/browse/UKIEBUGS-299)\n  * Fixes bug relating to downgrade from standard to cashbook with JWT [UKIEBUGS-315] (https://sageone.atlassian.net/browse/UKIEBUGS-315)\n  * Fixes bug relating to upgrade from Cashbook to Accounts when previously had the service [UKIEBUGS-318] (https://sageone.atlassian.net/browse/UKIEBUGS-318)\n  * Fixes bug relating to downgrading to Accounts when has previously has Cashbook and Accounts Extra via JWT [UKIEBUGS-321] (https://sageone.atlassian.net/browse/UKIEBUGS-321)\n  * Resolve an issue with Zuora subscription by running null_zuora_subscriptions rake task [UKIEBUGS-314] (https://sageone-uat.sageone.biz/browse/UKIEBUGS-314)\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * bundle exec rake datafixes:null_zuora_subscriptions['ca8b06cd3c23ea14f69dd816f90621c1']\n\n#")

      Octokit.stub_chain('contents','content').and_return(mysageone_uk_release_notes)
    end

    it "returns release notes for the given repo and version" do
      expect(subject.retrieve_release_notes('mysageone_uk','2.14.1')).to eq("2.14.1\n\n### Changes\n  * Adding 'piwik' (new open source alternative to google analytics) tracking codes\n\n### Dependencies\n  * None\n\n### Deploy tasks\n  * None\n\n")
      expect(subject.retrieve_release_notes('mysageone_uk','2.14.1')).to_not include("2.15")
    end

    it "returns a question mark if no content found for given paramaters" do
      Octokit.stub_chain('contents','content').and_return(nil)
      expect(subject.retrieve_release_notes('mysageone_uk','7000')).to eq("Could not retrieve release notes. Try again later.")
    end

    xit "configures filename and splitter for a given repo" do
    end
  end

  describe :build_release_notes do
    xit 'formats release notes correctly' do

    end

    xit 'returns message if no release notes found for an app version' do

    end

    xit 'returns stored version of release notes if release has status of Production' do

    end

    xit 'calls the retrieve_release_notes method if no release notes present' do

    end
    
    xit 'calls the retrieve_release_notes method if release status not in Production' do

    end
  end
end
