require_relative 'lib/redmine_custom_fields_groups/hooks/view_layouts_base_html_head_hook'
require_relative 'lib/redmine_custom_fields_groups/hooks/view_user_preferences_hook'

Redmine::Plugin.register :redmine_custom_fields_groups do
  name 'Redmine Custom Fields Groups plugin'
  author 'Georepublic'
  author_url 'https://github.com/georepublic'
  url 'https://github.com/gtt-project/redmine_custom_fields_groups'
  description 'This is a plugin for grouping custom fields'
  version '2.0.0'

  requires_redmine :version_or_higher => '5.0.0'

  settings partial: 'settings/redmine_custom_fields_groups',
    default: {
      'custom_fields_group_tag' => 'h4',
      'fieldset_default_state' => 'all_expanded'
    }

  menu :admin_menu,
    :custom_fields_group,
    { controller: 'custom_fields_groups', action: 'index' },
    caption: :label_custom_fields_group_plural,
    after: :custom_fields,
    html: { class: 'icon icon-custom-fields-groups' },
    icon: 'custom-fields-groups', plugin: :redmine_custom_fields_groups
end

Dir.glob("#{Rails.root}/plugins/redmine_custom_fields_groups/app/overrides/**/*.rb").each do |path|
  Rails.autoloaders.main.ignore(path)
  require path
end
Rails.application.config.after_initialize do
  RedmineCustomFieldsGroups.setup
end
