require_relative '../test_helper'

class LayoutTest < Redmine::IntegrationTest
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions,
           :workflows, :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions,
           :custom_fields, :custom_fields_groups, :custom_fields_group_fields

  setup do
    User.current = nil
    @user = User.find_by_login('dlopper')
  end

  teardown do
    Setting.where(name: 'plugin_redmine_custom_fields_groups').destroy_all
    Setting.clear_cache
    @user.pref.others.delete(:custom_fields_group_tag)
    @user.pref.others.delete(:fieldset_default_state)
  end

  test 'should show custom fields groups with default h4 tag in issue' do
    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    # issue details
    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'div.value', :text => '125'
      end
      assert_select 'div.splitcontentleft:nth-of-type(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'div.value', :text => ''
      end
    end
    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'div.value', :text => '2.10'
      end
    end
    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'div.value', :text => '12/01/2009'
      end
    end

    # issue edit
    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][2]', :value => '125'
      end
      assert_select 'div.splitcontentright:nth-of-type(1)' do
        assert_select 'span', :text => 'Database'
        assert_select 'select[name=?]', 'issue[custom_field_values][1]', :value => ''
      end
    end
    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][6]', :value => '2.1'
      end
    end
    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'input[type=date][name=?]', 'issue[custom_field_values][8]', :value => '2009-12-01'
      end
    end
  end

  test 'should show custom fields groups with h3 tag in issue from plugin setting' do
    Setting.plugin_redmine_custom_fields_groups = { 'custom_fields_group_tag' => 'h3' }

    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    # issue details
    assert_select 'div.issue.details div.attributes h3.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'div.value', :text => '125'
      end
      assert_select 'div.splitcontentleft:nth-of-type(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'div.value', :text => ''
      end
    end
    assert_select 'div.issue.details div.attributes h3.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'div.value', :text => '2.10'
      end
    end
    assert_select 'div.issue.details div.attributes h3.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'div.value', :text => '12/01/2009'
      end
    end

    # issue edit
    assert_select 'div#update div.attributes h3.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][2]', :value => '125'
      end
      assert_select 'div.splitcontentright:nth-of-type(1)' do
        assert_select 'span', :text => 'Database'
        assert_select 'select[name=?]', 'issue[custom_field_values][1]', :value => ''
      end
    end
    assert_select 'div#update div.attributes h3.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][6]', :value => '2.1'
      end
    end
    assert_select 'div#update div.attributes h3.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'input[type=date][name=?]', 'issue[custom_field_values][8]', :value => '2009-12-01'
      end
    end
  end

  test 'should show custom fields groups with fieldset tag all expended in issue from plugin setting' do
    Setting.plugin_redmine_custom_fields_groups = {
      'custom_fields_group_tag' => 'fieldset',
      'fieldset_default_state' => 'all_expended'
    }

    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    # issue details
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'div.value', :text => '125'
      end
      assert_select 'div.splitcontentleft:nth-of-type(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'div.value', :text => ''
      end
    end
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'div.value', :text => '2.10'
      end
    end
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'div.value', :text => '12/01/2009'
      end
    end

    # issue edit
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][2]', :value => '125'
      end
      assert_select 'div.splitcontentright:nth-of-type(1)' do
        assert_select 'span', :text => 'Database'
        assert_select 'select[name=?]', 'issue[custom_field_values][1]', :value => ''
      end
    end
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][6]', :value => '2.1'
      end
    end
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'input[type=date][name=?]', 'issue[custom_field_values][8]', :value => '2009-12-01'
      end
    end
  end

  test 'should override user preference setting than plugin setting' do
    Setting.plugin_redmine_custom_fields_groups = {
      'custom_fields_group_tag' => 'h4', # default
      'fieldset_default_state' => 'all_collapsed'
    }

    @user.pref.others[:custom_fields_group_tag] = 'fieldset'
    @user.pref.others[:fieldset_default_state] = 'all_expended'
    @user.pref.save!

    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    # issue details
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'div.value', :text => '125'
      end
      assert_select 'div.splitcontentleft:nth-of-type(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'div.value', :text => ''
      end
    end
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'div.value', :text => '2.10'
      end
    end
    assert_select 'div.issue.details div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'div.value', :text => '12/01/2009'
      end
    end

    # issue edit
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][2]', :value => '125'
      end
      assert_select 'div.splitcontentright:nth-of-type(1)' do
        assert_select 'span', :text => 'Database'
        assert_select 'select[name=?]', 'issue[custom_field_values][1]', :value => ''
      end
    end
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][6]', :value => '2.1'
      end
    end
    assert_select 'div#update div.attributes fieldset.custom-fields-groups > legend.icon:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-of-type(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'input[type=date][name=?]', 'issue[custom_field_values][8]', :value => '2009-12-01'
      end
    end
  end
end
