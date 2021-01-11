class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, raise: false
  # GET /users
  # GET /users.json
  def index
    # headers['Access-Control-Allow-Origin'] = '*'
    respond_to do |format|
      format.html { render index: @users = User.all  }
      format.json { render json: User.all, include: ['reviews'] }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    headers['Access-Control-Allow-Origin'] = '*'
    respond_to do |format|
      format.html { render index: @users = User.all  }
      format.json { render json: User.where(id: params[:id] ), include: ['reviews'] }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.save

    respond_to do |format|
      if @user.persisted?
        session[:user_id] = @user.id

        format.html { redirect_to user_path(user.id) }
        format.json { render json: { user: @user, logged_in: true }}
      else

        format.html { render :new }
        format.json { render json: { status: 401, errors: 'Could not create account' }}

      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
