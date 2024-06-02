require_relative '../../../../test/application_system_test_case'
require_relative '../test_helper'

class FieldsetTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details,
           :custom_fields, :custom_fields_groups, :custom_fields_group_fields

  teardown do
    Setting.where(name: 'plugin_redmine_custom_fields_groups').destroy_all
    Setting.clear_cache
  end

  test 'click group title should collapse/expand fieldset with default state all_expanded' do
    Setting.plugin_redmine_custom_fields_groups = {
      'custom_fields_group_tag' => 'fieldset',
      'fieldset_default_state' => 'all_expanded'
    }

    log_user('dlopper', 'foo')
    visit '/issues/1'

    # issue details
    within('div.issue.details div.attributes') do
      assert page.has_content?('Group 1')
      # default expanded
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
      # click group title
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # collapsed fields
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
      # click group title, again
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # expanded fields
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
    end

    # issue edit
    page.first(:link, 'Edit').click
    page.find('#issue_notes:focus')
    sleep 0.1
    within('div#update div.attributes') do
      assert page.has_content?('Group 1')
      # default expanded
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
      # click group title
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # collapsed fields
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
      # click group title, again
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # expanded fields
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
    end
  end

  test 'click group title should expand/collapse fieldset with default state all_collapsed' do
    Setting.plugin_redmine_custom_fields_groups = {
      'custom_fields_group_tag' => 'fieldset',
      'fieldset_default_state' => 'all_collapsed'
    }

    log_user('dlopper', 'foo')
    visit '/issues/1'

    # issue details
    within('div.issue.details div.attributes') do
      assert page.has_content?('Group 1')
      # default collapsed
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
      # click group title
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # expanded fields
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
      # click group title, again
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # collapsed fields
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
    end

    # issue edit
    page.first(:link, 'Edit').click
    page.find('#issue_notes:focus')
    sleep 0.1
    within('div#update div.attributes') do
      assert page.has_content?('Group 1')
      # default collapsed
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
      # click group title
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # expanded fields
      assert page.has_content?('Searchable field')
      assert page.has_content?('Database')
      # click group title, again
      find('fieldset.custom-fields-groups > legend.icon', :text => 'Group 1').click
      # collapsed fields
      assert page.has_no_content?('Searchable field')
      assert page.has_no_content?('Database')
    end
  end
end
