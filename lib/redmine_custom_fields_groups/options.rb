module RedmineCustomFieldsGroups
  class Options
    include Redmine::I18n
    GROUP_TAGS = [
      [l(:label_group_tag_h3), "h3"],
      [l(:label_group_tag_h4), "h4"],
      [l(:label_group_tag_fieldset), "fieldset"]
    ]
    FIELDSET_STATES = [
      [l(:label_fieldset_state_all_expended), "all_expended"],
      [l(:label_fieldset_state_all_collapsed), "all_collapsed"],
    ]
  end
end
