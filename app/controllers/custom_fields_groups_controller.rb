class CustomFieldsGroupsController < ApplicationController
  layout 'admin'

  before_action :require_admin

  def index
    @custom_fields_groups = CustomFieldsGroup.sorted
  end

  def new
    @custom_fields_group = CustomFieldsGroup.new
    # @custom_fields_group.custom_fields_group_fields.build
  end

  def create
    @custom_fields_group = CustomFieldsGroup.new(custom_fields_group_params)

    ActiveRecord::Base.transaction do
      @custom_fields_group.save!
    end
    redirect_to custom_fields_groups_path
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @custom_fields_group = CustomFieldsGroup.find params[:id]
    # unless @custom_fields_group.custom_fields_group_fields.present?
    #   @custom_fields_group.custom_fields_group_fields.build
    # end
  end

  def update
    # TODO: @custom_fields_group becomes nil
    custom_fields_group = CustomFieldsGroup.find params[:id]
    ActiveRecord::Base.transaction do
      custom_fields_group.update!(custom_fields_group_params)
    end
    redirect_to custom_fields_groups_path
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    custom_fields_group = CustomFieldsGroup.find params[:id]
    custom_fields_group.destroy
    redirect_to custom_fields_groups_path
  end

  private

  def custom_fields_group_params
    params.require(:custom_fields_group).permit( :name, :position, custom_field_ids: [] )
  end

end
