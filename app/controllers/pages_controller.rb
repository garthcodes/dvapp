class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  def new
    @page = current_user.pages.new
  end

  def create
    @page = current_user.pages.create(page_params)
    redirect_to edit_page_path(@page)
  end

  def edit
    @page = current_user.pages.find(params[:id])
  end

  def update
    @page = current_user.pages.find(params[:id])
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def show
    @page = current_user.pages.find(params[:id])
    start = TwitterApi.new
    @hashtag = @page.hashtag
    hash_response = start.response(@hashtag)
    @next_url = hash_response["next_url"]
    @tweets = hash_response["data"]
  end


  private

  def page_params
    params.require(:page).permit!
  end

end 