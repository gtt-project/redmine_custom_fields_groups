module RedmineCustomFieldsGroups
  class Options
    include Redmine::I18n
    def self.group_tags
      [
        [l(:label_group_tag_h3), "h3"],
        [l(:label_group_tag_h4), "h4"],
        [l(:label_group_tag_fieldset), "fieldset"]
      ]
    end
    def self.fieldset_states
      [
        [l(:label_fieldset_state_all_expended), "all_expended"],
        [l(:label_fieldset_state_all_collapsed), "all_collapsed"],
      ]
    end
  end
end
