class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to project_task_path(@task.project, @task), notice: "Comment added successfully."
    else
      redirect_to project_task_path(@task.project, @task), alert: "Unable to add comment."
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    @comment.destroy
    redirect_to project_task_path(@task.project, @task), notice: "Comment deleted successfully."
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
