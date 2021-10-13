class CustomFieldsGroupField < ActiveRecord::Base
  belongs_to :custom_fields_group
  belongs_to :custom_field

  scope :sorted, (lambda do
    includes(:custom_field).order("#{CustomField.table_name}.position ASC")
  end)
end
