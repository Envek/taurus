# -*- encoding : utf-8 -*-
class Editor::Reference::GroupsController < Editor::BaseController
  before_filter :find_group
  def index
    except = session[:groups_lists][:groups].any? ? session[:groups_lists][:groups] : 0
    group = params[:group].to_s.gsub('%', '\%').gsub('_', '\_') + '%'
    @groups = Group.all(:conditions => ['id NOT IN (?) AND name LIKE ?', except, group])

    respond_to do |format|
      format.json { render :json => @groups.to_json(:only => [:id], :methods => [:descriptive_name]) }
    end
  end

  def create
    unless @group
      flash[:error] = "Группа не найдена"
    else
      session[:groups_lists][:groups].push(params[:id].to_i).uniq!
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    unless @group
      flash[:error] = "Группа не найдена"
    else
      session[:groups_lists][:groups].delete(params[:id].to_i)
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def find_group
    session[:groups_lists] = {:groups => []} unless session[:groups_lists]
    @group = Group.find_by_id(params[:id])
  end
end
