require 'redmine_custom_fields_groups'

Redmine::Plugin.register :redmine_custom_fields_groups do
  name 'Redmine Custom Fields Groups plugin'
  author 'Ko Nagase'
  description 'This is a plugin for grouping custom fields'
  version '0.0.1'
  url 'https://hub.georepublic.net/gtt/redmine_custom_fields_groups'
  author_url 'https://hub.georepublic.net/nagase'

  requires_redmine :version_or_higher => '4.0.0'

  settings partial: 'settings/redmine_custom_fields_groups',
    default: {
      'group_tag' => 'h4',
      'group_style' => 'background: #0001; padding: 0.3em;',
    }

  menu :admin_menu,
    :custom_fields_group,
    { controller: 'custom_fields_groups', action: 'index' },
    caption: :label_custom_fields_group_plural,
    after: :custom_fields,
    html: { class: 'icon icon-custom-fields custom-fields' }
end
