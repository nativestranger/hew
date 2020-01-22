require './config/environment.rb'

namespace :scrapers do
  task :cafe do
    CafeBulkSpider.crawl!
  end

  task :artwork_archive do
    ArtworkArchiveBulkSpider.crawl!
  end

  task :art_deadline do
    ArtDeadlineBulkSpider.crawl!
  end
end
