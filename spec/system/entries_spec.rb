require 'rails_helper'

RSpec.describe 'Entries', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:call) { FactoryBot.create(:call, user: user) }

  describe 'creating ' do
    context 'not logged in' do
      it 'creates a new call application and user' do
        visit new_entry_path(call_id: call.id)
        fill_in 'entry_user_attributes_first_name', with: 'John'
        fill_in 'entry_user_attributes_last_name', with: 'Doe'
        fill_in 'entry_user_attributes_email', with: 'john@doe.com'
        fill_in 'entry_artist_website', with: 'https://website.com'
        fill_in 'entry_artist_instagram_url', with: 'https://instagram.com'
        page.execute_script("document.getElementById('entry_artist_statement').value = 'statement'")
        click_button 'Continue'
        entry = Entry.last
        expect(entry.user.first_name).to eq('John')
        expect(entry.user.last_name).to eq('Doe')
        expect(entry.user.email).to eq('john@doe.com')
        expect(entry.artist_website).to eq('https://website.com')
        expect(entry.artist_instagram_url).to eq('https://instagram.com')
        expect(entry.artist_statement).to eq('statement')

        sleep 0.5
        new_user = User.find_by(email: "john@doe.com")
        new_artist_email = ActionMailer::Base.deliveries.find { |e| e.to == [new_user.email] }
        expect(new_artist_email.subject).to eq("Thanks for applying to #{call.name}. Confirm your email address with this magic link.")
      end
    end
    context 'logged in' do
      it 'creates a new entry for the user' do
        login_as(user, scope: :user)
        visit new_entry_path(call_id: call.id)
        fill_in 'entry_artist_website', with: 'https://website.com'
        fill_in 'entry_artist_instagram_url', with: 'https://instagram.com'
        page.execute_script("document.getElementById('entry_artist_statement').value = 'statement'")
        click_button 'Continue'
        entry = Entry.last
        expect(entry.category).to be_nil
        expect(entry.artist_website).to eq('https://website.com')
        expect(entry.artist_instagram_url).to eq('https://instagram.com')
        expect(entry.artist_statement).to eq('statement')
      end
      it 'creates with a category' do
        login_as(user, scope: :user)
        call.categories << Category.painting
        visit new_entry_path(call_id: call.id)
        fill_in 'entry_artist_website', with: 'https://website.com'
        fill_in 'entry_artist_instagram_url', with: 'https://instagram.com'
        select 'Painting', from: 'entry_category_id'
        page.execute_script("document.getElementById('entry_artist_statement').value = 'statement'")
        click_button 'Continue'
        entry = Entry.last
        expect(entry.category).to eq(Category.painting)
        expect(entry.artist_website).to eq('https://website.com')
        expect(entry.artist_instagram_url).to eq('https://instagram.com')
        expect(entry.artist_statement).to eq('statement')
      end
    end
  end

  describe 'index' do
    let!(:entry) { create(:entry, user: user) }
    let!(:other_entry) { create(:entry) }

    before do
      login_as(user, scope: :user)
      visit entries_path
    end

    it 'displays the users entries' do
      expect(page).to have_content(entry.call.name)
      expect(page).not_to have_content(other_entry.call.name)
    end
  end

end
