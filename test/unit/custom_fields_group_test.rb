require_relative '../test_helper'

class CustomFieldsGroupTest < ActiveSupport::TestCase
  fixtures :custom_fields, :custom_fields_groups, :custom_fields_group_fields

  test 'create' do
    issue_custom_field = IssueCustomField.new(:name => 'test', :field_format => 'text')
    issue_custom_field.save!
    issue_custom_field.reload

    custom_fields_group = CustomFieldsGroup.new
    custom_fields_group.name = 'test'
    custom_fields_group.custom_field_ids = [issue_custom_field.id]
    assert custom_fields_group.save
    custom_fields_group.reload
    assert_equal [issue_custom_field.id], custom_fields_group.custom_field_ids
    assert_equal CustomFieldsGroup.count, custom_fields_group.position
  end

  test 'should require name' do
    custom_fields_group = CustomFieldsGroup.new
    assert_not custom_fields_group.save
    assert custom_fields_group.errors[:name]
  end

  test 'should validate name uniqueness' do
    assert_difference 'CustomFieldsGroup.count' do
      custom_fields_group = CustomFieldsGroup.new
      custom_fields_group.name = 'test'
      assert custom_fields_group.save
      assert_equal 'test', custom_fields_group.name
    end

    assert_no_difference 'CustomFieldsGroup.count' do
      custom_fields_group = CustomFieldsGroup.new
      custom_fields_group.name = 'test'
      assert_not custom_fields_group.save
      assert custom_fields_group.errors[:name]
    end
  end

  test 'deletion of custom_field_group should delete custom_fields_group_field' do
    custom_fields_group = custom_fields_groups(:custom_fields_groups_100)
    assert_difference 'CustomFieldsGroupField.count', -2 do
      assert custom_fields_group.destroy
    end
  end

  test 'deletion of custom_field should delete custom_fields_group_field' do
    custom_field = custom_fields(:custom_fields_001)
    assert_difference 'CustomFieldsGroup.find(1).custom_fields.count', -1 do
      assert custom_field.destroy
    end
  end
end
