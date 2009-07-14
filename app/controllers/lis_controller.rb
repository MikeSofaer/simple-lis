#require 'hpricot_prettifier'
require 'ar-extensions'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

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
      objects = model.send("find_all_by_" +active_filters[0].to_s, params[active_filters[0]])
    else
      objects = model.all
    end
    render :xml => "<#{resource.pluralize}>\n#{objects.map{|object| "  #{object.to_xml}\n"}}\n</#{resource.pluralize}>"
  end
  def show
    object = model.find_by_sourced_id(params[:sourced_id])
    if object.blank?
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found
      return
    end
    render :xml => object.to_xml
  end
  def update
    begin
      doc = Hpricot(request.body)
      xml_list = doc.send(resource.pluralize).send(resource)
      xml_list = [xml_list] unless xml_list.is_a? Array
      list = xml_list.map{|o| model.from_xml o}
      model.import(list, :on_duplicate_key_update => model.column_names - ["sourced_id", "id", "updated_at"], :validate => false)
      urls = list.map{|object|  "<url>#{url_for(:action => 'show', :sourced_id => object.sourced_id)}</url>"}
      render :xml => urls.join("\n")
    rescue Hpricot::MissingFieldError => e
      render :xml => e.message, :status => :unprocessable_entity
      return
    rescue NoMethodError => e
      render :xml => "Check your XML, it may be missing tags. \n#{e.message}", :status => :unprocessable_entity
      return
    rescue ActiveRecord::RecordInvalid => e
      render :xml => e.message, :status => :unprocessable_entity
      return
    rescue Vpim::InvalidEncodingError => e
      render :xml => "Looks like your ical object is bad at the following line:\n#{e}.", :status => :unprocessable_entity
      return
    rescue TypeError
      render :xml => "There is something terribly wrong with your request.", :status => :unprocessable_entity
      return
    rescue Mysql::Error
      render :xml => "Database rejected your request, please make sure all foreign keys are valid", :status => :unprocessable_entity
      return
    end
  end
  def delete
    object = model.find_by_sourced_id(params[:sourced_id])
    if object.blank?
      render :xml => "No #{resource} with sourced_id #{params[:sourced_id]}", :status => :not_found
      return
    end
    object.destroy
    render :xml => "", :status => :no_content
  rescue ActiveRecord::StatementInvalid => e
    render :xml => e.message, :status => :unprocessable_entity
    return
  end
end
