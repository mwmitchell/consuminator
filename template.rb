puts "\n\n** Consuminator Template **\n\n"

plugin :engines, :git=>'git://github.com/lazyatom/engines.git'
plugin :consuminator, :git=>'git://github.com/mwmitchell/consuminator.git'

def modify_env_for_engines_boot!
  rails_boot = "require File.join(File.dirname(__FILE__), 'boot')"
  # use Regexp.escape here?
  rails_boot_regexp = /require File\.join\(File\.dirname\(__FILE__\), 'boot'\)/
  engines_boot = "require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')"
  env_data = File.read('config/environment.rb')
  env_data = env_data.sub(rails_boot_regexp, "#{rails_boot}\n#{engines_boot}")
  puts "** Adding engines boot to config/environment.rb"
  File.open('config/environment.rb', 'w') {|f| f.puts env_data }
end

modify_env_for_engines_boot!

begin
  if ask("Would you like to download and configure Apache Solr now? (yes/no)") =~ /y/i
    require 'open-uri'
    base_url = 'http://people.apache.org/builds/lucene/solr/nightly'
    open base_url do |f|
      release = f.read.to_s.scan(/href="(solr-.*\.tgz)"/).flatten.last
      puts "\n** Downloading Apache Solr Nightly Release: #{base_url}/#{release}\n\n"
      cmds = []
      cmds << "curl -L #{base_url}/#{release} > #{release}"
      cmds << "tar xfzv ./#{release}"
      cmds << "mv ./apache-solr-nightly/example jetty"
      cmds << "rm -Rf ./apache-solr-nightly"
      cmds << "rm #{release}"
      cmds << "cp vendor/plugins/consuminator/solr-configs/*.xml ./jetty/solr/conf/"
      run cmds.join('; ')
    end
  else
    puts "** Skipping Solr installation..."
  end
rescue
  puts "** Solr download failed..."
  puts "** You'll need to download acopy of solr, \ncopy the Consuminator solr-configs/solrconfig.xml\n and solr-configs/schema.xml files into your solr/conf directory."
end

puts "** Installing required Ruby Gems..."
rake "gems:install"#, :sudo => true