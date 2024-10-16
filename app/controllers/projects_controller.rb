class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    @projects = Project.all  # Fetch all projects, not just for the current user
    @last_search_query = session[:last_search_query]
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)  # Create a new project without user scope
    if @project.save
      redirect_to projects_path, notice: "Project created successfully"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Project updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully"
  end

  private

  def set_project
    @project = Project.find(params[:id])  # Find project by ID without user scope
  end

  def project_params
    params.require(:project).permit(:name, :description, :start_date, :end_date, :status)
  end
end
