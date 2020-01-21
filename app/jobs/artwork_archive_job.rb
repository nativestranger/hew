# frozen_string_literal: true

class ArtworkArchiveJob < ActiveJob::Base
  def perform(call_id)
    ENV['call_id'] = call_id.to_s # TODO: not this

    ArtworkArchiveSpider.crawl!
  end
end
