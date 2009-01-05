class IndexerController < ApplicationController
  
  before_filter :set_errors
  
  # show form with rss address field
  def index
    
  end
  
  # accept a POST request and start indexing the supplied rss feed url
  def create
    if rss = fetch_rss_feed(params[:url])
      result = index!(rss[:body])
      flash[:notice] = result == false ? 'No items were indexed. Make sure you entered a valid RSS feed url' : "Indexed #{result} items"
      redirect_to feeds_path
    else
      @errors << 'Invalid URL'
      render :action=>:index
    end
  end
  
  protected
  
  # fetch the rss data
  def fetch_rss_feed(url)
    hclient = RSolr::HTTPClient.connect(url, :curb)
    begin
      hclient.get('')
    rescue
      false
    end
  end
  
  # index into solr
  def index!(rss)
    doc = Hpricot::XML(rss)
    feed_title = (doc/'rss/channel/title').inner_html
    feed_url = (doc/'rss/channel/link').inner_html
    feed_image_url = doc.search('channel/image/url').inner_html
    feed_lang = doc.search('channel/language').inner_html
    items = (doc/:item)
    mapping = {
      # the id of each item is the rss title plus the index of the current item
      :id => proc {|item,index| feed_title + ' - ' + index.to_s },
      
      :title_t => proc {|item,index| item.search(:title).inner_html },
      :url_t => proc{|item,index| item.search(:link).inner_html },
      :published_t => proc{|item,index| item.search(:pubDate).inner_html },
      :description_t => proc{|item,index| item.search(:description).inner_html },
      
      :feed_image_url_t => feed_image_url,
      :feed_url_t => feed_url,
      :feed_title_t => feed_title,
      
      :feed_title_facet => feed_title,
      :feed_language_facet => feed_lang
    }
    
    mapper = RSolr::Mapper::Base.new(mapping)
    mapped_data = mapper.map(items)
    
    return false if mapped_data.size==0
    
    logger.info "Total items to index #{mapped_data.size}"
    
    solr.add(mapped_data)
    solr.commit
    mapped_data.size
  end
  
  def set_errors
    @errors = []
  end
  
end