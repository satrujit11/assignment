class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :search, :dashboard ]
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def new
    @task = @project.tasks.build
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.user = current_user  # Set the current user as the creator of the task

    new_tags = params[:task][:tag_list].split(",").map(&:strip).reject(&:empty?)
    @task.tag_list.add(new_tags) # Add new tags to the task

    if @task.save
      redirect_to project_path(@project), notice: "Task created successfully"
    else
      render :new
    end
  end

  def show
    @comments = @task.comments.includes(:user)
  end

  def edit; end

  def update
    # Similar to create, handle the tag list for updates as well
    new_tags = params[:task][:tag_list].split(",").map(&:strip).reject(&:empty?)
    @task.tag_list.add(new_tags) # Add new tags to the task

    if @task.update(task_params)
      redirect_to project_path(@project), notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path(@project), notice: "Task was successfully deleted."
  end

  def search
    @search_query = params[:query]

    # Handle search query tracking for the current user
    existing_query = current_user.search_queries.find_by(query: @search_query)
    if existing_query
      existing_query.touch  # Update timestamp of existing search query
    elsif @search_query.present?
      current_user.search_queries.create(query: @search_query)  # Create a new search query if it's not blank
    end

    # Search tasks by task name or assigned user's email
    @tasks = Task.left_outer_joins(:assigned_user)  # Left join to include tasks with no assigned user
                 .where("tasks.name LIKE :query OR users.email LIKE :query", query: "%#{@search_query}%")

    render "search_results"
  end


  def dashboard
    @recent_search_queries = current_user.search_queries.order(created_at: :desc).limit(10)
    @assigned_tasks = Task.where(assigned_user_id: current_user.id)  # Get tasks assigned to the current user
  end

  private

  def set_project
    @project = Project.find(params[:project_id])  # Fetch the project without user scope
  end

  def set_task
    @task = Task.find(params[:id])  # Fetch the task without user scope
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :project_id, :tag_list, :assigned_user_id)
  end
end
