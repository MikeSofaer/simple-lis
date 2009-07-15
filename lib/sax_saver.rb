require 'sax-machine'
require "sax-machine/sax_element_config"
module SAXMachine
  class SAXConfig
    class ElementConfig
      attr_reader :required
      def initialize(name, options)
        @name = name.to_s

        if options.has_key?(:with)
          # for faster comparisons later
          @with = options[:with].to_a.flatten.collect {|o| o.to_s}
        else
          @with = nil
        end

        if options.has_key?(:value)
          @value = options[:value].to_s
        else
          @value = nil
        end

        @as = options[:as]
        @collection = options[:collection]

        if @collection
          @setter = "add_#{options[:as]}"
        else
          @setter = "#{@as}="
        end
        
        @required = options[:required]
        @db_type = options[:db_type] || String
      end
    end
  end
end

module SAXSaver
  class MissingElementError < Exception; end
  
  def self.included(base)
    base.extend SaverMethods
  end
  
  module SaverMethods
    def columns
      @sax_config.instance_variable_get('@top_level_elements').map{|e| e.instance_variable_get('@as')}
    end
    
    def columns_with_types
      @sax_config.instance_variable_get('@top_level_elements').each{|e| yield e.instance_variable_get('@as'), e.instance_variable_get('@db_type')}
    end
    
    def model
      @sax_config.instance_variable_get('@collection_elements')[0].instance_variable_get('@class')
    end
    
    def table_name
      @sax_config.instance_variable_get('@collection_elements')[0].instance_variable_get('@as')
    end
    
    def connection
      DataMapper.repository(:default).adapter
    end
    
    def parse(xml)
      ret = super(xml)
      ret.validate
      return ret
    end
    
    def datamapper_class
      klass = self.dup
      klass.send(:include, DataMapper::Resource)
      klass.storage_names[:default] = container.constantize.table_name
      klass.property(:id, DataMapper::Types::Serial)
      klass.property(:created_at, DateTime, :nullable => false)
      klass.property(:updated_at, DateTime, :nullable => false)
      columns_with_types { |n, t| klass.property(n, t) }
      klass
    end
  end
  
  def sql
    columns = self.class.model.columns
    ret = "INSERT INTO #{self.class.table_name} (#{columns.join(', ')}) values "
    values = send(self.class.table_name).map do |object|
      col_vals = columns.map{|c| object.send(c)}
      col_vals.map!{|c| c.is_a?(DateTime) ? c.strftime("%Y-%m-%d %H:%M:%S") : c}
      col_vals.map!{|c| c ? "'" + c.to_s + "'" : 'NULL'}
      update_columns = columns - [:sourced_id, :id, :created_at]
      update_keys = update_columns.map{|c| c.to_s + '=VALUES(' + c.to_s + ')'}
      '(' + col_vals.join(', ') + ')' + "ON DUPLICATE KEY UPDATE " + update_keys.join(', ')
    end
    ret + values.join(', ')
  end
  
  def save!
    return save_with(self.class.container.constantize) if self.class.container
    self.class.connection.execute sql
  end
  
  def save_with(container_class)
    c = container_class.new
    c.collection = [self]
    c.save!
  end
  
  def validate
    self.class.instance_variable_get('@sax_config').instance_variable_get('@top_level_elements').select{|e| e.required}.each do |element|
      unless send(element.instance_variable_get('@as'))
        raise MissingElementError.new("Missing the required attribute " + element.name)
      end
    end
    send(self.class.table_name).each{|o| o.validate} if self.class.table_name
  end
  
  def table_name
    self.class.table_name
  end
  
  def collection
    send(table_name)
  end
  
  def collection=(values)
    send(table_name + '=', values)
  end
end