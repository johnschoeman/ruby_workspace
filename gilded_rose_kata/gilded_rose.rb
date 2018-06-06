SulfasName = 'Sulfuras, Hand of Ragnaros'
Passes = 'Backstage passes to a TAFKAL80ETC concert'
BrieName = 'Aged Brie'

MaxQuality = 50

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def self.create(name, sell_in, quality)
    case name
    when Passes
      Pass.new(name, sell_in, quality)
    when BrieName
      Brie.new(name, sell_in, quality)
    when SulfasName
      Sulfas.new(name, sell_in, quality)
    else
      new(name, sell_in, quality)
    end
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

class Pass < Item
  def update_quality
    self.increment_quality
    if self.sell_in < 11
      self.increment_quality
    end
    if self.sell_in < 6
      self.increment_quality
    end
    self.decrement_sell_in
    if self.expired?
      self.quality = 0
    end
  end
end

class Brie < Item
  def update_quality
    self.increment_quality
    self.sell_in -= 1
    if self.expired?
      self.increment_quality
    end
  end
end

class Sulfas < Item
  def update_quality; end
end

def update_quality(items)
  items.each(&:update_quality)
end

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

