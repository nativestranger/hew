require 'rails_helper'

RSpec.describe 'Registration', type: :system do
  describe 'registering a new user' do
    it 'creates a new user and sends the confirmation email' do
      built_user = FactoryBot.build(:user)

      visit new_user_registration_path

      fill_in 'user_first_name', with: built_user.first_name
      fill_in 'user_last_name', with: built_user.last_name
      fill_in 'user_email', with: built_user.email
      click_button 'Sign up'

      sleep 0.5
      new_user = User.find_by(email: built_user.email)

      expect(ActionMailer::Base.deliveries.count).to eq 1

      confirmation_email = ActionMailer::Base.deliveries.first
      expect(confirmation_email.to).to eq([new_user.email])
      expect(confirmation_email.subject).to eq("Confirm your account on Hew")

      visit user_confirmation_path(confirmation_token: new_user.confirmation_token)
      fill_in "user_password", with: 'INSECUREPASSWORD!'
      fill_in "user_password_confirmation", with: 'INSECUREPASSWORD!'
      click_button "Set Your Password"

      expect(page).to have_content("Your password has been changed successfully. You are now signed in.")
    end
  end
end
