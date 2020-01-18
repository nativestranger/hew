require 'rails_helper'

RSpec.describe 'Calls', type: :system do
  let(:user) { create(:user) }

  let(:call) do
    create(:call, user: user, categories: categories)
  end

  let(:juror) { create(:call_user, call: call, role: 'juror').user }
  let(:director) { create(:call_user, call: call, role: 'director').user }
  let(:call_admin) { create(:call_user, call: call, role: 'admin').user }

  let!(:submitted_entry) do
    create(
      :entry,
      call: call,
      creation_status: 'submitted',
      category: Category.new_media
    )
  end

  let!(:started_entry) do
    create(
      :entry,
      call: call,
      category: Category.painting
    )
  end

  let(:categories) { [] }

  before do
    login_as(user, scope: :user)
  end

  def fill_in_call_details
    fill_in 'call_name', with: 'Call name'
    fill_in 'call_overview', with: 'Call overview'

    find('.call_application_deadline').click
    find('.react-datepicker__navigation--next').click
    all(".react-datepicker__day").find { |day| day.text == "3" }.click
    all(".react-datepicker__time-list-item").find { |day| day.text == "12:00 AM" }.click

    find('.call_start_at').click
    find('.react-datepicker__navigation--next').click
    all(".react-datepicker__day").find { |day| day.text == "4" }.click

    find('.call_end_at').click
    find('.react-datepicker__navigation--next').click
    all(".react-datepicker__day").find { |day| day.text == "5" }.click

    page.execute_script("document.getElementById('call_description').value = 'desc'")
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
      find('.call_start_at').click
      all(".react-datepicker__day").find { |day| day.text =="8" }.click
      click_button 'Save'
      expect(call.reload.start_at.day).to eq(8)
      expect(call.reload.end_at.day).not_to eq(9) # need to fix datepicker issue & remove/change

      visit edit_call_path(call)
      find('.call_end_at').click
      all(".react-datepicker__day").find { |day| day.text =="9" }.click
      click_button 'Save'
      expect(call.reload.start_at.day).to eq(8)
      expect(call.reload.end_at.day).to eq(9)
    end

    it 'deletes call_category_users when categories are removed' do
      call.categories << Category.new_media

      create(
        :call_category_user,
        call_user: call.call_users.find_by!(user: juror),
        call_category: call.call_categories.find_by!(category: Category.new_media)
      )

      expect(call.call_users.find_by!(user: juror).categories).to eq([Category.new_media])
      expect(call.categories).to eq([Category.new_media])

      visit edit_call_path(call)
      # TODO: add ability to remove specific categories
      page.all(:xpath, "//span[@class='select2-selection__choice__remove']").first.click

      click_button 'Save'

      expect(call.call_users.find_by!(user: juror).reload.categories).to be_empty
      expect(call.reload.categories).to be_empty
    end
  end

  describe 'show' do
    it 'shows the call' do
      visit call_path(call)
      expect(page).to have_content(call.name)
    end
  end

  describe 'index' do
    let!(:juror_call) { create(:call_user, user: user, role: 'juror').call }
    let!(:director_call) { create(:call_user, user: user, role: 'director').call }
    let!(:admin_call) { create(:call_user, user: user, role: 'admin').call }
    let!(:other_call) { create(:call) }

    before { visit calls_path }

    it 'displays calls the user has call_users with' do
      expect(page).to have_content(call.name)
      expect(page).to have_content(juror_call.name)
      expect(page).to have_content(director_call.name)
      expect(page).to have_content(admin_call.name)
      expect(page).not_to have_content(other_call.name)
    end

    # TODO: test sorting/filtering
  end

  describe '#entries' do
    context 'as a juror' do
      before do
        login_as(juror, scope: :user)
        visit call_entries_path(call)
      end

      it 'shows the submitted call entries' do
        expect(page).to have_content(submitted_entry.user.full_name)
        expect(page).not_to have_content(started_entry.user.full_name)
      end

      context 'with categories' do
        let(:categories) do
          [Category.painting, Category.new_media]
        end

        it "shows the call entries for the juror's categories if any" do
          expect(page).to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)
          create(
            :call_category_user,
            call_user: call.call_users.find_by!(user: juror),
            call_category: call.call_categories.find_by!(category: Category.new_media)
          )

          visit current_path
          expect(page).not_to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)

          submitted_entry.update!(category: Category.painting) # not in juror categories
          visit current_path
          expect(page).not_to have_content(submitted_entry.user.full_name)
        end
      end
    end

    context 'as a director' do
      before do
        login_as(director, scope: :user)
        visit call_entries_path(call)
      end

      it 'shows the submitted call entries' do
        expect(page).to have_content(submitted_entry.user.full_name)
        expect(page).not_to have_content(started_entry.user.full_name)
      end

      context 'with categories' do
        let(:categories) do
          [Category.painting, Category.new_media]
        end

        it "shows the call entries for the director's categories if any" do
          expect(page).to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)
          create(
            :call_category_user,
            call_user: call.call_users.find_by!(user: director),
            call_category: call.call_categories.find_by!(category: Category.new_media)
          )

          visit current_path
          expect(page).not_to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)

          submitted_entry.update!(category: Category.painting) # not in juror categories
          visit current_path
          expect(page).not_to have_content(submitted_entry.user.full_name)
        end
      end
    end

    # same as owner
    context 'as an admin' do
      before do
        login_as(call_admin, scope: :user)
        visit call_entries_path(call)
      end

      it 'shows the submitted call entries' do
        expect(page).to have_content(submitted_entry.user.full_name)
        expect(page).not_to have_content(started_entry.user.full_name)
      end

      context 'with categories' do
        let(:categories) do
          [Category.painting, Category.new_media]
        end

        it "shows all call entries regardless of acall_dmin's categories" do
          expect(page).to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)
          create(
            :call_category_user,
            call_user: call.call_users.find_by!(user: call_admin),
            call_category: call.call_categories.find_by!(category: Category.new_media)
          )

          visit current_path
          expect(page).to have_content(Category.painting)
          expect(page).to have_content(Category.new_media)
          expect(page).to have_content(submitted_entry.user.full_name)

          submitted_entry.update!(category: Category.painting) # not in call_admin categories
          visit current_path
          expect(page).to have_content(submitted_entry.user.full_name)
        end
      end
    end
  end
end
