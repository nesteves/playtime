class PledgesController < ApplicationController
  before_action :set_pledge, only: [:show, :edit, :update, :destroy]

  def index
    authorize Pledge
    respond_to do |format|
      format.html { @pledges = Pledge.all }
      format.csv  { export_csv }
    end
  end

  def show
    authorize @pledge
  end

  def edit
    authorize @pledge
  end

  def create
    authorize Pledge
    @pledge = Pledge.increment_or_new(pledge_params)

    if @pledge.save
      redirect_to @pledge, notice: 'Pledge was successfully created.'
    else
      message = "Invalid pledge: #{@pledge.errors.full_messages.join('; ')}"
      redirect_to :root, alert: message
    end
  end

  def update
    authorize @pledge
    if @pledge.update(pledge_params)
      redirect_to @pledge, notice: 'Pledge was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @pledge
    pledging_user = @pledge.user
    @pledge.destroy
    redirect_to user_path(pledging_user), notice: 'Pledge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pledge
      @pledge = Pledge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pledge_params
      params.require(:pledge).permit(:wishlist_item_id, :user_id, :quantity)
    end

    def export_csv
      send_data(Pledge.generate_csv, filename: "pledge_data#{Time.now.to_i}.csv")
    end
end
