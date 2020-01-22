# frozen_string_literal: true

class ArtworkArchiveJob < ApplicationJob
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(ArtworkArchiveSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
