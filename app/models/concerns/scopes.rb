module Scopes
  extend ActiveSupport::Concern

  included do
    scope :persisted, -> { where('id IS NOT NULL') }
  end

  class_methods do
    def already_recorded(fields)
      query = self::NO_OVERWRITE.map(&:to_s).map { |item| "#{item} = :#{item}" }.join(' or ')
      where(query, fields.symbolize_keys)
    end
  end
end
