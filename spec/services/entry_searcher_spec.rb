require 'rails_helper'

RSpec.describe EntrySearcher, type: :service do
  let(:searcher) do
    EntrySearcher.new(
       call_id: call_id,
       category_ids: category_ids
    )
  end

  let(:call) { create(:call) }
  let(:other_call) { create(:call) }
  let(:call_id) { call.id }
  let(:category_ids) { nil }

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
end
