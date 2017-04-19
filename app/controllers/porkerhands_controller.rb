class PorkerhandsController < ApplicationController
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

    #↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑エラー判定↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓役判定↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↑↑↑

    suits = []
    randnumbers = []
    cards.each do |k|
      suits.push k[0]
      randnumbers.push k[1,2]
    end
    numbers = randnumbers.map(&:to_i).sort

    pokerrank = ["ハイカード","ワンペア","ツーペア","３カード","ストレート","フラッシュ","フルハウス","４カード","ストレートフラッシュ"]

    if numbers.uniq.size == 2
      if numbers[0] == numbers[3] || numbers[1] == numbers[4]
        handrank = 7
      else
        handrank = 6
      end
    elsif numbers.uniq.size == 3
      if numbers[0] == numbers[2] || numbers[1] == numbers[3] || numbers[2] == numbers[4]
        handrank = 3
      else
        handrank = 2
      end
    elsif numbers.uniq.size == 4
      handrank = 1
    elsif numbers.uniq.size == 5
      if suits.uniq.size == 1 && (numbers[4] - numbers[0] == 4 ||numbers == [1,10,11,12,13])
        handrank = 8
      elsif suits.uniq.size == 1
        handrank = 5
      elsif numbers[4] - numbers[0] == 4 || numbers == [1,10,11,12,13]
        handrank = 4
      else
        handrank = 0
      end
    end

    @result = "#{pokerrank[handrank]}"

    #↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑役判定↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    render :action => "index"  and return
  end
end

