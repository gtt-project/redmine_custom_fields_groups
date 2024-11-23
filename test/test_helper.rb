# Load the Redmine helper
require_relative '../../../test/test_helper'

def load_plugin_fixtures(reset_cache = false)
  if reset_cache
    ActiveRecord::FixtureSet.reset_cache
  end
  ActiveRecord::FixtureSet.create_fixtures(
    File.dirname(__FILE__) + '/fixtures',
    ['custom_fields_groups', 'custom_fields_group_fields']
  )
end

load_plugin_fixtures
