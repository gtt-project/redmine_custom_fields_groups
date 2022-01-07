require File.expand_path('../lib/redmine_custom_fields_groups/hooks/view_layouts_base_html_head_hook', __FILE__)
require File.expand_path('../lib/redmine_custom_fields_groups/hooks/view_user_preferences_hook', __FILE__)

Redmine::Plugin.register :redmine_custom_fields_groups do
  name 'Redmine Custom Fields Groups plugin'
  author 'Georepublic'
  author_url 'https://github.com/georepublic'
  url 'https://github.com/gtt-project/redmine_custom_fields_groups'
  description 'This is a plugin for grouping custom fields'
  version '1.0.0'

  requires_redmine :version_or_higher => '4.1.0'

  settings partial: 'settings/redmine_custom_fields_groups',
    default: {
      'custom_fields_group_tag' => 'h4',
      'fieldset_default_state' => 'all_expended'
    }

  menu :admin_menu,
    :custom_fields_group,
    { controller: 'custom_fields_groups', action: 'index' },
    caption: :label_custom_fields_group_plural,
    after: :custom_fields,
    html: { class: 'icon icon-custom-fields custom-fields-groups' }
end

if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  require File.expand_path('../app/overrides/issues', __FILE__)
  Rails.application.config.after_initialize do
    RedmineCustomFieldsGroups.setup
  end
  # RedmineCustomFieldsGroups.setup
else
  require 'redmine_custom_fields_groups'
  Rails.application.paths["app/overrides"] ||= []
  Rails.application.paths["app/overrides"] << File.expand_path("../app/overrides", __FILE__)

  Rails.configuration.to_prepare do
    RedmineCustomFieldsGroups.setup
  end
end
