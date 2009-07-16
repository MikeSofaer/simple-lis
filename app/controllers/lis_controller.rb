class LisController < ActionController::Base
  include SslRequirement
  #  ssl_required :index, :show, :update, :delete  #Comment out to pass specs, uncomment for security in production
  
  def index
    active_filters = filterable_on.select{|filter| params[filter]}
    if active_filters.size > 1
      render :xml => "Cannot have more than one filter", :status => :unprocessable_entity
      return
    end

    if active_filters.size == 1
      objects = model.datamapper_class.all(active_filters[0].to_s.to_sym => params[active_filters[0]])
    else
      objects = model.datamapper_class.all
    end
    render :xml => "<#{resource.pluralize}>\n#{objects.map{|object| "  #{object.to_xml}\n"}}\n</#{resource.pluralize}>"
  end
  
  def show
    object = model.datamapper_class.first(:sourced_id => params[:sourced_id])
    if object.blank?
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found
      return
    end
    render :xml => object.to_xml
  end
  
  def update
    begin
      people = People.parse(request.body)
      people.save!
      
      render :xml => people.people.map(&:sourced_id).inject('') { |res, sid| res << %Q{<url>#{url_for(:action => 'show', :sourced_id => sid)}</url>} }
    rescue SAXSaver::MissingElementError => e
      render :xml => e.message, :status => :unprocessable_entity and return
    rescue NoMethodError => e
      render :xml => "Check your XML, it may be missing tags. \n#{e.message}", :status => :unprocessable_entity and return
    rescue ActiveRecord::RecordInvalid => e
      render :xml => e.message, :status => :unprocessable_entity and return
    rescue Vpim::InvalidEncodingError => e
      render :xml => "Looks like your ical object is bad at the following line:\n#{e}.", :status => :unprocessable_entity and return
    rescue TypeError
      render :xml => "There is something terribly wrong with your request.", :status => :unprocessable_entity and return
    rescue Mysql::Error
      render :xml => "Database rejected your request, please make sure all foreign keys are valid", :status => :unprocessable_entity and return
    end
  end
  
  def delete
    object = model.datamapper_class.first(:sourced_id => params[:sourced_id])
    if object.blank?
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found and return
    end
    object.destroy
    render :xml => "", :status => :no_content
  rescue MysqlError => e
    puts "raised MysqlError #{e.message}"
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue Mysql::Error => e
    puts "raised Mysql::Error #{e.message}"
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue Exception => e
    puts "not a MysqlError, instead it was a #{e.class.name}"
    y e
    puts e.class.ancestors
    render :xml => e.message, :status => :unprocessable_entity and return
  end
end
