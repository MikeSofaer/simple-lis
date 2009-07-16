class LisController < ActionController::Base
  ObjectSpace.each_object(Class){|k| @@mysql_error = k if k.name == 'MysqlError'}
  include SslRequirement
  #  ssl_required :index, :show, :update, :delete  #Comment out to pass specs, uncomment for security in production
  
  def index
    # puts "parent = #{params[:parent]}, parent_sourced_id = #{params[:parent_sourced_id]}"
    if ALLOWED_PARENTS.include?(params[:parent]) && params[:parent] && params[:parent_sourced_id]
      objects = model.datamapper_class.all("#{params[:parent].singularize}_sourced_id".to_sym => params[:parent_sourced_id])
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
      objects = model.container.constantize.parse(request.body)
      if objects.collection.size == 0
        render :xml => "We weren't able to parse any data from that.  Are you sure the XMl is valid?", :status => :unprocessable_entity and return
      end
      objects.save!
      
      render :xml => objects.collection.map(&:sourced_id).inject('') { |res, sid| res << %Q{<url>#{url_for(:action => 'show', :sourced_id => sid)}</url>} }
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
    rescue @@mysql_error
      render :xml => "Database rejected your request, please make sure all foreign keys are valid", :status => :unprocessable_entity and return
    end
  end
  
  def destroy
    object = model.datamapper_class.first(:sourced_id => params[:sourced_id])
    if object.blank?
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found and return
    end
    object.destroy
    render :xml => "", :status => :no_content
  rescue @@mysql_error => e
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue Exception => e
  end
  
  def model
    params[:resource].classify.constantize
  end
  
  def resource
    params[:resource].singularize
  end
end
