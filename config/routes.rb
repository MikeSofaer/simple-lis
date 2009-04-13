ActionController::Routing::Routes.draw do |map|
  controllers = ['people', 'course_templates', 'course_offerings', 'course_sections', 'groups', 'memberships', 'terms', 'meetings']
  
  controllers.each do |controller|
    map.connect controller, :controller => controller, :action => 'update', :conditions => {:method => :put}
    map.connect controller, :controller => controller, :action => 'index', :conditions => {:method => :get}
    map.connect controller + '/:sourced_id', :controller => controller, :action => 'show', :conditions => {:method => :get}
    map.connect controller + '/:sourced_id', :controller => controller, :action => 'delete', :conditions => {:method => :delete}
  end
end
