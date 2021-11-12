module RedmineCustomFieldsGroups
  module Patches
    module UserPreferencePatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          safe_attributes 'custom_fields_group_tag', 'fieldset_default_state'
        end
      end

      module InstanceMethods
        def custom_fields_group_tag
          self[:custom_fields_group_tag]
        end

        def custom_fields_group_tag=(new_value)
          self[:custom_fields_group_tag] = new_value
        end

        def fieldset_default_state
          self[:fieldset_default_state]
        end

        def fieldset_default_state=(new_value)
          self[:fieldset_default_state] = new_value
        end
      end
    end
  end
end

unless UserPreference.included_modules.include?(RedmineCustomFieldsGroups::Patches::UserPreferencePatch)
  UserPreference.send(:include, RedmineCustomFieldsGroups::Patches::UserPreferencePatch)
end
