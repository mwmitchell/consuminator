class FeedsController < ApplicationController
  
  # display/search the docs
  def index
    query_params = {
      :qt=>:dismax,
      :qf=>'title_t description_t feed_title_t',
      :page=>params[:page],
      :per_page=>5,
      :sort=>'timestamp desc'
    }
    query_params[:facets] = [{:field=>[:feed_language_facet, :feed_title_facet]}]
    if params[:f] and params[:f].is_a?(Hash)
      query_params[:phrase_filters] = params[:f]
    end
    @feeds = solr.search(params[:q], query_params)
  end
  
end