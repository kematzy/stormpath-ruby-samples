require 'spec_helper'

describe "Authentication" do

  email = "test#{SecureRandom.hex}@example.com"
  password = 'Succ3ss!'

  before(:all) do
    @u = User.new
    @u.email = email
    @u.password = password
    @u.given_name = 'Given'
    @u.surname = 'Surname'
    @u.username = "test#{SecureRandom.hex}"

    @u.save
  end

  after(:all) do
    @u.destroy
  end

  describe "Sign in" do

    before do
      visit "/auth/stormpath"
      fill_in "sessions_email_or_username", with: email
    end

    describe "with valid credentials" do

      before do
        fill_in "sessions_password", with: password
        click_button "Sign in"
      end

      it "authenticates valid email and password" do
        page.should have_content("Signed in")
      end

      it "has signed in user info" do
        page.should have_content("Signed in as: #{email}")
      end

    end

    describe "without valid credentials" do

      before do
        fill_in "sessions_password", with: "wrongpassword"
        click_button "Sign in"
      end

      it "fails authentication with invalid password" do
        page.should have_content("Authentication failed")
      end

      it "does not have signed in user info" do
        page.should_not have_content("Signed in as: #{email}")
      end

    end
  end

  describe "Sign out" do

    before do
      visit "/auth/stormpath"
      fill_in "sessions_email_or_username", with: email
      fill_in "sessions_password", with: password
      click_button "Sign in"
      click_link "Sign out"
    end

    it "acknowledges signing out" do
      page.should have_content("Signed out")
    end

    it "does not have signed in user info" do
      page.should_not have_content("Signed in as: #{password}")
    end

  end
end
