module RedmineCustomFieldsGroups
  def self.setup
    IssuesHelper.send(:include, RedmineCustomFieldsGroups::Patches::IssuesHelperPatch)
    UserPreference.send(:include, RedmineCustomFieldsGroups::Patches::UserPreferencePatch)
  end
end
