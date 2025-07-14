class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, except: [:index]
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    @contents = policy_scope(Content).includes(:organization, :user).recent
    authorize Content
  end

  def show
    authorize @content
  end

  def new
    @content = @organization.contents.build
    authorize @content
  end

  def create
    @content = @organization.contents.build(content_params)
    @content.user = current_user
    authorize @content

    if @content.save
      redirect_to [@organization, @content], notice: 'Content was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @content
  end

  def update
    authorize @content

    if @content.update(content_params)
      redirect_to [@organization, @content], notice: 'Content was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @content
    @content.destroy
    redirect_to @organization, notice: 'Content was successfully deleted.'
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
  end

  def set_content
    if @organization
      @content = @organization.contents.find(params[:id])
    else
      @content = Content.find(params[:id])
    end
  end

  def content_params
    params.require(:content).permit(:title, :body, :age_rating)
  end
end
