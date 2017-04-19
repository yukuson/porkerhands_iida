class PorkerhandsController < ApplicationController
  def index
  end
  def check

    #手札を半角スペース区切りで取得　例）D8 C8 D7 D12 S7
    hands = params[:card]
    p hands

    #一枚ずつcards配列に格納　例）["D8", "C8", "D7", "D12", "S7"]
    cards = hands.split
    p cards

    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓エラー判定↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

    if cards.count != 5
      p 'カードの枚数が５に等しくない'
      @result = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
      render :action => "index"  and return
    elsif cards.size != cards.uniq.size
      p 'カードの枚数（重複あり）とカードの枚数（重複なし）が等しくない'
      @result = "カードが重複しています。"
      render :action => "index"  and return
    else
      trump = [ "S1","S2","S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13",
                "H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12","H13",
                "D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12","D13",
                "C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13"]
      p trump
      error = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      p error
      errorplus = ""
      p errorplus

      cards.reverse_each do |t|
        if trump.include?(t) == false
          p 'カードの中にトランプに含まれないものがある'
          errorplus.insert(0 ,  "#{cards.index(t) + 1}番目の文字列が無効です。(#{t})\n ")
        end
      end
      if errorplus != ""
        p 'カードは全てトランプに含まれている'
        error.insert(0, "#{errorplus}")
        @result = " #{error}  "
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
        handlank = 3
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

