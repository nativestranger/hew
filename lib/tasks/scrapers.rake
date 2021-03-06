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

  task :art_deadline do
    ArtDeadlineBulkSpider.crawl!
  end

  task :zapp do
    ZappBulkSpider.crawl!
  end

  task :resartis do
    ResartisBulkSpider.crawl!
  end

  task :art_guide do
    ArtGuideBulkSpider.crawl!
  end

  task :art_show do
    ArtShowBulkSpider.crawl!
  end
end
