# frozen_string_literal: true

class CallForEntryJob < ActiveJob::Base
  def perform(call_id)
    ENV['call_id'] = call_id.to_s # TODO: not this

    CafeSpider.crawl!
  end
end
