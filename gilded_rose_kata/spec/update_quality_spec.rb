require 'rspec'
require 'pry'
require_relative '../gilded_rose'

describe "update_quality" do

  it "updates a list" do

    initial_items = [
      Item.create("+5 Dexterity Vest", 10, 20),
      Item.create("Aged Brie", 2, 0),
      Item.create("Aged Brie", 0, 2),
      Item.create("Elixir of the Mongoose", 5, 7),
      Item.create("Sulfuras, Hand of Ragnaros", 0, 80),
      Item.create("Backstage passes to a TAFKAL80ETC concert", 15, 20),
      Item.create("Conjured Mana Cake", 3, 6),
      ]

    expected_items = [
      Item.create("+5 Dexterity Vest", 9, 19),
      Item.create("Aged Brie", 1, 1),
      Item.create("Aged Brie", -1, 4),
      Item.create("Elixir of the Mongoose", 4, 6),
      Item.create("Sulfuras, Hand of Ragnaros", 0, 80),
      Item.create("Backstage passes to a TAFKAL80ETC concert", 14, 21),
      Item.create("Conjured Mana Cake", 2, 5),
      ]

    updated_items = update_quality(initial_items)
    puts updated_items

    expect(updated_items).to eq expected_items
  end

  context "normal item" do

    it "test 1" do
      item = Item.create("NORMAL ITEM", 5, 10)
      updated_item = update_quality([item]).first

      expected_sell_in = 4
      expected_quality = 9

      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
    
    it "test 2" do
      item = Item.create("NORMAL ITEM", 0, 10)
      updated_item = update_quality([item]).first
      expected_sell_in = -1
      expected_quality = 8
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    
    it "test 3" do
      item = Item.create("NORMAL ITEM", -10, 10)
      updated_item = update_quality([item]).first
      expected_sell_in = -11
      expected_quality = 8
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end


    it "test 4" do
      item = Item.create("NORMAL ITEM", 5, 0)
      updated_item = update_quality([item]).first
      expected_sell_in = 4
      expected_quality = 0
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
  end
  
  context "Brie" do
    
    it "before sell date" do
      name = "Aged Brie"
      initial_sell_in = 5
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = initial_sell_in - 1
      expected_quality = initial_quality + 1
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "before sell date with max quality" do
      name = "Aged Brie"
      initial_sell_in = 5
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = initial_sell_in - 1
      expected_quality = initial_quality
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "on sell date" do
      name = "Aged Brie"
      initial_sell_in = 5
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 4
      expected_quality = 11
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
    
    it "on sell date near max quality" do
      name = "Aged Brie"
      initial_sell_in = 0
      initial_quality = 49
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = -1
      expected_quality = 50
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "on sell date with max quality" do
      name = "Aged Brie"
      initial_sell_in = 0
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = initial_sell_in - 1
      expected_quality = initial_quality
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "after sell date with 10 quality" do
      name = "Aged Brie"
      initial_sell_in = -10
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = -11
      expected_quality = 12
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "after sell date with max quality" do
      name = "Aged Brie"
      initial_sell_in = -10
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = initial_sell_in - 1
      expected_quality = initial_quality
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
  end

  context "Sulfuras" do

    it "before sell date" do
      name = "Sulfuras, Hand of Ragnaros"
      initial_sell_in = 5
      initial_quality = 80
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 5
      expected_quality = 80
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "on sell date" do
      name = "Sulfuras, Hand of Ragnaros"
      initial_sell_in = 0
      initial_quality = 80
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 0
      expected_quality = 80
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "after sell date" do
      name = "Sulfuras, Hand of Ragnaros"
      initial_sell_in = -10
      initial_quality = 80
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = -10
      expected_quality = 80
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
  end

  context "Passes" do

    it "long before sell date" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 11
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 10
      expected_quality = 11
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "long before sell date at max quality" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 11
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 10
      expected_quality = 50
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end


    it "medium close to sell date" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 10
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 9
      expected_quality = 12
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
    

    it "medium close to sell date at max quality" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 10
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 9
      expected_quality = 50
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "medium close to sell date, lower bound" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 6
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 5
      expected_quality = 12
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "medium close to sell date, lower bound, at max" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 6
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 5
      expected_quality = 50
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "very close to sell date" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 5
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 4
      expected_quality = 13
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "very close to sell date, at max" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 5
      initial_quality = 50
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 4
      expected_quality = 50
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "very close to sell date, lower bound, at max" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 1
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = 0
      expected_quality = 13
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
    

    it "on sell date" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = 0
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = -1
      expected_quality = 0
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    it "after sell date" do
      name = 'Backstage passes to a TAFKAL80ETC concert'
      initial_sell_in = -10
      initial_quality = 10
      item = Item.create(name, initial_sell_in, initial_quality)
      updated_item = update_quality([item]).first
      expected_sell_in = -11
      expected_quality = 0
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end


  end

end
