namespace :solr do
  desc 'Start Solr'
  task :start do
    `cd #{File.dirname(__FILE__)}/../../apache-solr/example && java -jar start.jar`
  end
end