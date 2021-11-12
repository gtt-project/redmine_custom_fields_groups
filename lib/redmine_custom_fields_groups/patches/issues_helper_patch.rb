require_dependency "issues_helper"

module RedmineCustomFieldsGroups
  module Patches
    module IssuesHelperPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:prepend, InstanceMethods)
        base.class_eval do

          # Referred:
          # - Patch #30919: Group Issues Custom Fields - (Form like Issues) - Redmine
          #   - https://www.redmine.org/issues/30919
          def grouped_custom_field_values(custom_field_values)
            keys_grouped = CustomFieldsGroupField.joins(:custom_fields_group).
              order('custom_fields_groups.position', :position).pluck(:name, :custom_field_id).group_by(&:shift)
            custom_fields_grouped = { nil => (keys_grouped[nil].nil? ? [] :
              keys_grouped[nil].map{|n| custom_field_values.select{|x| x.custom_field[:id] == n[0]}}.flatten) |
              custom_field_values.select{|y| ! keys_grouped.values.flatten.include?(y.custom_field[:id])}}
            keys_grouped.reject{|k,v| k == nil}.each{|k,v| custom_fields_grouped[k] =
              v.map{|n| custom_field_values.select{|x| x.custom_field[:id] == n[0]}}.flatten}
            custom_fields_grouped
          end

          def render_custom_fields_rows_by_groups(issue)
            custom_field_values = issue.visible_custom_field_values
            return if custom_field_values.empty?

            custom_fields_group_tag = User.current.pref.custom_fields_group_tag
            if custom_fields_group_tag.blank?
              custom_fields_group_tag = Setting.plugin_redmine_custom_fields_groups['custom_fields_group_tag'] || 'h4'
            end
            fieldset_default_state = User.current.pref.fieldset_default_state
            if fieldset_default_state.blank?
              fieldset_default_state = Setting.plugin_redmine_custom_fields_groups['fieldset_default_state'] || 'all_expended'
            end

            s = ''.html_safe
            grouped_custom_field_values(custom_field_values).each do |title, values|
              if values.present?
                if custom_fields_group_tag == 'fieldset'
                  if title.nil?
                    s << render_half_width_custom_fields_rows_by_grouped_values(issue, values)
                    s << render_full_width_custom_fields_rows_by_grouped_values(issue, values)
                  else
                    s << content_tag('fieldset', :class => 'collapsible custom-fields-groups') do
                      concat content_tag('legend', title, :onclick => 'toggleFieldset(this);',
                        :class => 'icon icon-expended')
                      concat render_half_width_custom_fields_rows_by_grouped_values(issue, values)
                      concat render_full_width_custom_fields_rows_by_grouped_values(issue, values)
                    end
                  end
                else
                  s << content_tag(custom_fields_group_tag, title, :class => 'custom-fields-groups') unless title.nil?
                  s << render_half_width_custom_fields_rows_by_grouped_values(issue, values)
                  s << render_full_width_custom_fields_rows_by_grouped_values(issue, values)
                end
              end
            end
            # temporary hack
            if custom_fields_group_tag == 'fieldset' && fieldset_default_state == 'all_collapsed'
              s << javascript_tag("$('div.issue div.attributes fieldset.custom-fields-groups>legend').each(function(idx,elem){toggleFieldset(elem);})")
            end
            s
          end

          def render_half_width_custom_fields_rows_by_grouped_values(issue, custom_field_values)
            values = custom_field_values.reject {|value| value.custom_field.full_width_layout?}
            return if values.empty?

            half = (values.size / 2.0).ceil
            issue_fields_rows do |rows|
              values.each_with_index do |value, i|
                m = (i < half ? :left : :right)
                rows.send m, custom_field_name_tag(value.custom_field), custom_field_value_tag(value), :class => value.custom_field.css_classes
              end
            end
          end

          def render_full_width_custom_fields_rows_by_grouped_values(issue, custom_field_values)
            values = custom_field_values.select {|value| value.custom_field.full_width_layout?}
            return if values.empty?

            s = ''.html_safe
            values.each_with_index do |value, i|
              # attr_value_tag = custom_field_value_tag(value)
              # next if attr_value_tag.blank?

              # content =
              #   content_tag('hr') +
              #   content_tag('p', content_tag('strong', custom_field_name_tag(value.custom_field) )) +
              #   content_tag('div', attr_value_tag, class: 'value')
              # s << content_tag('div', content, class: "#{value.custom_field.css_classes} attribute")
              content = content_tag('div', custom_field_name_tag(value.custom_field) + ":", :class => 'label') +
                        content_tag('div', custom_field_value_tag(value), :class => 'value')
              content = content_tag('div', content, :class => "#{value.custom_field.css_classes} attribute")
              s << content_tag('div', content, :class => 'splitcontent')
            end
            s
          end
        end #base
      end #self

      module InstanceMethods

      end #module

      module ClassMethods

      end #module
    end #module
  end #module
end #module

unless IssuesHelper.included_modules.include?(RedmineCustomFieldsGroups::Patches::IssuesHelperPatch)
  IssuesHelper.send(:include, RedmineCustomFieldsGroups::Patches::IssuesHelperPatch)
end
