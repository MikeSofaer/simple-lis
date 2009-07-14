require 'sax-machine'
require "sax-machine/sax_element_config"
require 'active_record'
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
      end
    end
  end
end

module SAXSaver
  class MissingElementError < Exception; end
  def self.included(base)
    base.extend SaverMethods
    base.cattr_reader :container
  end
  module SaverMethods
    def columns
      @sax_config.instance_variable_get('@top_level_elements').map{|e| e.instance_variable_get('@as')}
    end
    def model
      @sax_config.instance_variable_get('@collection_elements')[0].instance_variable_get('@class')
    end
    def table_name
      @sax_config.instance_variable_get('@collection_elements')[0].instance_variable_get('@as')
    end
    def connection
      ActiveRecord::Base.connection
    end
    def parse(xml)
      ret = super(xml)
      ret.validate
    return ret
  end
  end
  def sql
    columns = self.class.model.columns
    ret = "INSERT INTO #{self.class.table_name} (#{columns.join(', ')}) values "
    values = send(self.class.table_name).map do |object|
      col_vals = columns.map{|c| object.send(c)}
      col_vals.map!{|c| c ? "'" + c + "'" : 'NULL'}
      '(' + col_vals.join(', ') + ')'
    end
    ret + values.join(', ')
  end
  def save!
    return save_with(self.class.container.constantize) if self.class.container
    self.class.connection.execute sql
  end
  def save_with(container_class)
    c = container_class.new
    c.send(container_class.collection = [self])
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