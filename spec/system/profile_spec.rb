require 'rails_helper'

RSpec.describe 'settings#profile', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  it 'allows us to update our profile' do
    visit settings_profile_path
    fill_in 'user_instagram_url', with: 'https://instagram.com'
    check 'user_is_artist'
    fill_in 'user_artist_website', with: 'https://website.com'
    click_button 'Save'
    expect(user.reload.instagram_url).to eq('https://instagram.com')
    expect(user.artist_website).to eq('https://website.com')
  end
end
