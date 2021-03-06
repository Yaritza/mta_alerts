class RecipientsController < ApplicationController
  before_action :set_recipient, only: [:show, :edit, :update, :destroy]

  # GET /recipients
  # GET /recipients.json
  def index
    @recipients = current_user.recipients
  end

  # GET /recipients/1
  # GET /recipients/1.json
  def show 
    @recipiant = current_user.recipients.find(params[:id])
     rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
  end

  # GET /recipients/1/edit
  def edit  
    current_user.recipients.find(params[:id])
     rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  # POST /recipients
  # POST /recipients.json
  def create
    @recipient = Recipient.new(recipient_params)
    @recipient.user = current_user
    respond_to do |format|
      if @recipient.save
        format.html { redirect_to @recipient, notice: 'Recipient was successfully created.' }
        format.json { render :show, status: :created, location: @recipient }
      else
        format.html { render :new }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipients/1
  # PATCH/PUT /recipients/1.json
  def update
    respond_to do |format|
      if @recipient.update(recipient_params)
        format.html { redirect_to @recipient, notice: 'Recipient was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient }
      else
        format.html { render :edit }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipients/1
  # DELETE /recipients/1.json
  def destroy
    @recipient.destroy
    respond_to do |format|
      format.html { redirect_to recipients_url, notice: 'Recipient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient
      @recipient = Recipient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipient_params
      params.require(:recipient).permit(:first_name, :last_name, :phone_number, :email_address, :user_id, :email_template)
    end
end
