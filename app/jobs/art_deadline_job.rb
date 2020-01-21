# frozen_string_literal: true

class ArtDeadlineJob < ActiveJob::Base
  def perform(call_id)
    ENV['call_id'] = call_id.to_s # TODO: not this

    ArtDeadlineSpider.crawl!
  end
end
