require 'rails_helper'

RSpec.describe 'dashboard', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:upcoming_call) { FactoryBot.create(:call, :upcoming, user: user) }
  let!(:current_call) { FactoryBot.create(:call, :current, user: user) }
  let!(:old_call) { FactoryBot.create(:call, :old, user: user) }
  let!(:call) { FactoryBot.create(:call, :accepting_applications, user: user) }

  let!(:accepted_application) { FactoryBot.create(:call_application, status_id: :accepted, call: FactoryBot.create(:call, :current), user: user) }
  let!(:pending_application) { FactoryBot.create(:call_application, status_id: [:fresh, :maybe].sample, call: FactoryBot.create(:call, :accepting_applications), user: user) }
  let!(:past_application) { FactoryBot.create(:call_application, user: user, call: FactoryBot.create(:call, :old)) }
  let!(:past_accepted_application) { FactoryBot.create(:call_application, status_id: :accepted, user: user, call: FactoryBot.create(:call, :old)) }

  before do
    login_as(user, scope: :user)
  end

  describe 'curator dashboard' do
    # it 'renders the curator dashboard' do
    #   visit dashboard_path
    #   expect(page.body).to have_content(call.name)
    #   find(:css, '#current').click
    #   sleep 0.5
    #   expect(page.body).to have_content(current_call.name)
    #   find(:css, '#upcoming').click
    #   sleep 0.5
    #   expect(page.body).to have_content(upcoming_call.name)
    #   find(:css, '#past').click
    #   sleep 0.5
    #   expect(page.body).to have_content(old_call.name)
    # end
  end

  describe 'artist dashboard' do
    # it 'renders the artist dashboard' do
    #   visit dashboard_path(as_artist: true)
    #   expect(page.body).to have_content(pending_application.call.name)
    #   find(:css, '#accepted_and_active').click
    #   sleep 0.5
    #   expect(page.body).to have_content(accepted_application.call.name)
    #   find(:css, '#past').click
    #   sleep 0.5
    #   expect(page.body).to have_content(past_application.call.name)
    #   expect(page.body).to have_content(past_accepted_application.call.name)
    # end
  end
end
