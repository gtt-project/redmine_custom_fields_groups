class CreateCustomFieldsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_fields_groups do |t|
      t.string :name, index: { unique: true }
      t.integer :position, default: nil, null: true

      t.timestamps null: false
    end
  end
end
