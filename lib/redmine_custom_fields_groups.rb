module RedmineCustomFieldsGroups
  class << self
    def setup
      IssuesHelper.send(:include, RedmineCustomFieldsGroups::Patches::IssuesHelperPatch)
      UserPreference.send(:include, RedmineCustomFieldsGroups::Patches::UserPreferencePatch)
    end
  end
end
