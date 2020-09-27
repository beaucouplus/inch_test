require 'csv'
require 'active_support/core_ext/string/inflections.rb'

module Import
  class Csv
    attr_reader :file_path, :filename, :rows, :records
    def initialize(file_path:)
      @file_path = file_path
      @filename = File.basename(file_path, '.csv')
      @rows = []
    end

    def import
      CSV.foreach(file_path, headers: true) do |row|
        @rows << row.to_h
      end
      self
    end

    def save
      return self if rows.empty?

      rows.each do |row|
        csv_row = Import::Row.new(target_model: target_model, row: row)
        csv_row.save
      end
      true
    end

    def target_model
      @target_model ||= filename.singularize.camelize.constantize
    end
  end
end
