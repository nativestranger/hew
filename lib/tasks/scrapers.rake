require './config/environment.rb'

namespace :scrapers do
  task :call_for_entry do
    CallForEntrySpider.crawl!
  end

  task :artwork_archive do
    ArtworkArchiveSpider.crawl!
  end

  task :art_deadline do
    ArtDeadlineSpider.crawl!
  end
end
