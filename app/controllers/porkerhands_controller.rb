class PorkerhandsController < ApplicationController
  def index
  end
  def check
    @result = params[:card]
  end
end
