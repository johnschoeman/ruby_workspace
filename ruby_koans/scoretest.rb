def score(dice)
  # Count number of dice of each value
  a = Array.new(6,0)
  dice.each do |die|
    (1..6).each do |val|
      if die == val
        a[val - 1] += 1
      end
    end
  end

  # Tally score
  points = 0

  # Ones
  while a[0] > 0
    if a[0] >= 3
      points += 1000
      a[0] -= 3
    end
    if a[0] > 0 && a[0] < 3
      points += 100
      a[0] -= 1
    end
  end

  # fives
  while a[4] > 0
    if a[4] >= 3
      points += 500
      a[4] -= 3
    end
    if a[4] > 0 && a[4] < 3
      points += 50
      a[4] -= 1
    end
  end

  [1,2,3,5].each do |x|
    3.times do
      if a[x] >= 3
        points += 100*(x+1)
        a[x] -= 3
      end
    end
  end
  
return points

end

score([])
score([1])
score([1,2,2,2,2,2,2,2])
score([1,2,5])
score([5,5,5,1,1,1,3,3,3])
score([2,1,2,4,2])
