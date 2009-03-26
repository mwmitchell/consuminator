# desc "Explaining what the task does"
# task :consuminator do
#   # Task goes here
# end
namespace :consuminator do
  
  desc 'Copies the default Solr schema and config to the current directory'
  task :export_solr_configs do
    Dir[File.join('vendor', 'plugins', 'consuminator', 'solr-configs', '*.xml')].each do |f|
      FileUtils.cp(f, '.')
    end
    puts "Solr config files copied to ./"
  end
  
  desc 'Copies the web asset files to the host app'
  task :sync_assets=>:environment do
    Dir[File.join(File.dirname(__FILE__), '..', 'assets', '*')].each do |entry|
      name = File.basename(entry)
      next if name=~/^\./
      puts "Copying assets to public/#{name}/consuminator"
      base_to_dir = File.join(RAILS_ROOT, 'public', name, 'consuminator')
      FileUtils.mkdir_p base_to_dir
      FileUtils.cp_r "#{entry}/.", base_to_dir
    end
  end
  
  desc 'Index an rss feed'
  task :import_rss=>:environment do
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