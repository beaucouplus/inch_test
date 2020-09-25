class RemoveProfileColumnsFromPerson < ActiveRecord::Migration[6.0]
  def change
    remove_column :people, :email, :string
    remove_column :people, :home_phone_number, :string
    remove_column :people, :mobile_phone_number, :string
    remove_column :people, :firstname, :string
    remove_column :people, :lastname, :string
    remove_column :people, :address, :string
  end
end
