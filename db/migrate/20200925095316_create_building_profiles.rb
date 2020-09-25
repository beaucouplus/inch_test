class CreateBuildingProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :building_profiles do |t|
      t.references :building, null: false, foreign_key: true
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :country
      t.string :manager_name

      t.timestamps
    end
  end
end
