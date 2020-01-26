# frozen_string_literal: true

class ResartisJob < ApplicationJob
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(ResartisSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
