require 'spec_helper'

describe "releases/edit" do
  before(:each) do
    @release = assign(:release, stub_model(Release))
  end

  it "renders the edit release form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", release_path(@release), "post" do
    end
  end
end
