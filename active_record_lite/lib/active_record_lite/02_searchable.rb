require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")
    query = "SELECT * FROM #{table_name} WHERE #{where_line}"

    result = DBConnection.execute(query, params.values)
    parse_all(result)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
