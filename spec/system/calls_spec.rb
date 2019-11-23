require 'rails_helper'

RSpec.describe 'Calls', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:call) { FactoryBot.create(:call, user: user) }

  before do
    login_as(user, scope: :user)
  end

  def fill_in_call_details
    fill_in 'call_name', with: 'Call name'
    fill_in 'call_overview', with: 'Call overview'

    find('.call_start_at').click
    all(".react-datepicker__day").find { |day| day.text == "7" }.click

    find('.call_end_at').click
    all(".react-datepicker__day").find { |day| day.text == "14" }.click

    find('.call_application_deadline').click
    all(".react-datepicker__day").find { |day| day.text == "1" }.click
    all(".react-datepicker__time-list-item").find { |day| day.text == "12:00 AM" }.click

    page.execute_script("document.getElementById('call_full_description').value = 'desc'")
    page.execute_script("document.getElementById('call_application_details').value = 'app details'")
  end

  def fill_in_venue_details
    fill_in 'call_venue_attributes_name', with: 'Venue name'
    fill_in 'call_venue_attributes_website', with: 'https://venue.com'
    fill_in 'call_venue_attributes_address_attributes_street_address', with: '123 Fake Street'
    fill_in 'call_venue_attributes_address_attributes_postal_code', with: '12345'
  end

  describe 'creating a new call' do
    it 'allows the user to create an exhibition call' do
      visit new_call_path
      select 'Exhibition', from: 'call_call_type_id'
      fill_in_call_details
      fill_in_venue_details
      click_button 'Save'

      expect(page).to have_content 'Success!'

      call = Call.find(page.current_url.split('calls/').last)
      expect(call.name).to eq('Call name')
      expect(call.call_type_id).to eq('exhibition')
      expect(call.venue.name).to eq('Venue name')
      expect(call.venue.address.street_address).to eq('123 Fake Street')
    end

    it 'allows the user to create a residency call' do
      visit new_call_path
      select 'Residency', from: 'call_call_type_id'
      fill_in_call_details
      fill_in_venue_details
      click_button 'Save'

      expect(page).to have_content 'Success!'

      call = Call.find(page.current_url.split('calls/').last)
      expect(call.name).to eq('Call name')
      expect(call.call_type_id).to eq('residency')
      expect(call.venue.name).to eq('Venue name')
      expect(call.venue.address.street_address).to eq('123 Fake Street')
    end

    it 'allows the user to create a publication call' do
      visit new_call_path
      select 'Publication', from: 'call_call_type_id'
      fill_in_call_details
      click_button 'Save'

      expect(page).to have_content 'Success!'

      call = Call.find(page.current_url.split('calls/').last)
      expect(call.name).to eq('Call name')
      expect(call.call_type_id).to eq('publication')
      expect(call.venue).to be_nil
    end

    it 'allows the user to create a competition call' do
      visit new_call_path
      select 'Competition', from: 'call_call_type_id'
      fill_in_call_details
      click_button 'Save'

      expect(page).to have_content 'Success!'

      call = Call.find(page.current_url.split('calls/').last)
      expect(call.name).to eq('Call name')
      expect(call.call_type_id).to eq('competition')
      expect(call.venue).to be_nil
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
