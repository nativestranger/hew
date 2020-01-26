require 'rails_helper'

RSpec.describe CallSearcher, type: :service do
  let(:searcher) do
    CallSearcher.new(
       call_name: call_name,
       user: user,
       approved: approved,
       published: published,
       spiders: spiders,
       call_type_ids: call_type_ids,
       order_option: order_option,
       entry_deadline_start: entry_deadline_start,
       entry_deadline_end: entry_deadline_end
    )
  end

  let(:call_name) { nil }
  let(:user) { create(:user) }
  let(:approved) { nil }
  let(:published) { nil }
  let(:spiders) { nil }
  let(:order_option) { nil }
  let(:call_type_ids) { nil }
  let(:entry_deadline_start) { nil }
  let(:entry_deadline_end) { nil }

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

  context 'with approved' do
    let!(:approved_call) { create(:call, user: user, is_approved: true) }
    let!(:not_approved_call) { create(:call, user: user, is_approved: false) }

    context 'approved' do
      let(:approved) { true }
      it 'shows approved' do
        expect(searcher.records.pluck(:id)).to include(approved_call.id)
        expect(searcher.records.pluck(:id)).not_to include(not_approved_call.id)
      end
    end

    context 'not approved' do
      let(:approved) { false }
      it 'shows not approved' do
        expect(searcher.records.pluck(:id)).not_to include(approved_call.id)
        expect(searcher.records.pluck(:id)).to include(not_approved_call.id)
      end
    end
  end

  context 'with published' do
    let!(:published_call) { create(:call, user: user, is_public: true) }
    let!(:not_published_call) { create(:call, user: user, is_public: false) }

    context 'published' do
      let(:published) { true }
      it 'shows published' do
        expect(searcher.records.pluck(:id)).to include(published_call.id)
        expect(searcher.records.pluck(:id)).not_to include(not_published_call.id)
      end
    end

    context 'not published' do
      let(:published) { false }
      it 'shows not published' do
        expect(searcher.records.pluck(:id)).not_to include(published_call.id)
        expect(searcher.records.pluck(:id)).to include(not_published_call.id)
      end
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

  context 'with spiders' do
    let(:spiders) do
      [ Call.spiders['call_for_entry'],
        Call.spiders['art_deadline'] ]
    end
    let!(:call_for_entry) { create(:call, user: user, spider: 'call_for_entry') }
    let!(:art_deadline) { create(:call, user: user, spider: 'art_deadline') }
    let!(:zapplication) { create(:call, user: user, spider: 'zapplication') }

    it 'searches on spiders' do
      expect(searcher.records.pluck(:id)).to include(call_for_entry.id)
      expect(searcher.records.pluck(:id)).to include(art_deadline.id)
      expect(searcher.records.pluck(:id)).not_to include(zapplication.id)
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
      let!(:farther_call) { create(:call, user: user, entry_deadline: 1.month.from_now, start_at: 2.months.from_now.to_date) }

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
      let!(:oldest_call) { create(:call, user: user, created_at: 1.month.ago) }

      it 'sorts as expected' do
        expect(searcher.records.map(&:id)).to eq(
          [ new_call, old_call, oldest_call ].map(&:id)
        )
      end
    end
  end

  context 'with entry_deadline options' do
    let!(:late) { create(:call, :old, user: user) }
    let!(:soon) { create(:call, :accepting_entries, user: user) }
    let!(:future) { create(:call, :future, user: user) }

    context 'with start' do
      let(:entry_deadline_start) { late.entry_deadline + 1.day }
      it 'returns calls with entry_deadline after entry_deadline_start' do
        expect(searcher.records.pluck(:id)).not_to include(late.id)
        expect(searcher.records.pluck(:id)).to include(soon.id)
        expect(searcher.records.pluck(:id)).to include(future.id)
      end
    end

    context 'with end' do
      let(:entry_deadline_end) { future.entry_deadline - 1.day }
      it 'returns calls with entry_deadline before entry_deadline_end' do
        expect(searcher.records.pluck(:id)).to include(late.id)
        expect(searcher.records.pluck(:id)).to include(soon.id)
        expect(searcher.records.pluck(:id)).not_to include(future.id)
      end
    end

    context 'with both' do
      let(:entry_deadline_start) { late.entry_deadline + 1.day }
      let(:entry_deadline_end) { future.entry_deadline - 1.day }
      it 'returns calls with entry_deadline between start and end' do
        expect(searcher.records.pluck(:id)).not_to include(late.id)
        expect(searcher.records.pluck(:id)).to include(soon.id)
        expect(searcher.records.pluck(:id)).not_to include(future.id)
      end
    end
  end
end
