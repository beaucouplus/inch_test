class BuildingProfilesController < ApplicationController
  def update
    current_profile = BuildingProfile.find(params[:id])
    building = current_profile.building
    profile = BuildingProfile.create(building_profiles_params.merge(building_id: current_profile.building_id))
    building.update(current_profile_id: profile.id)
  end

  def building_profiles_params
    params.require(:building_profile).permit(:address, :zip_code, :city, :country, :manager_name)
  end
end
