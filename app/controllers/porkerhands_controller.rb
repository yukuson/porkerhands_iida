class PorkerhandsController < ApplicationController
  def index
  end
  def check
     inputs = params[:card].split(" ")
     result = inputs.count
     if result != 5
       @result = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
     elsif
       if inputs.size == inputs.uniq.size
         @result = "OK"
       elsif
         @result = "カードが重複しています。"
       end
     end
    render 'index'
  end

end
