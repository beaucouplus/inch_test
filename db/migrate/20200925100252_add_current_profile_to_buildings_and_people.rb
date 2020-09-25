class AddCurrentProfileToBuildingsAndPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :current_profile_id, :integer
    add_column :buildings, :current_profile_id, :integer
  end
end
