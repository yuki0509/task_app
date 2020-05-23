class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  def new
    @task = current_user.tasks.new
  end

  # def confirm_new
  #   @task = current_user.tasks.new(task_params)
  #   render :new unless @task.valid?
  # end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end
    

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to @task, notice: "タスク「#{@task.name}」を保存しました・"
    else
      render :new
    end
  end
  

  def show
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end
  

  private
    def task_params
      params.require(:task).permit(:name, :description, :image)
    end
  
    def set_task
      @task = current_user.tasks.find(params[:id])
    end
    
end
