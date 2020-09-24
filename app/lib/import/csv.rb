require 'csv'

module Import
  class Csv
    attr_reader :filename, :rows
    def initialize(filename:)
      @filename = filename
      @rows = []
    end

    def import
      CSV.foreach(filename, headers: true) { |row| @rows << row.to_h }
      rows
    end
  end
end
