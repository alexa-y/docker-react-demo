class DashboardController < ApplicationController

  def index
    @posts = Post.all
  end

  def number
    render json: { number: (Post.last.try(:id) || -1) }, status: :ok
  end
end
