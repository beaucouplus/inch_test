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

      current_table = tablename.constantize
      with_profile = current_table.with_profiles
      rows.each do |row|
        record = with_profile.find_or_create_by(reference: row['reference'])
        profile_attributes = row.reject { |k, _v| k == 'reference' }

        forbidden_overwrite_keys = current_table::NO_OVERWRITE.map(&:to_s)
        forbidden_overwrite_values = row.slice(*forbidden_overwrite_keys)

        where_clause = forbidden_overwrite_keys.map { |item| "#{item} = :#{item}" }.join(' or ')
        found_previous = record.profiles.where(where_clause, forbidden_overwrite_values.symbolize_keys)
        if found_previous.any?
          rejected_fields = found_previous.map do |item|
            item.attributes.select { |_k, v| v.in?(forbidden_overwrite_values.values) }
          end.reduce(&:update).keys

          last_profile_attributes = record.current_profile.attributes.reject { |k, _v| k.in?(['id', "#{filename.singularize}_id", 'created_at', 'updated_at']) }

          profile_attributes = last_profile_attributes.merge(profile_attributes.reject { |k, _v| k.in?(rejected_fields) })
        end
        profile = record.profiles.build(profile_attributes)
        profile.save
        record.update(current_profile_id: profile.id)
      end
      true
    end

    def tablename
      filename.singularize.camelize
    end
  end
end
