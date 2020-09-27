module Import
  class Row
    REF = 'reference'.freeze

    attr_reader :target_model, :row
    attr_writer :profile_attributes

    def initialize(target_model:, row:)
      @target_model = target_model
      @row = row
    end

    def save
      update_profile_attributes if past_records.any?

      profile = record.profiles.build(profile_attributes)
      profile.save
      record.update(current_profile_id: profile.id)
      true
    end

    def record
      @record ||= target_model.find_or_create_by(reference: row[REF])
    end

    def profile_attributes
      @profile_attributes ||= row.reject { |k, _v| k == REF }
    end

    def past_records
      @past_records ||= record.profiles.already_recorded(forbidden_row_values)
    end

    def rejected_attributes
      @rejected_attributes ||= past_records.map do |item|
        item.attributes.select { |_k, v| v.in?(forbidden_row_values.values) }
      end.reduce(&:update).keys
    end

    def forbidden_row_values
      forbidden_overwrite_attributes = "#{target_model}Profile".constantize::NO_OVERWRITE.map(&:to_s)
      @forbidden_row_values ||= row.slice(*forbidden_overwrite_attributes)
    end

    private

    def update_profile_attributes
      remaining_profile_attributes = profile_attributes.reject { |k, _v| k.in?(rejected_attributes) }

      @profile_attributes = last_profile_attributes.merge(remaining_profile_attributes)
    end

    def last_profile_attributes
      @last_profile_attributes ||= record.current_profile.attributes.reject do |k, _v|
        k.in?(['id', "#{record.class.to_s.downcase}_id", 'created_at', 'updated_at'])
      end
    end
  end
end
