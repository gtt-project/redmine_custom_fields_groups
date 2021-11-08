Rails.application.paths["app/overrides"] ||= []
Rails.application.paths["app/overrides"] << File.expand_path("../../app/overrides", __FILE__)

Rails.configuration.to_prepare do
  require 'redmine_custom_fields_groups/hooks/view_layouts_base_html_head_hook'
  require 'redmine_custom_fields_groups/patches/issues_helper_patch'
end

module RedmineCustomFieldsGroups
end
