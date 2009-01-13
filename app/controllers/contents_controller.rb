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
    search_opts[:facet.field] = self.solr_facet_fields
    
    if params[:f] and params[:f].is_a?(Hash)
      search_opts[:fq]=[]
      params[:f].each_pair do |field,values|
        values.each do |v|
          search_opts[:fq] << "#{field}:" + '"' + %Q(#{v}) + '"'
        end
      end
    end
    @response = solr.search(search_opts)
  end
  
end