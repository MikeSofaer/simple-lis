class LisController < ActionController::Base
  ObjectSpace.each_object(Class){ |k| @@mysql_error = k if k.name == 'MysqlError' }
  include SslRequirement
  # ssl_required :index, :show, :update, :delete
  
  def index
    if ALLOWED_PARENTS.include?(params[:parent]) && params[:parent] && params[:parent_sourced_id]
      objects = model.datamapper_class.all("#{params[:parent].singularize}_sourced_id".to_sym => params[:parent_sourced_id])
    else
      objects = model.datamapper_class.all
    end
    
    render :xml => "<#{resource.pluralize}>\n#{objects.map{ |object| "  #{object.to_xml}\n" }}\n</#{resource.pluralize}>"
  end
  
  def show
    object = model.datamapper_class.first(:sourced_id => params[:sourced_id])
    
    if object.blank?
      logger.warn { "LisController#show couldn't find #{model.class.name} record with sourced id #{params[:sourced_id]}}" }
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found and return
    end
    
    render :xml => object.to_xml
  end
  
  def update
    t = Time.now
    logger.debug "Start"
    objects = model.parse_multiple(request.body)
    logger.debug "Built objects at T + " + (Time.now - t).to_s
    render :xml => "We weren't able to parse any data from that.  Are you sure the XMl is valid?", :status => :unprocessable_entity and return  if objects.size == 0

    ids = []
    unless RAILS_ENV == 'test'
      transaction = DataMapper::Transaction.new(DataMapper.repository)
      transaction.begin
      DataMapper.repository(:default).adapter.push_transaction(transaction)
      begin
        while objects.size > 0
          s = objects.slice!(0, 1000)
          sourced_ids = s.map(&:sourced_id)
          logger.debug { "saved slice, sourcedIds are #{sourced_ids*', '}" }
          model.save s
          ids << sourced_ids
        end
        logger.debug "Saved objects at T + " + (Time.now - t).to_s
        logger.debug "Didn't link objects at T + " + (Time.now - t).to_s
        DataMapper.repository(:default).adapter.pop_transaction
        transaction.commit
      rescue => e
        DataMapper.repository(:default).adapter.pop_transaction
        transaction.rollback
        raise e
      end
    else
      while objects.size > 0
        s=objects.slice!(0, 1000)
        sourced_ids = s.map(&:sourced_id)
        logger.debug { "saved slice, sourcedIds are #{sourced_ids*', '}" }
        model.save s
        ids << sourced_ids
      end
      logger.debug "Saved objects at T + " + (Time.now - t).to_s
      logger.debug "Didn't link objects at T + " + (Time.now - t).to_s
    end

    render :xml => ids.flatten.inject('') { |res, sid| res << %Q{<url>#{url_for(:action => 'show', :sourced_id => sid)}</url>} }
  rescue LISModel::InvalidForeignKeyError => e
    log_error e
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue SAXualReplication::MissingElementError => e
    log_error e
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue NoMethodError => e
    log_error e
    render :xml => "Check your XML, it may be missing tags. \n#{e.message}", :status => :unprocessable_entity and return
  rescue ActiveRecord::RecordInvalid => e
    log_error e
    render :xml => e.message, :status => :unprocessable_entity and return
  rescue Vpim::InvalidEncodingError => e
    log_error e
    render :xml => "Looks like your ical object is bad at the following line:\n#{e}.", :status => :unprocessable_entity and return
  rescue TypeError
    log_error e
    render :xml => "There is something terribly wrong with your request.", :status => :unprocessable_entity and return
  rescue @@mysql_error => e
    log_error e
    if e.message.match(/FOREIGN KEY \("(.*)"\) REFERENCES "(.*)" \("(.*)"\)\)/)
      possibles = model.parse_multiple(request.body).map{|o| o.send($1)}  #Yeah, we parse it a again.  Got a problem with that?
      nots = model.connection.query "select #{$3} from #{$2} where #{$3} in (#{possibles.map{|a| "'" + a + "'"}.join(',')})"
      render :xml => "The #{$3} table does not have rows with #{$2} with these values: #{(possibles - nots).inspect}", :status => :unprocessable_entity and return
    end
    render :xml => "Database rejected your request, here is the error message: #{e.message}", :status => :unprocessable_entity and return
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
  
  protected
  
  def log_error(e)
    logger.warn { "LisController#" + params[:action].to_s + " error: " + e.message }
  end
end