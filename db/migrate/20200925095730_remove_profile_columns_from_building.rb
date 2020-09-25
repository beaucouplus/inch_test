class RemoveProfileColumnsFromBuilding < ActiveRecord::Migration[6.0]
  def change
    remove_column :buildings, :address, :string
    remove_column :buildings, :zip_code, :string
    remove_column :buildings, :city, :string
    remove_column :buildings, :country, :string
    remove_column :buildings, :manager_name, :string
  end
end
