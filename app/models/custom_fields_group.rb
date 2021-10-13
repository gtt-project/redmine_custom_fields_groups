class CustomFieldsGroup < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :custom_fields_group_fields, :dependent => :delete_all
  has_many :custom_fields, :through => :custom_fields_group_fields

  # accepts_nested_attributes_for :custom_fields_group_fields, :allow_destroy => true

  acts_as_positioned
  scope :sorted, ->{ order :position }
end
