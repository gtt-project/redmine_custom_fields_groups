module CustomFieldsGroupsHelper
  # Referred:
  # - redmine/lib/redmine/field_format.rb
  #   - def check_box_edit_tag
  # - redmine/app/helpers/custom_fields_helper.rb
  #   - def custom_field_tag_with_label
  #   - def custom_field_label_tag
  def group_fields_edit_tag(group, options={})
    tag_id = 'custom_fields_group[custom_field_ids]'
    tag_name = 'custom_fields_group[custom_field_ids][]'
    opts = []
    group_field_ids = group.custom_field_ids
    other_group_field_ids = CustomFieldsGroupField.all.collect { |gf|
      gf.custom_field_id
    } - group_field_ids
    opts += IssueCustomField.where.not(id: other_group_field_ids).sorted.collect do |cf|
      [cf.name, cf.id]
    end
    s = ''.html_safe
    opts.each do |label, value|
      value ||= label
      checked = group_field_ids.include?(value)
      tag = check_box_tag(tag_name, value, checked, :id => tag_id)
      s << content_tag('label', tag + ' ' + label)
    end
    s << hidden_field_tag(tag_name, '', :id => nil)
    css = "#{options[:class]} check_box_group"
    label = content_tag('label', l(:label_custom_field_plural), :for => tag_id)
    label + content_tag('span', s, options.merge(:class => css))
  end
end
