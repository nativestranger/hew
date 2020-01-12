require 'rails_helper'

RSpec.describe EntrySearcher, type: :service do
  let(:searcher) do
    EntrySearcher.new(
       call_id: call_id,
       category_ids: category_ids,
       status_ids: status_ids
    )
  end

  let(:call) { create(:call) }
  let(:other_call) { create(:call) }
  let(:call_id) { call.id }
  let(:category_ids) { nil }
  let(:status_ids) { nil }

  let!(:call_application) { create(:call_application) }

  context 'without a call_id' do
    let(:call_id) { nil }

    it 'raises' do
      expect { searcher.records }.to raise_error
    end
  end

  context 'with category_ids' do
    let(:category_ids) { [Category.painting, Category.new_media].map(&:id) }

    before do
      call_category_ids = \
        [ Category.painting, Category.new_media, Category.drawing].map(&:id)

      call.update!(category_ids: call_category_ids)
    end

    let!(:painting_entry) { create(:call_application, call: call, category: Category.painting) }
    let!(:new_media_entry) { create(:call_application, call: call, category: Category.new_media) }
    let!(:drawing_entry) { create(:call_application, call: call, category: Category.drawing) }

    it 'searches on category_ids' do
      expect(searcher.records.pluck(:id)).to include(painting_entry.id)
      expect(searcher.records.pluck(:id)).to include(new_media_entry.id)
      expect(searcher.records.pluck(:id)).not_to include(drawing_entry.id)
    end
  end

  context 'with status_ids' do
    let(:status_ids) do
      [ CallApplication.status_ids['fresh'],
        CallApplication.status_ids['accepted'] ]
    end
    let!(:fresh) { create(:call_application, call: call, status_id: 'fresh') }
    let!(:accepted) { create(:call_application, call: call, status_id: 'accepted') }
    let!(:rejected) { create(:call_application, call: call, status_id: 'rejected') }

    it 'searches on status_ids' do
      expect(searcher.records.pluck(:id)).to include(fresh.id)
      expect(searcher.records.pluck(:id)).to include(accepted.id)
      expect(searcher.records.pluck(:id)).not_to include(rejected.id)
    end
  end
end
