class CustomFieldsGroupField < ActiveRecord::Base
  belongs_to :custom_fields_group
  belongs_to :custom_field

  # scope :sorted, lambda { order(:position) }
end
