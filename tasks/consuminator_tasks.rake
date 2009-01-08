# desc "Explaining what the task does"
# task :consuminator do
#   # Task goes here
# end
namespace :consuminator do
  desc 'Copies the default Consuminator Solr schema and config to the current directory'
  task :export_solr_configs do
    Dir[File.join('vendor', 'plugins', 'consuminator', 'solr-configs', '*.xml')].each do |f|
      `cp #{f} ./`
    end
    puts "Files copied to ./"
  end
end