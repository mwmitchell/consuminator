namespace :consuminator do
  desc 'Copies the default Consuminator Solr schema and config to the current directory'
  task :export_solr_configs do
    Dir[File.join(File.dirname(__FILE__), 'solr-configs', '*.xml')].each do |f|
      `cp #{f} .`
    end
    puts "Files copied to #{File.expand_path('.')}"
  end
end