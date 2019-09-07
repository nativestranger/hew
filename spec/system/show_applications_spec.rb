require 'rails_helper'

RSpec.describe 'ShowApplications', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:show) { FactoryBot.create(:show, user: user) }

  describe 'creating ' do
    context 'not logged in' do
      it 'creates a new show application and user' do
        visit new_show_application_path(show_id: show.id)
        fill_in 'show_application_user_attributes_first_name', with: 'John'
        fill_in 'show_application_user_attributes_last_name', with: 'Doe'
        fill_in 'show_application_user_attributes_email', with: 'john@doe.com'
        fill_in 'show_application_artist_website', with: 'https://website.com'
        fill_in 'show_application_artist_instagram_url', with: 'https://instagram.com'
        fill_in 'show_application_photos_url', with: 'https://photos.com'
        fill_in 'show_application_supplemental_material_url', with: 'https://things.com'
        page.execute_script("document.getElementById('show_application_artist_statement').value = 'statement'")
        click_button 'Submit'
        show_application = ShowApplication.last
        expect(show_application.user.first_name).to eq('John')
        expect(show_application.user.last_name).to eq('Doe')
        expect(show_application.user.email).to eq('john@doe.com')
        expect(show_application.artist_website).to eq('https://website.com')
        expect(show_application.artist_instagram_url).to eq('https://instagram.com')
        expect(show_application.photos_url).to eq('https://photos.com')
        expect(show_application.supplemental_material_url).to eq('https://things.com')
        expect(show_application.artist_statement).to eq('statement')
      end
    end
    context 'logged in' do
      it 'creates a new show application and user' do
        login_as(user, scope: :user)
        visit new_show_application_path(show_id: show.id)
        fill_in 'show_application_artist_website', with: 'https://website.com'
        fill_in 'show_application_artist_instagram_url', with: 'https://instagram.com'
        fill_in 'show_application_photos_url', with: 'https://photos.com'
        fill_in 'show_application_supplemental_material_url', with: 'https://things.com'
        page.execute_script("document.getElementById('show_application_artist_statement').value = 'statement'")
        click_button 'Submit'
        show_application = ShowApplication.last
        expect(show_application.artist_website).to eq('https://website.com')
        expect(show_application.artist_instagram_url).to eq('https://instagram.com')
        expect(show_application.photos_url).to eq('https://photos.com')
        expect(show_application.supplemental_material_url).to eq('https://things.com')
        expect(show_application.artist_statement).to eq('statement')
      end
    end
  end


end
