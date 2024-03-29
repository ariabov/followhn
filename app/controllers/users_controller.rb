class UsersController < AuthenticationController
  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @users }
  #   end
  # end

  # GET /users/1
  # GET /users/1.json
  # def show
  #   @user = User.find(params[:id])

    # respond_to do |format|
    #   # format.html # show.html.erb
    #   format.json { render status: 404 } # json: @user
    # end
  # end

  # GET /users/new
  # GET /users/new.json
  # def new
  #   @user = User.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @user }
  #   end
  # end

  # GET /users/1/edit
  # def edit
  #   @user = User.find(params[:id])
  # end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_or_initialize_by_username(params[:user][:username], params[:user])

    respond_to do |format|
      begin
        if @user.save
          current_end_user.users << @user
          format.html { redirect_to root_path, notice: "You are now following \"#{@user.username}\"" }
          # format.json { render json: @user, status: :created, location: @user }
        else
          format.html { redirect_to root_path, alert:  @user.errors[:base].first } #
          # format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        format.html { redirect_to root_path,   alert:  "You are already following user \"#{@user.username}\"" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  # def update
  #   @user = User.find(params[:id])

  #   respond_to do |format|
  #     if @user.update_attributes(params[:user])
  #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.update_cache
    current_end_user.users.delete(@user)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
end
