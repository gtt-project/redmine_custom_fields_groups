# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

ActiveRecord::FixtureSet.create_fixtures(
  File.dirname(__FILE__) + '/fixtures',
  ['custom_fields_groups', 'custom_fields_group_fields']
)
