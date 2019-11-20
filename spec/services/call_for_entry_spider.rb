require 'rails_helper'

RSpec.describe CallForEntrySpider, type: :service do
  let(:scraper) { CallForEntrySpider.new }

  describe '#entry_dates, #start_at, #end_at' do
    before { allow(scraper).to receive(:browser).and_return(mock_browser) }

    # unsupported variations seen:
    # 2) Exhibition Runs: March 5, to March. 28, 2020
    # 3) Exhibition Dates: March 28 – May 2, 2020
    #
    # 4) '... available for exhibition between February 20 – April 17, 2020.'
    # 5) Exhibition Dates: Friday, February 14 – Saturday, March 7, 2020
    # 6) Exhibition dates: May 2021 – September 2021
    #
    # 7) (separate lines, one not exactly 'start')
    # Work Due at Yeiser Art Center By: April 4, 2020, by 5pm
    # Close of Show: May 30, 2020
    #
    #
    # 9) (match if same line?)
    # Exhibition and Sale dates: January 24 – February 29, 2020
    #
    # 10) (separate lines)
    # Opening Reception: February 8, 2020   6:00 to 9:00 pm.
    # Close of Show and pick up of art: April 19 - 20, 2020
    #
    # EXHIBITION DATES:
    # Opening Reception is in early January 2020 (exhibition runs through the month of January into early February 2020)
    #
    # 11) (separate lines)
    # The opening reception will be on January 17th, 2020
    # The show runs until February14th. (legit typo...?)
    #
    # Supported variations:
    # 1) Event Dates: 9/11/20 - 1/18/21
    # 2) Exhibition Dates: 4/3/2020-4/24/2020
    # 3) # Gallery Exhibition: January 31– February 29, 2020 (2X - exact spacing)

    context "Event Dates: 9/11/20 - 1/18/21" do
      let(:mock_browser) do
        browser_text = <<-SQL
        Event Dates: 9/11/20 - 1/18/21
        Entry Deadline: 8/25/20
        SQL

        OpenStruct.new(text: browser_text)
      end

      it "returns the expected values" do
        expect(scraper.send(:event_dates)).to eq(["9/11/20", "1/18/21"])
        expect(scraper.send(:start_at)).to eq(Date.new(2020, 9, 11))
        expect(scraper.send(:end_at)).to eq(Date.new(2021, 1, 18))
      end
    end

    # https://artist.callforentry.org/festivals_unique_info.php?ID=6974
    context "Exhibition Dates: 4/3/2020-4/24/2020" do
      let(:mock_browser) do
        browser_text = <<-SQL
        Exhibition Dates: 4/3/2020-4/24/2020
        Entry Deadline: 8/25/20
        SQL

        OpenStruct.new(text: browser_text)
      end

      it "returns the expected values" do
        expect(scraper.send(:event_dates)).to eq(["4/3/2020", "4/24/2020"])
        expect(scraper.send(:start_at)).to eq(Date.new(2020, 4, 3))
        expect(scraper.send(:end_at)).to eq(Date.new(2020, 4, 24))
      end
    end

    context "Gallery Exhibition: January 31– February 29, 2020" do
      let(:mock_browser) do
        browser_text = <<-SQL
        Gallery Exhibition: January 31– February 29, 2020
        Something
        SQL

        OpenStruct.new(text: browser_text)
      end

      it "returns the expected values" do
        expect(scraper.send(:event_dates)).to eq(["January 31", "February 29, 2020"])
        # expect(scraper.send(:start_at)).to eq(Date.new(2020, 1, 31))
        # expect(scraper.send(:end_at)).to eq(Date.new(2020, 2, 29))
      end
    end
  end
end
