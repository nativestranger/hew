require 'rails_helper'

RSpec.describe 'CallApplications', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:call) { FactoryBot.create(:call, user: user) }

  describe 'creating ' do
    context 'not logged in' do
      it 'creates a new call application and user' do
        visit new_call_application_path(call_id: call.id)
        fill_in 'call_application_user_attributes_first_name', with: 'John'
        fill_in 'call_application_user_attributes_last_name', with: 'Doe'
        fill_in 'call_application_user_attributes_email', with: 'john@doe.com'
        fill_in 'call_application_artist_website', with: 'https://website.com'
        fill_in 'call_application_artist_instagram_url', with: 'https://instagram.com'
        page.execute_script("document.getElementById('call_application_artist_statement').value = 'statement'")
        click_button 'Continue'
        call_application = CallApplication.last
        expect(call_application.user.first_name).to eq('John')
        expect(call_application.user.last_name).to eq('Doe')
        expect(call_application.user.email).to eq('john@doe.com')
        expect(call_application.artist_website).to eq('https://website.com')
        expect(call_application.artist_instagram_url).to eq('https://instagram.com')
        expect(call_application.artist_statement).to eq('statement')

        sleep 0.5
        new_user = User.find_by(email: "john@doe.com")
        new_artist_email = ActionMailer::Base.deliveries.find { |e| e.to == [new_user.email] }
        expect(new_artist_email.subject).to eq("Thanks for applying to #{call.name}. Confirm your email address with this magic link.")
      end
    end
    context 'logged in' do
      it 'creates a new call_application for the user' do
        login_as(user, scope: :user)
        visit new_call_application_path(call_id: call.id)
        fill_in 'call_application_artist_website', with: 'https://website.com'
        fill_in 'call_application_artist_instagram_url', with: 'https://instagram.com'
        page.execute_script("document.getElementById('call_application_artist_statement').value = 'statement'")
        click_button 'Continue'
        call_application = CallApplication.last
        expect(call_application.category).to be_nil
        expect(call_application.artist_website).to eq('https://website.com')
        expect(call_application.artist_instagram_url).to eq('https://instagram.com')
        expect(call_application.artist_statement).to eq('statement')
      end
      it 'creates with a category' do
        login_as(user, scope: :user)
        call.categories << Category.painting
        visit new_call_application_path(call_id: call.id)
        fill_in 'call_application_artist_website', with: 'https://website.com'
        fill_in 'call_application_artist_instagram_url', with: 'https://instagram.com'
        select 'Painting', from: 'call_application_category_id'
        page.execute_script("document.getElementById('call_application_artist_statement').value = 'statement'")
        click_button 'Continue'
        call_application = CallApplication.last
        expect(call_application.category).to eq(Category.painting)
        expect(call_application.artist_website).to eq('https://website.com')
        expect(call_application.artist_instagram_url).to eq('https://instagram.com')
        expect(call_application.artist_statement).to eq('statement')
      end
    end
  end

end
