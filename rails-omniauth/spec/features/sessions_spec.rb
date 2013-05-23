require 'spec_helper'

describe "Authentication" do
  email = "test#{SecureRandom.hex}@example.com"
  password = 'Succ3ss!'

  before(:all) do
    @user = User.create!(
      email: email,
      password: password,
      given_name: 'Given',
      surname: 'Surname',
      username: "test#{SecureRandom.hex}"
    )
  end

  after(:all) do
    @user.destroy
  end

  describe "Sign in" do
    before do
      visit new_session_path
      fill_in "email_or_username", with: email
    end

    describe "with valid credentials" do
      before do
        fill_in "password", with: password
        click_button "Sign in"
      end

      it "authenticates valid email and password" do
        expect(page).to have_content("Signed in")
      end

      it "has signed in user info" do
        expect(page).to have_content("Signed in as: #{email}")
      end
    end

    describe "without valid credentials" do
      before do
        fill_in "password", with: "wrongpassword"
        click_button "Sign in"
      end

      it "fails authentication with invalid password" do
        expect(page).to have_content("Authentication failed")
      end

      it "does not have signed in user info" do
        expect(page).to_not have_content("Signed in as: #{email}")
      end
    end
  end

  describe "Sign out" do
    before do
      visit new_session_path
      fill_in "email_or_username", with: email
      fill_in "password", with: password
      click_button "Sign in"
      click_link "Sign out"
    end

    it "acknowledges signing out" do
      expect(page).to have_content("Signed out")
    end

    it "does not have signed in user info" do
      expect(page).to_not have_content("Signed in as: #{password}")
    end
  end
end
