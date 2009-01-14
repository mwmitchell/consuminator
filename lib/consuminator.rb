require 'rss/1.0'
require 'rss/2.0'

module Consuminator
  
  #
  #
  #
  module Helpers
    
    def self.included(base)
      base.helper_method :solr, :solr_facet_fields, :add_facet_params, :remove_facet_params, :facet_in_params?, :object_type_indexer_partials
    end
    
    def solr
      @solr ||= RSolr.connect
    end
    
    def solr_facet_fields
      @solr_facet_fields ||= (
        solr.index_info.field_list(/_facet/)
      )
    end
    
    # These are mainly used by the views to add/remove facets etc..
    
    def object_type_indexer_partials
      ActionController::Base.view_paths.collect do |path|
        Dir[File.join(path, 'indexer', '_object_types', '_*.html.erb')].collect{|f| f.sub(path, '') }
      end.flatten
    end
    
    def add_facet_params(field, value)
      p = params.dup
      p.delete :page
      p[:f]||={}
      p[:f][field] ||= []
      p[:f][field].push(value)
      p
    end

    def remove_facet_params(field, value)
      p=params.dup
      p.delete :page
      p[:f][field] = p[:f][field] - [value]
      p
    end

    def facet_in_params?(field, value)
      params[:f] and params[:f][field] and params[:f][field].include?(value)
    end
    
  end
  
  #
  #
  #
  class RSSIndexer
    
    class MappingError < RuntimeError; end
    
    # solr is from RSolr.connect
    # rss_url is a url string pointing to an rss feed
    def initialize(solr, rss_url)
      @solr = solr
      @rss_url = rss_url
    end
    
    # index into solr
    def go!(extra_fields=nil)
      return unless (rss = fetch_rss_feed)
      rss = RSS::Parser.parse(rss[:body], false)
      begin
        mapped_data = map_rss(rss)
      rescue
        raise MappingError.new($!)
      end
      @solr.add(mapped_data) and @solr.commit
      mapped_data.size
    end
    
    protected
    
    # creates an array of hashes suitable for being use with RSolr::Mapper
    def map_rss(rss)
      index=0
      rss.items.collect do |item|
        {
          :object_type_facet=>'rss',
          :language_facet => rss.channel.language,
          :title_facet=>rss.channel.title,
        
          :image_url_t => (rss.channel.image.url rescue rss.channel.image rescue nil),
          :published_t => rss.channel.date,
        
          :url_s=>rss.channel.link,
        
          :total_i=>rss.items.size,
        
          :id => rss.channel.title + ' - ' + index.to_s,
          :item_title_t => item.title,
          :item_link_t => item.link,
          :item_description_t => item.description
        }
        index += 1
      end
    end
    
    # fetch the rss data
    def fetch_rss_feed
      begin
        hclient = RSolr::HTTPClient.connect(@rss_url, :curb)
        hclient.get('')
      rescue
        false
      end
    end
    
  end
  
end