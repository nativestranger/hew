# frozen_string_literal: true

class CallForEntryJob < ActiveJob::Base
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(CafeSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
