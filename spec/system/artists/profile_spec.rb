require 'rails_helper'

RSpec.describe 'artist_profile', type: :system do
  let!(:artist_user) { create(:user, is_artist: true) }
  let!(:other_user) { create(:user) }

  context 'as the artist_user' do
    before do
      login_as(artist_user, scope: :user)
    end

    it 'lets the artist_user set their artist_statement' do
      visit root_path
      click_link 'My Portfolio'
      click_link 'Statement'
      click_link 'Add my statement'

      sleep 0.5
      page.execute_script("document.getElementById('user_artist_statement').value = 'statement'")

      click_button 'Save My Artist Statement'
      expect(page).to have_content('Success')
      expect(page).to have_content('Artist Statement')
      expect(artist_user.reload.artist_statement).to eq('statement')
    end

    it 'lets the artist_user set their bio' do
      visit root_path
      click_link 'My Portfolio'
      click_link 'Bio'
      click_link 'Add my bio'

      sleep 0.5
      page.execute_script("document.getElementById('user_bio').value = 'bio'")

      click_button 'Save My Bio'
      expect(page).to have_content('Success')
      expect(page).to have_content('Bio')
      expect(artist_user.reload.bio).to eq('bio')
    end
  end

  context 'as a different user' do
    before do
      login_as(other_user, scope: :user)
    end

    it 'shows the artist_user profile but does not allow editing' do
      visit artist_profile_path(artist_user)
      expect(page).to have_content("#{artist_user.full_name} hasn't added any pieces yet.")
      click_link 'Bio'
      expect(page).not_to have_content('Add my bio')
    end
  end

  context 'unauthenticated' do
    it 'shows the artist_user profile but does not allow editing' do
      visit artist_profile_path(artist_user)
      expect(page).to have_content("#{artist_user.full_name} hasn't added any pieces yet.")
      click_link 'Bio'
      expect(page).not_to have_content('Add my bio')
    end
  end
end
