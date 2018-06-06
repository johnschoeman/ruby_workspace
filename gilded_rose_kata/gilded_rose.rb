Sulfas = 'Sulfuras, Hand of Ragnaros'
Passes = 'Backstage passes to a TAFKAL80ETC concert'
Brie = 'Aged Brie'

MaxQuality = 50

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def ==(other)
    other.name == name && other.sell_in == sell_in && other.quality == quality
  end

  def expired?
    sell_in < 0
  end

  def decrement_sell_in
    self.sell_in -= 1
    if self.expired?
      self.decrement_quality
    end
  end

  def decrement_quality
    if self.quality > 0
      self.quality -= 1
    end
  end

  def update_quality
    decrement_quality
    decrement_sell_in
  end

  def increment_quality
    if self.quality < MaxQuality
      self.quality += 1
    end
  end
end

def update_quality(items)
  items.each do |item|
    case item.name
    when Sulfas
      next
    when Brie
      deal_with_brie(item)
    when Passes
      deal_with_passes(item)
    else
      item.update_quality
    end
  end
end

# def increment_quality(item)
#   if item.quality < MaxQuality
#     item.quality += 1
#   end
# end

def deal_with_passes(item)
  item.increment_quality
  if item.sell_in < 11
    item.increment_quality
  end
  if item.sell_in < 6
    item.increment_quality
  end
  item.decrement_sell_in
  if item.expired?
    item.quality = 0
  end
end

def deal_with_brie(item)
  item.increment_quality
  item.sell_in -= 1
  if item.expired?
    item.increment_quality
  end
end
# DO NOT CHANGE THINGS BELOW -----------------------------------------

# Item = Struct.new(:name, :sell_in, :quality)

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

