module Consuminator
  
  class << self
    
    attr_accessor :solr, :config
    
    def configure(&blk)
      yield @config
    end
    
    def solr
      @solr ||= RSolr::Ext.connect
    end
    
    def init config
      ApplicationController.send(:include, Consuminator::Helpers)
    end
    
  end
  
  @config ||= {}
  
  #
  #
  #
  module Helpers
    
    FACET_FIELDS = Consuminator.solr.luke[:fields].map{|i|i.first}.grep(/_facet$/)
    
    def self.included(base)
      base.helper_method :solr, :solr_facet_fields, :add_facet_params, :remove_facet_params, :facet_in_params?, :object_type_indexer_partials
    end
    
    def solr
      Consuminator.solr
    end
    
    def solr_facet_fields
      FACET_FIELDS
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
  
end