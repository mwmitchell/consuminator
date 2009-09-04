require 'rss'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class Consuminator::Indexer::RSS
  
  # solr is from RSolr.connect
  # rss_url is a url string pointing to an rss feed
  def initialize(solr, rss_url)
    @solr = solr
    @rss_url = rss_url
  end
  
  # index into solr
  def go!(extra_fields=nil)
    return unless (rss = fetch_rss_feed)
    #rss = RSS::Parser.parse(rss[:body], false)
    begin
      mapped_data = map_rss(rss, extra_fields)
    rescue
      raise Consuminator::Indexer::MappingError.new($!)
    end
    @solr.add(mapped_data) and @solr.commit
    mapped_data.size
  end
  
  protected
  
  # creates an array of hashes suitable for being use with RSolr::Mapper
  def map_rss(rss, mapped_item=nil)
    mapped_item = {} unless mapped_item.is_a?(Hash)
    index=-1
    rss.items.collect do |item|
      index += 1
      mapped_item.merge({
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
      })
    end
  end
  
  # fetch the rss data
  def fetch_rss_feed
    RSS::Parser.parse( @rss_url )
  end
  
end