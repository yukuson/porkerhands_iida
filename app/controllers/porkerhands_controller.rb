class PorkerhandsController < ApplicationController
  def index
  end
  def check
    @result = params[:card]
    render 'index'
  end

end
