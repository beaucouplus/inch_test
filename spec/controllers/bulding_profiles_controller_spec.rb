require 'rails_helper'

describe BuildingProfilesController do
  describe 'PATCH #update' do
    let!(:building_profile) { create(:building_profile) }
    let(:building_profile_attributes) { attributes_for(:building_profile) }

    it 'redirects to show page with parameter string' do
      expect do
        patch :update, params: { id: building_profile.id, building_profile: building_profile_attributes }
      end.to change { BuildingProfile.count }
      expect(BuildingProfile.last.attributes.reject { |k, _v| k.in? %w[id created_at updated_at building_id] }.symbolize_keys).to eq(building_profile_attributes)
    end
  end
end
