require 'hpricot'

class ContentsController < ApplicationController
  
  # display/search the docs
  def index
    query_params = {
      :q=>params[:q],
      :qt=>:dismax,
      :qf=>'text',
      :filters=>{:object_type_facet=>:rss},
      :page=>params[:page],
      :per_page=>5
    }
    query_params[:facets] = [{:field=>solr_facet_fields}]
    if params[:f] and params[:f].is_a?(Hash)
      query_params[:phrase_filters] = params[:f]
    end
    @response = solr.search(query_params)
  end
  
end