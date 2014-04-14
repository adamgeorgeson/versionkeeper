require 'spec_helper'

describe "releases/index" do
  before(:each) do
    assign(:releases, [
      stub_model(Release),
      stub_model(Release)
    ])
  end

  it "renders a list of releases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
