require File.expand_path('../../test_helper', __FILE__)

class LayoutTest < Redmine::IntegrationTest
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details, :versions,
           :workflows, :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions,
           :custom_fields, :custom_fields_groups, :custom_fields_group_fields

  setup do
    User.current = nil
  end

  test 'should show custom fields groups in issue details' do
    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'div.value', :text => '125'
      end
      assert_select 'div.splitcontentleft:nth-child(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'div.value', :text => ''
      end
    end
    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'div.value', :text => '2.10'
      end
    end
    assert_select 'div.issue.details div.attributes h4.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'div.value', :text => '12/01/2009'
      end
    end
  end

  test 'should show custom fields groups in issue edit' do
    log_user('dlopper', 'foo')
    get '/issues/1'
    assert_response :success

    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 1") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Searchable field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][2]', :value => '125'
      end
      # `nth-child(2)`` is necessary until CSS4
      # https://developer.chrome.com/docs/css-ui/css-nth-child-of-s#pre-filtering_selections_with_the_of_s_syntax
      assert_select 'div.splitcontentright:nth-child(2)' do
        assert_select 'span', :text => 'Database'
        assert_select 'select[name=?]', 'issue[custom_field_values][1]', :value => ''
      end
    end
    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 2") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Float field'
        assert_select 'input[type=text][name=?]', 'issue[custom_field_values][6]', :value => '2.1'
      end
    end
    assert_select 'div#update div.attributes h4.custom-fields-groups:contains("Group 3") + div.splitcontent' do
      assert_select 'div.splitcontentleft:nth-child(1)' do
        assert_select 'span', :text => 'Custom date'
        assert_select 'input[type=date][name=?]', 'issue[custom_field_values][8]', :value => '2009-12-01'
      end
    end
  end

  # TODO: h3 and fieldset types from global plugin settings or user preference settings
end
