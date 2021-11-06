module RedmineCustomFieldsGroups
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener

      include ActionView::Context

      def view_layouts_base_html_head(context={})
        tags = [];
        tags << stylesheet_link_tag('custom_fields_groups', :plugin => "redmine_custom_fields_groups", :media => "all")
        tags << javascript_include_tag('custom_fields_groups', :plugin => 'redmine_custom_fields_groups')
        return tags.join("\n")
      end

    end
  end
end
