class PorkerhandsController < ApplicationController
  def index
  end
  def check
     inputs = params[:card].split(" ")
     result = inputs.count
     #手札を半角スペース区切りで取得　例）D8 C8 D7 D12 S7
     pokerhands = params[:card]

     #一枚ずつcards配列に格納　例）["D8", "C8", "D7", "D12", "S7"]
     cards = pokerhands.split

     if cards.count != 5
       @result = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
       render :action => "index"  and return
     elsif cards.size != cards.uniq.size
       @result = "カードが重複しています。"
       render :action => "index"  and return
     else
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

#例　suits = ["D", "C", "D", "D", "S"] numbers = [7, 7, 8, 8, 12]


#└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└役判定└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└


#フラッシュ系判定（suits配列の重複なしの大きさが１）
       if suits.uniq.size == 1
         if (numbers.max-numbers.min == 4 || numbers == [1,10,11,12,13])
           @result =  "ストレートフラッシュ"
         else
           @result  = "フラッシュ"
         end

#４カード・フルハウスの判定（numbers配列の重複なしの大きさが２）
       elsif numbers.uniq.size == 2 &&
         (numbers[0] != numbers[1] || numbers[3] != numbers[4])
         @result  = "フォー・オブ・ア・カインド"
       elsif numbers.uniq.size == 2
         @result  = "フルハウス"

#ストレート判定
       elsif numbers.uniq.size == 5 &&
         (numbers.max-numbers.min == 4 || numbers == [1,10,11,12,13])
         @result  =  "ストレート"

#３カード・２ペアの判定（numbers配列の重複なしの大きさが３）
       elsif numbers.uniq.size == 3 &&
         (numbers[0] == numbers[2] || numbers[1] == numbers[3] || numbers[2] == numbers[4] )
         @result  = "スリー・オブ・ア・カインド"

       elsif numbers.uniq.size == 3
         @result  =  "ツーペア"

#１ペアの判定（numbers配列の重複なしの大きさが４）
       elsif numbers.uniq.size == 4
         @result  = "ワンペア"

#残りはブタ
       else
         @result  =  "ハイカード"
       end

       render :action => "index"  and return
  end
  end

end
