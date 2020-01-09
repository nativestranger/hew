require 'rails_helper'

RSpec.describe 'CallUsers', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:call) { FactoryBot.create(:call, user: user) }

  describe 'creating a call_user' do
    before do
      login_as(user, scope: :user)
      visit call_call_users_path(call_id: call.id)
    end

    context 'new user' do
      it 'creates a new call_user and user' do
        fill_in 'call_user_user_attributes_email', with: 'newuser@example.com'
        select 'Juror', from: 'call_user_role'
        click_button 'Add User'
        expect(page).to have_content('Success')
        call_user = CallUser.last
        expect(call_user.user.email).to eq('newuser@example.com')
        expect(call_user.role).to eq('juror')

        confirmation_email = ActionMailer::Base.deliveries.last
        expect(confirmation_email.to).to eq(['newuser@example.com'])
        expect(confirmation_email.subject).to eq("You're invited to act as a juror on Mox. Congrats! Confirm your email address to get started.")

        select 'Admin', from: "call_user_#{call_user.id}_role"
        sleep 0.2
        expect(call_user.reload.role).to eq('admin')
      end
    end
    context 'existing user' do
      let!(:user2) { FactoryBot.create(:user) }

      it 'creates a new call_user for the existing user' do
        fill_in 'call_user_user_attributes_email', with: user2.email
        select 'Juror', from: 'call_user_role'
        click_button 'Add User'
        expect(page).to have_content('Success')
        call_user = CallUser.last
        expect(call_user.user.email).to eq(user2.email)

        confirmation_email = ActionMailer::Base.deliveries.last
        expect(confirmation_email.to).to eq([user2.email])
        expect(confirmation_email.subject).to eq("You're invited to act as a juror on Mox. Congrats!")
      end
    end
  end
end
