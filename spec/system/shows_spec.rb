require 'rails_helper'

RSpec.describe 'Shows', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:show) { FactoryBot.create(:show, user: user) }

  before do
    # login_as(user, scope: :user)
  end

  describe 'new' do
    it 'renders the new template' do
      visit new_show_path
    end
  end

  describe 'edit' do
    it 'renders the edit template' do
      visit edit_show_path(show)
    end
  end

  describe 'index' do
    it 'displays the shows' do
      show
      visit shows_path
    end
  end

  describe 'show' do
    it 'shows the show' do
      visit show_path(show)
      expect(page).to have_content(show.name)
    end
  end
end
