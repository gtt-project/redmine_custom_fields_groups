module RedmineCustomFieldsGroups
  module Hooks
    class ViewUserPreferencesHook < Redmine::Hook::ViewListener
      def view_users_form_preferences(context={})
        user_custom_fields_group_options(context)
      end

      def view_my_account_preferences(context={})
        user_custom_fields_group_options(context)
      end

      def user_custom_fields_group_options(context)
        user  = context[:user]
        f     = context[:form]
        s     = ''

        s << "<p>"
        s << label_tag("pref_custom_fields_group_tag", l(:label_custom_fields_group_tag))
        s << select_tag(
                "pref[custom_fields_group_tag]",
                options_for_select(RedmineCustomFieldsGroups::Options::GROUP_TAGS, user.pref.custom_fields_group_tag),
                :id => 'pref_custom_fields_group_tag'
              )
        s << "</p>"
        s << "<p>"
        s << label_tag("pref_fieldset_default_state", l(:label_fieldset_default_state))
        s << select_tag(
                "pref[fieldset_default_state]",
                options_for_select(RedmineCustomFieldsGroups::Options::FIELDSET_STATES, user.pref.fieldset_default_state),
                :id => 'pref_fieldset_default_state'
              )
        s << "</p>"

        return s.html_safe
      end
    end
  end
end
