require 'csv'
require 'active_support/core_ext/string/inflections.rb'

module Import
  class Csv
    attr_reader :file_path, :filename, :rows
    def initialize(file_path:)
      @file_path = file_path
      @filename = File.basename(file_path, '.csv')
      @rows = []
    end

    def import
      current_time = Time.current
      CSV.foreach(file_path, headers: true) do |row|
        @rows << row.to_h.merge(created_at: current_time, updated_at: current_time)
      end
      self
    end

    def save
      return self if rows.empty?

      tablename.constantize.upsert_all(rows)
    end

    def tablename
      filename.singularize.camelize
    end
  end
end
