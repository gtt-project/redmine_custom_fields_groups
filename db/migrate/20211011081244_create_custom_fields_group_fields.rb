class CreateCustomFieldsGroupFields < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_fields_group_fields, id: false do |t|
      t.references :custom_fields_group, index: true, foreign_key: true
      t.references :custom_field, index: { unique: true }, foreign_key: true, type: :integer

      # t.timestamps null: false
    end
  end
end
