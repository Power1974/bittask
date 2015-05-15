class TasksController < ApplicationController

  def create
    @task = Task.new
    @task.user = current_user
    @task.title = params[:task][:title]
    @task.task_type = Task::TYPE_MULTIPLE_CHOICE # only one supported right now
    @task.choices = params[:task][:choices].split("\n")
    @task.cost = params[:task][:cost]

    if @task.save
      redirect_to task_path(@task)
    else
      render 'tasks/new'
    end
  end

  def new
    @task = Task.new
  end

  # get a task to show users
  def show

  end

  def index
    render json: Task.all
  end

  def latest
    # Tasks that user has answered
    tasks = Answer.select(:task_id).user(current_user.id)
    # Tasks that user has not answered ordered by descending cost
    task = Task.where.not(id: tasks).where(active: true).order(cost: :desc).first

    render json: task
  end

end
