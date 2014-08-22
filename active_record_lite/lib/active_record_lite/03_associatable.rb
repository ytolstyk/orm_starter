require_relative '02_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    define_method(name) do
      @foreign_key = options[:foreign_key]
      @primary_key = options[:primary_key]
      @class_name = options[:class_name]

      @primary_key ||= :id
      @foreign_key ||= (@class_name.to_s.downcase.singularize + "_id").to_sym


      query = <<-SQL
      SELECT
      *
      FROM
      #{@class_name.table_name}
      WHERE
      #{@primary_key} = ?
      SQL

      value = send(@foreign_key)

      DBconnection.execute(query, value)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
