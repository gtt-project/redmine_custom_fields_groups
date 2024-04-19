class AddOnDeleteCascadeToForeignKeyCustomField < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :custom_fields_group_fields, :custom_fields
    add_foreign_key :custom_fields_group_fields, :custom_fields, on_delete: :cascade
  end
end
