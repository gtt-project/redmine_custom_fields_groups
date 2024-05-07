class CustomFieldsGroup < (defined?(ApplicationRecord) == 'constant' ? ApplicationRecord : ActiveRecord::Base)
  include Redmine::SafeAttributes

  validates :name, presence: true, uniqueness: true

  has_many :custom_fields_group_fields, :dependent => :delete_all
  has_many :custom_fields, :through => :custom_fields_group_fields

  acts_as_positioned
  scope :sorted, ->{ order :position }

  safe_attributes(
    'name',
    'position',
    'custom_field_ids'
  )
end
