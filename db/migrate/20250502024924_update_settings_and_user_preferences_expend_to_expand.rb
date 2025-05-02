class UpdateSettingsAndUserPreferencesExpendToExpand < ActiveRecord::Migration[5.2]
  def up
    plugin_setting = Setting.where(name: 'plugin_redmine_custom_fields_groups')
                            .where("value LIKE '%fieldset_default_state: all_expended%'")
                            &.first
    if plugin_setting.present?
      value = plugin_setting.value
      value[:fieldset_default_state] = 'all_expanded'
      plugin_setting.value = value
      plugin_setting.save
    end
    user_prefs = UserPreference.where("others LIKE '%:fieldset_default_state: all_expended%'")
    user_prefs.each do |user_pref|
      user_pref.others[:fieldset_default_state] = 'all_expanded'
      user_pref.save
    end
  end
  def down
    plugin_setting = Setting.where(name: 'plugin_redmine_custom_fields_groups')
                            .where("value LIKE '%fieldset_default_state: all_expanded%'")
                            &.first
    if plugin_setting.present?
      value = plugin_setting.value
      value[:fieldset_default_state] = 'all_expended'
      plugin_setting.value = value
      plugin_setting.save
    end
    user_prefs = UserPreference.where("others LIKE '%:fieldset_default_state: all_expanded%'")
    user_prefs.each do |user_pref|
      user_pref.others[:fieldset_default_state] = 'all_expended'
      user_pref.save
    end
  end
end
