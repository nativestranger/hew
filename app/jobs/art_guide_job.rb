# frozen_string_literal: true

class ArtGuideJob < ApplicationJob
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(ArtGuideSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
