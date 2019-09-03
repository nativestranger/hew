require 'rails_helper'

RSpec.describe 'Shows', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:show) { FactoryBot.create(:show, user: user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'new' do
    xit 'lets you create' do
      visit new_show_path
      fill_in 'show_name', with: 'Test Show'
      fill_in 'show_overview', with: 'an overview'
      find(:css, '.react-datepicker__day--007').click
      # TODO: this
    end
  end

  describe 'edit' do
    it 'lets you edit' do
      visit edit_show_path(show)
      fill_in 'show_overview', with: 'another overview'
      click_button 'Save'
    end
  end

  describe 'show' do
    it 'shows the show' do
      visit show_path(show)
      expect(page).to have_content(show.name)
    end
  end
end
