class PorkerhandsController < ApplicationController
  include Common
  def index
  end
  def check
    hands = params[:card]
    cards = hands.split

    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓エラー判定↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

    error_input = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
    error_duplication = "カードが重複しています。"
    error_normalization = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
    error_flag = false

    if cards.count != 5
      @result = error_input
      render :action => "index"  and return
    elsif cards.size != cards.uniq.size
      @result = error_duplication
      render :action => "index"  and return
    else
      cards.reverse_each do |t|
        if t !~ /\A[SHDC]\d\z/ && t !~ /\A[SHDC]1[0-3]\z/
          error_normalization.insert(0 , "#{cards.index(t)+1}番目の文字列が無効です。(#{t})" )
          error_flag = true
        end
      end
      if error_flag
        @result = error_normalization
        render :action => "index"  and return
      end
    end

    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓役判定↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↑↑↑

    @result = "#{ranknamejudge(rankjudge(cards))}"
    render :action => "index"
  end
end

