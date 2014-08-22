require_relative 'db_connection'
require 'active_support/inflector'
#NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
#    of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns unless @columns.nil?

    query = "SELECT * FROM #{table_name}"
    @columns = DBConnection.execute2(query).first
    
    @columns = columns.map { |i| i.to_sym }
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |value|
        attributes[column] = value
      end

      define_method(column) do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name.to_s
  end

  def self.table_name
    @table_name ||= self.to_s.tableize

    @table_name
  end

  def self.all
    return parse_all(@results) unless @results.nil?

    query = "SELECT * FROM #{table_name}"
    @results = DBConnection.execute(query)

    parse_all(@results)
  end

  def self.parse_all(results)
    results.map { |i| self.new(i) }
  end

  def self.find(id)
    query = "SELECT * FROM #{table_name} WHERE id = ?"
    result = DBConnection.execute(query, id)

    self.new(result.first)
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    col_names = self.class.columns.map { |i| i.to_s }
    col_names.delete("id")
    col_names = col_names.join(",")

    question_marks = ("?," * attributes.length)[0...-1]
    query = "INSERT INTO #{self.class.table_name} (#{col_names}) VALUES (#{question_marks})"

    p col_names
    DBConnection.execute(query, *attribute_values)

    @attributes[:id] = DBConnection.last_insert_row_id
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end

  def update
    col_names = self.class.columns.map { |i| "#{i.to_s} = ?" }
    col_names.delete("id")
    col_names = col_names.join(",")
    query = "UPDATE #{self.class.table_name} SET #{col_names} WHERE id = ?"

    DBConnection.execute(query, *attribute_values, @attributes[:id])
  end

  def attribute_values
    self.class.columns.map { |i| self.send(i) }.compact
  end
end
