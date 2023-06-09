class TasksController < ApplicationController
  # before メソッドを利用して, set_task メソッドを各アクション実行前に呼び出す
  # only オプションで対象となるアクションを指定
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.set(wait_nutil: Date.tomorrow.noon).perform_later
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to @task, notice: "タスク「#{@task.name}」を削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      current_user.tasks.import(params[:file])
      redirect_to tasks_url, notice: "タスクを追加しました"
    else
      redirect_to tasks_url, alert: "ファイルを選択してください"
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
