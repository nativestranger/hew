require './config/environment.rb'

namespace :scrapers do
  task :call_for_entry do
    CallForEntrySpider.crawl!
  end
end
