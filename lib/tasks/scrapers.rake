require './config/environment.rb'

namespace :scrapers do
  task :cafe do
    CafeBulkSpider.crawl!
  end

  task :artwork_archive do
    ArtworkArchiveSpider.crawl!
  end

  task :art_deadline do
    ArtDeadlineSpider.crawl!
  end
end
