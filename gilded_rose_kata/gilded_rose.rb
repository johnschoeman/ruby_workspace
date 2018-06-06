Sulfas = 'Sulfuras, Hand of Ragnaros'
Passes = 'Backstage passes to a TAFKAL80ETC concert'
Brie = 'Aged Brie'

MaxQuality = 50

def update_quality(items)
  items.each do |item|
    case item.name
    when Sulfas
      puts "sulfas was here"
      next
    when Brie
      deal_with_brie(item)
      if expired?(item)
        increment_quality(item)
      end
    when Passes
      deal_with_passes(item)
    else
      decrement_quality(item)
      if expired?(item)
        decrement_quality(item)
      end
    end

    item.sell_in -= 1
end

def expired?(item)
  item.sell_in < 0
end

def decrement_quality(item)
  if item.quality > 0
    item.quality -= 1
  end
end

def increment_quality(item)
  if item.quality < MaxQuality
    item.quality += 1
  end
end

def deal_with_passes(item)
  if item.quality < MaxQuality
    item.quality += 1
    if item.sell_in < 11
      increment_quality(item)
    end
    if item.sell_in < 6
      increment_quality(item)
    end
  end
  if expired?(item)
    item.quality = 0
  end
end

def deal_with_brie(item)
  if item.quality < MaxQuality
    item.quality += 1
  end
  if expired?(item)
    increment_quality(item)
  end
end
# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

