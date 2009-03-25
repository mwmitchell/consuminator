class ContentsController < ApplicationController
  
  # display/search the docs
  def index
    search_opts = {
      :q=>params[:q],
      :qt=>:dismax,
      :qf=>'text',
      :page=>params[:page],
      :per_page=>5
    }
    
    search_opts[:facet] = true
    search_opts['facet.field'] = self.solr_facet_fields
    search_opts['facet.limit'] = 10
    search_opts['facet.mincount'] = 1
    search_opts['facet.sort'] = true
    
    if params[:f] and params[:f].is_a?(Hash)
      search_opts[:fq]=[]
      params[:f].each_pair do |field,values|
        values.each do |v|
          search_opts[:fq] << "#{field}:" + '"' + %Q(#{v}) + '"'
        end
      end
    end
    
    raw_response = solr.select( RSolr::Ext::Request::Standard.new.map(search_opts) )
    @response = RSolr::Ext::Response::Standard.new(raw_response)
  end
  
end