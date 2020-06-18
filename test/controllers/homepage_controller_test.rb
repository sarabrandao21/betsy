require "test_helper"

describe HomepageController do
  it "can get the homepage" do
    get root_path

    must_respond_with :success
  end
end
