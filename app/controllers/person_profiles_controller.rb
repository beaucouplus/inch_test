class PersonProfilesController < ApplicationController
  def edit; end

  def update
    current_profile = PersonProfile.find(params[:id])
    building = current_profile.person
    profile = PersonProfile.create(person_profile_params.merge(person_id: current_profile.person_id))
    building.update(current_profile_id: profile.id)
  end

  def person_profile_params
    params.require(:person_profile).permit(:email, :home_phone_number, :mobile_phone_number,
                                           :firstname, :lastname, :address)
  end
end
