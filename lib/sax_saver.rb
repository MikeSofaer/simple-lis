require 'sax-machine'
module SAXSaver
  def self.included(base)
    base.extend SaverMethods
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
    self.class.connection.execute sql
  end
end