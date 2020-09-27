module OnlyPersisted
  extend ActiveSupport::Concern

  included do
    scope :persisted, -> { where('id IS NOT NULL') }
  end
end
