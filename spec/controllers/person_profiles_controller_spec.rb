require 'rails_helper'

describe PersonProfilesController do
  describe 'PATCH #update' do
    let!(:person_profile) { create(:person_profile) }
    let(:person_profile_attributes) { attributes_for(:person_profile) }

    it 'redirects to show page with parameter string' do
      expect do
        patch :update, params: { id: person_profile.id, person_profile: person_profile_attributes }
      end.to change { PersonProfile.count }
      expect(PersonProfile.last.attributes.reject { |k, _v| k.in? %w[id created_at updated_at person_id] }.symbolize_keys).to eq(person_profile_attributes)
    end
  end
end
