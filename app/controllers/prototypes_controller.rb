class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :move_to_index, only: [:edit]
  
  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
    @prototype = Prototype.new
  end

  def create
    Prototype.create(prototype_params)
      redirect_to root_path(@prototype)
 
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    @prototype = Prototype.find(params[:id])
    if
      @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end


  private
  def prototype_params
    params.require(:prototype).permit(:image, :title, :catch_copy, :concept).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototype = Prototype.find(params[:id])
     unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to action: :index
    
  end

end
end
