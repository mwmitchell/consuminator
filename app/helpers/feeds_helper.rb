module FeedsHelper
  
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