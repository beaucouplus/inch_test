class CreatePersonProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :person_profiles do |t|
      t.references :person, null: false, foreign_key: true
      t.string :email
      t.string :home_phone_number
      t.string :mobile_phone_number
      t.string :firstname
      t.string :lastname
      t.string :address

      t.timestamps
    end
  end
end
