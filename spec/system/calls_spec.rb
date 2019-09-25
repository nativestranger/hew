require 'rails_helper'

RSpec.describe 'Calls', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:call) { FactoryBot.create(:call, user: user) }

  before do
    login_as(user, scope: :user)
  end

  describe 'new' do
    it 'renders the new template' do
      visit new_call_path
    end
  end

  describe 'edit' do
    it 'renders the edit template' do
      visit edit_call_path(call)
    end
  end

  describe 'show' do
    it 'shows the call' do
      visit call_path(call)
      expect(page).to have_content(call.name)
    end
  end
end
