# frozen_string_literal: true

class ZappJob < ApplicationJob
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(ZappSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
