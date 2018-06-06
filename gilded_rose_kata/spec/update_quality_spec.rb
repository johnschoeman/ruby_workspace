require 'rspec'
require_relative '../gilded_rose'



describe "update_quality" do

  it "updates a list" do

    initial_items = [
      Item.new("+5 Dexterity Vest", 10, 20),
      Item.new("Aged Brie", 2, 0),
      Item.new("Aged Brie", 0, 2),
      Item.new("Elixir of the Mongoose", 5, 7),
      Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
      Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
      Item.new("Conjured Mana Cake", 3, 6),
      ]

    expected_items = [
      Item.new("+5 Dexterity Vest", 9, 19),
      Item.new("Aged Brie", 1, 1),
      Item.new("Aged Brie", -1, 4),
      Item.new("Elixir of the Mongoose", 4, 6),
      Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
      Item.new("Backstage passes to a TAFKAL80ETC concert", 14, 21),
      Item.new("Conjured Mana Cake", 2, 5),
      ]

    updated_items = update_quality(initial_items)
    puts updated_items

    expect(updated_items).to eq expected_items
  end

  context "normal item" do

    it "test 1" do
      item = Item.new("NORMAL ITEM", 5, 10)
      updated_item = update_quality([item]).first

      expected_sell_in = 4
      expected_quality = 9

      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
    
    it "test 2" do
      item = Item.new("NORMAL ITEM", 0, 10)
      updated_item = update_quality([item]).first
      expected_sell_in = -1
      expected_quality = 8
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end

    
    it "test 3" do
      item = Item.new("NORMAL ITEM", -10, 10)
      updated_item = update_quality([item]).first
      expected_sell_in = -11
      expected_quality = 8
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end


    it "test 4" do
      item = Item.new("NORMAL ITEM", 5, 0)
      updated_item = update_quality([item]).first
      expected_sell_in = 4
      expected_quality = 0
      expect(updated_item.sell_in).to eq expected_sell_in
      expect(updated_item.quality).to eq expected_quality
    end
  end
  
end
