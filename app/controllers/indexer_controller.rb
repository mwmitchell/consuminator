class IndexerController < ApplicationController
  
  before_filter :set_errors
  
  # show form
  def index
    
  end
  
  # accept a POST request and begins indexing
  def create
    index_method = "index_#{params[:object_type]}".to_sym
    respond_to?(index_method) ? self.send(index_method) : raise("Unknown :object_type => #{params[:object_type]}")
  end
  
  protected
  
  def index_rss
    rss_indexer = Consuminator::RSSIndexer.new(solr, params[:rss_feed_url])
    
    begin
      total_indexed = rss_indexer.go!(:tags_facet=>params[:tags].to_s.split(','))
    rescue Consuminator::MappingError
      @error << "Mapping Error: #{$!}"
    end
    
    if total_indexed
      flash[:notice] = "Indexed #{total_indexed} items"
      return redirect_to(contents_path)
    else
      @errors << 'No items were indexed. Are you sure entered a valid RSS 2.0 feed url?'
      render(:action=>:index)
    end
  end
  
  def set_errors
    @errors = []
  end
  
end