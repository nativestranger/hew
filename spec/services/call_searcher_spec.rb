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
  let!(:public_call) { create(:call, :accepting_applications, is_public: true, is_approved: true) }

  context 'without a user' do
    let(:user) { nil }

    it 'only returns approved, published, accepting calls' do
      expect(searcher.records.pluck(:id)).to include(public_call.id)
      expect(searcher.records).not_to include(call)
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
end
