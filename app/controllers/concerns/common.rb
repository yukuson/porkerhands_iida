module Common
  extend ActiveSupport::Concern

  def rankjudge(myhand) #カードの配列を受けて役の強さ（０〜８）を返す

    suits = []
    randnumbers = []
    myhand.each do |k|
      suits.push k[0]
      randnumbers.push k[1,2]
    end
    numbers = randnumbers.map(&:to_i).sort

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
    handrank
  end


  def ranknamejudge(rank) #役の強さ（０〜８）を受けて役の名前を返す

    pokerrank = ["ハイカード","ワンペア","ツーペア","３カード","ストレート","フラッシュ","フルハウス","４カード","ストレートフラッシュ"]
    rankname = "#{pokerrank[rank]}"
    rankname

  end

  end
