ActionController::Routing::Routes.draw do |map|
  
  map.connect ":resource", :controller => 'lis', :action => 'index', :conditions => { :method => :get }
  map.connect ":resource/:sourced_id", :controller => 'lis', :action => 'update', :conditions => { :method => :put }
  map.connect ":resource/:sourced_id", :controller => 'lis', :action => 'show', :conditions => { :method => :get }
  map.connect ":resource/:sourced_id", :controller => 'lis', :action => 'destroy', :conditions => { :method => :delete }
  
  map.connect ":parent/:parent_sourced_id/:resource", :controller => 'lis', :action => 'index', :conditions => { :method => :get }
  map.connect ":parent/:parent_sourced_id/:resource/:sourced_id", :controller => 'lis', :action => 'update', :conditions => { :method => :put }
  map.connect ":parent/:parent_sourced_id/:resource/:sourced_id", :controller => 'lis', :action => 'show', :conditions => { :method => :get }
  map.connect ":parent/:parent_sourced_id/:resource/:sourced_id", :controller => 'lis', :action => 'destroy', :conditions => { :method => :delete }
    
  # controllers = ['people', 'course_templates', 'course_offerings', 'course_sections', 'groups', 'memberships', 'terms', 'meetings']
  # 
  # controllers.each do |controller|
  #   map.connect controller, :controller => controller, :action => 'update', :conditions => {:method => :put}
  #   map.connect controller, :controller => controller, :action => 'index', :conditions => {:method => :get}
  #   map.connect controller + '/:sourced_id', :controller => controller, :action => 'show', :conditions => {:method => :get}
  #   map.connect controller + '/:sourced_id', :controller => controller, :action => 'delete', :conditions => {:method => :delete}
  # end
end
