# desc "Explaining what the task does"
# task :consuminator do
#   # Task goes here
# end
namespace :consuminator do
  
  desc 'Index an rss feed'
  task :import_rss=>:environment do
    raise "The URL ENV variable is required. Example: rake consuminator:import_rss URL=http://xx.com/feeds.rss" if ENV['URL'].to_s.empty?
    rss_indexer = Consuminator::Indexer::RSS.new(Consuminator.solr, ENV['URL'])
    begin
      total_indexed = rss_indexer.go!(:tags_facet=>ENV['TAGS'].to_s.split(','))
      if total_indexed
        puts "Indexed #{total_indexed} items"
      else
        puts 'No items were indexed. Are you sure entered a valid RSS 2.0 feed url?'
      end
    rescue Consuminator::Indexer::MappingError
      puts "Mapping Error: #{$!}"
    end
  end
  
end