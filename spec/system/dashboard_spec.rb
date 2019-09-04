require 'rails_helper'

RSpec.describe 'dashboard', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:upcoming_show) { FactoryBot.create(:show, :upcoming, user: user) }
  let!(:current_show) { FactoryBot.create(:show, :current, user: user) }
  let!(:old_show) { FactoryBot.create(:show, :old, user: user) }
  let!(:show) { FactoryBot.create(:show, user: user) }

  let!(:accepted_application) { FactoryBot.create(:show_application, status_id: :accepted, show: FactoryBot.create(:show, :current), user: user) }
  let!(:pending_application) { FactoryBot.create(:show_application, status_id: [:fresh, :maybe].sample, show: FactoryBot.create(:show, :accepting_applications), user: user) }
  let!(:past_application) { FactoryBot.create(:show_application, user: user, show: FactoryBot.create(:show, :old)) }
  let!(:past_accepted_application) { FactoryBot.create(:show_application, status_id: :accepted, user: user, show: FactoryBot.create(:show, :old)) }

  before do
    login_as(user, scope: :user)
  end

  describe 'curator dashboard' do
    it 'renders the curator dashboard' do
      visit dashboard_path
      expect(page.body).to have_content(show.name)
      find(:css, '#current').click
      sleep 0.5
      expect(page.body).to have_content(current_show.name)
    end
  end

  describe 'artist dashboard' do
    it 'renders the artist dashboard' do
      visit dashboard_path(as_artist: true)
      expect(page.body).to have_content(pending_application.show.name)
      find(:css, '#accepted_and_active').click
      sleep 0.5
      expect(page.body).to have_content(accepted_application.show.name)
      find(:css, '#past').click
      sleep 0.5
      expect(page.body).to have_content(past_application.show.name)
      expect(page.body).to have_content(past_accepted_application.show.name)
    end
  end
end
