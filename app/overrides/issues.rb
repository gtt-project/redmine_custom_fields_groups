module Issues
  Deface::Override.new(
    :virtual_path => "issues/show",
    :name => "deface_replace_render_half_width_custom_fields_rows",
    :replace => "erb[loud]:contains('render_half_width_custom_fields_rows(@issue)')",
    :original => "<%= render_half_width_custom_fields_rows(@issue) %>",
    :text => "<%= render_custom_fields_rows_by_groups(@issue) %>"
  )

  Deface::Override.new(
    :virtual_path => "issues/show",
    :name => "deface_remove_render_full_width_custom_fields_rows",
    :remove => "erb[loud]:contains('render_full_width_custom_fields_rows(@issue)')",
    :original => "<%= render_full_width_custom_fields_rows(@issue) %>"
  )
end
