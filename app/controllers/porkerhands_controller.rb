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


    #空のsuits,numbersyetsort配列の用意
    suits = []
    numbersyetsort = []

    #cardsの全要素について,１文字目をsuits配列に、２〜３文字目をnumbersyetsort配列に追加
    cards.each do |k|
      suits.push k[0]
      numbersyetsort.push k[1,2]
    end

    #numbersyetsort配列をint型に変換し、数字順にソート
    numbers = numbersyetsort.map(&:to_i).sort

    p suits
    p numbersyetsort
    p numbers


    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓役判定↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓


    #フラッシュ系判定（suits配列の重複なしの大きさが１）
    if suits.uniq.size == 1
      p "手札のスートが１種類"
      if (numbers.max-numbers.min == 4 ||numbers == [1,10,11,12,13])
        p "手札のスートが１種類かつ手札の最大値と最小値の差分が４、または数値が１、１０、１１、１２、１３"
        @result =  "ストレートフラッシュ"
      else
        @result  = "フラッシュ"
      end

      #４カード・フルハウスの判定（numbers配列の重複なしの大きさが２）
    elsif numbers.uniq.size == 2 &&
      (numbers[0] != numbers[1] || numbers[3] != numbers[4])
      p '手札の数字が２種類かつ同じ数字４枚'
      @result  = "フォー・オブ・ア・カインド"

    elsif numbers.uniq.size == 2
      p '手札の数字が２種類'
      @result  = "フルハウス"

      #ストレート判定
    elsif numbers.uniq.size == 5 &&
      (numbers.max-numbers.min == 4 || numbers == [1,10,11,12,13])
      p '手札の最大値と最小値の差分が４、または数値が１、１０、１１、１２、１３'
      @result  =  "ストレート"

      #３カード・２ペアの判定（numbers配列の重複なしの大きさが３）
    elsif numbers.uniq.size == 3 &&
      (numbers[0] == numbers[2] || numbers[1] == numbers[3] || numbers[2] == numbers[4] )
      p '手札の数字が３種類かつ同じ数字３枚'
      @result  = "スリー・オブ・ア・カインド"

    elsif numbers.uniq.size == 3
      p '手札の数字が３種類'
      @result  =  "ツーペア"

      #１ペアの判定（numbers配列の重複なしの大きさが４）
    elsif numbers.uniq.size == 4
      p '手札の数字が４種類'
      @result  = "ワンペア"

      #残りはブタ
    else
      p 'どの条件にも当てはまらない'
      @result  =  "ハイカード"
    end

    #↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑役判定↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    render :action => "index"  and return
  end
end

