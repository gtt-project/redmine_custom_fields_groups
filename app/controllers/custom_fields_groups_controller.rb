class CustomFieldsGroupsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :find_custom_fields_group, only: %i[edit update destroy]

  def index
    @custom_fields_groups = CustomFieldsGroup.sorted
  end

  def new
    @custom_fields_group = CustomFieldsGroup.new
  end

  def create
    @custom_fields_group = CustomFieldsGroup.new
    @custom_fields_group.safe_attributes = custom_fields_group_params
    if @custom_fields_group.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to custom_fields_groups_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @custom_fields_group.safe_attributes = custom_fields_group_params
    if @custom_fields_group.save
      respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_update)
          redirect_to custom_fields_groups_path
        end
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 422 }
      end
    end
  end

  def destroy
    begin
      if @custom_fields_group.destroy
        flash[:notice] = l(:notice_successful_delete)
      end
    rescue
      flash[:error] = l(:error_can_not_delete_custom_fields_group)
    end
    redirect_to custom_fields_groups_path
  end

  private

  def custom_fields_group_params
    params.require(:custom_fields_group).permit(:name, :position, custom_field_ids: [])
  end

  def find_custom_fields_group
    @custom_fields_group = CustomFieldsGroup.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
