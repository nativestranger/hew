# frozen_string_literal: true

class ArtDeadlineJob < ActiveJob::Base
  def perform(call_id)
    call = Call.find(call_id)
    klass = Class.new(ArtDeadlineSpider)
    klass.setup_call(call)
    klass.crawl!
  end
end
