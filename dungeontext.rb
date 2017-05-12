#Dungeon Text Adventure with Objects

class Dungeon
  attr_accessor :player, :name

  def initialize(name)
    @name = name
    @player = Player.new("Robert Blake")
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_current_description
    request_action
  end

  def request_action
    puts "where do you want to go"
    show_current_direction_options
    ans = gets.chomp
    go(ans)
  end


  def show_current_direction_options
    puts find_room_in_dungeon(@player.location).full_connections
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end


  def go(direction)
    puts "You go " + direction.to_s
    puts "hello"
    puts @player.location.to_s
    @player.location = find_room_in_direction(direction)
    puts @player.location.to_s
    show_current_description
  end

  class Player
    attr_accessor :name, :location, :inventory

    def initialize(name)
      @name = name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      @name + "\n\nYou are in " + @description
    end

    def full_connections
      @name + @connections.to_s
    end
  end

  class Item
    attr_accessor :reference, :name, :description

    def initialize(reference, name, description)
      @reference = reference
      @name = name
      @description = description
    end

  end

end

#Create the main dungeon object
my_dungeon = Dungeon.new("The Hunter in the Dark")

#Add rooms to the dungeon
my_dungeon.add_room(:study, "Blake's Study", "a large southwest chamber, overlooking the front garden on one side", {:downstairs => :arkham_streets_east})

my_dungeon.add_room(:arkham_streets_east, "Arkham Streets East", "the streets of Arkham", {:west => :federal_hill, :upstairs => :study})

my_dungeon.add_room(:federal_hill, "Federal Hill", "a spectral hump, bristling with huddled roofs and steeples whose remote outlines wavered mysteriously", {:east => :arkham_streets_east, :west => :church_courtyard})

my_dungeon.add_room(:church_courtyard, "The Church's Courtyard", "description", {:east => :federal_hill})

my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave})

my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave})

#Start the dungeon by placing the player in the large cave
my_dungeon.start(:federal_hill)
