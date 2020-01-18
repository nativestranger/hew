require 'rails_helper'

RSpec.describe CallSearcher, type: :service do
  let(:searcher) do
    CallSearcher.new(
       call_name: call_name,
       user: user,
       call_type_ids: call_type_ids,
       order_option: order_option
    )
  end

  let(:call_name) { nil }
  let(:user) { create(:user) }
  let(:call_type_ids) { nil }
  let(:order_option) { nil }

  let!(:call) { create(:call) }
  let!(:public_call) { create(:call, :accepting_entries, is_public: true, is_approved: true) }

  context 'without a user' do
    let(:user) { nil }

    it 'only returns approved, published, accepting calls' do
      expect(searcher.records.pluck(:id)).to include(public_call.id)
      expect(searcher.records).not_to include(call)
    end
  end

  context 'with a user' do
    let!(:owner_call) { create(:call, user: user) }
    let!(:juror_call) { create(:call_user, user: user, role: :juror).call }
    let!(:director_call) { create(:call_user, user: user, role: :director).call }
    let!(:admin_call) { create(:call_user, user: user, role: :admin).call }
    it 'only returns calls with call_users' do
      expect(searcher.records).not_to include(call)
      expect(searcher.records).not_to include(public_call)
      expect(searcher.records.pluck(:id)).to include(owner_call.id)
      expect(searcher.records.pluck(:id)).to include(juror_call.id)
      expect(searcher.records.pluck(:id)).to include(director_call.id)
      expect(searcher.records.pluck(:id)).to include(admin_call.id)
    end
  end

  context 'without a call name' do
    let(:call_name) { 'Media' }
    let!(:named_call) { create(:call, user: user, name: 'New Media Hackathon') }

    it 'searches on name' do
      expect(searcher.records.pluck(:id)).to include(named_call.id)
      named_call.update!(name: 'other')
      expect(searcher.records.pluck(:id)).not_to include(named_call.id)
    end
  end

  context 'with call_type_ids' do
    let(:call_type_ids) do
      [ Call.call_type_ids['exhibition'],
        Call.call_type_ids['publication'] ]
    end
    let!(:exhibition) { create(:call, user: user, call_type_id: 'exhibition') }
    let!(:residency) { create(:call, user: user, call_type_id: 'residency') }
    let!(:publication) { create(:call, user: user, call_type_id: 'publication') }

    it 'searches on call_type_ids' do
      expect(searcher.records.pluck(:id)).to include(exhibition.id)
      expect(searcher.records.pluck(:id)).to include(publication.id)
      expect(searcher.records.pluck(:id)).not_to include(residency.id)
    end
  end

  context 'with order options' do
    def order_option_for(name)
      helpers.call_order_options.find {|oo| oo[:name] == name }
    end
    context 'Soonest deadline' do
      let(:order_option) { order_option_for('Deadline (soonest)') }

      let!(:soon_call) { create(:call, user: user, entry_deadline: 1.day.from_now) }
      let!(:far_call) { create(:call, user: user, entry_deadline: 1.week.from_now) }
      let!(:farther_call) { create(:call, user: user, entry_deadline: 1.month.from_now) }

      it 'sorts as expected' do
        expect(searcher.records.map(&:id)).to eq(
          [ soon_call, far_call, farther_call ].map(&:id)
        )
      end
    end
    context 'Deadline (furthest)' do
      let(:order_option) { order_option_for('Deadline (furthest)') }

      let!(:soon_call) { create(:call, user: user, entry_deadline: 1.day.from_now) }
      let!(:far_call) { create(:call, user: user, entry_deadline: 1.week.from_now) }
      let!(:farther_call) { create(:call, user: user, entry_deadline: 1.month.from_now, start_at: 2.months.from_now.to_date) }

      it 'sorts as expected' do
        expect(searcher.records.map(&:id)).to eq(
          [ farther_call, far_call, soon_call ].map(&:id)
        )
      end
    end
    context 'Newest' do
      let(:order_option) { order_option_for('Newest') }

      let!(:new_call) { create(:call, user: user, created_at: Time.current) }
      let!(:old_call) { create(:call, user: user, created_at: 1.week.ago) }
      let!(:farther_call) { create(:call, user: user, entry_deadline: 1.month.from_now, start_at: 2.months.from_now.to_date) }

      it 'sorts as expected' do
        expect(searcher.records.map(&:id)).to eq(
          [ new_call, old_call, oldest_call ].map(&:id)
        )
      end
    end
  end
end
