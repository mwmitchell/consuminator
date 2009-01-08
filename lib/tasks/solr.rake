namespace :solr do
  desc 'Copies the default solr schema and config to the given directory'
  task :copy_configs do
    Dir[File.join(File.dirname(__FILE__), 'solr-configs', '*.xml'].each do |f|
      
    end
  end
end