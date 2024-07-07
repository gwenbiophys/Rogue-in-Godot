class_name new_level
extends Node
	
var level: int = 1

class rfloor: # changed to "rfloor" to avoid conflict with existing godot functions 
	#parameters 
	const rooms_count: int = 9
	const x_length: int = 42 # from original rogue, mac may be different
	const y_length: int = 30 # from original rogue, mac may be different
	
	const treasureroom_chance: float = 1/20
	const treasures_max: int = 10 # in treasure room, specifically 
	const treasures_min: int = 2 # in treasure room 
	
	const monsters_min: int = 0
	#const monsters_max: int = 10 # fill in value, i have no idea, might not even be a limit!
	
	const traps_max: int = 10 
	
	#var rooms_count: int
	var rooms: Array # array of rooms 

class room:
	# parameters 
	#const rooms_min: int = 1
	const rooms_max: int = 9
	const x_min: int = 2
	const y_min: int = 2
	const x_max: int = rfloor.x_length / 3
	const y_max: int = rfloor.y_length / 3
	const doors_min: int = 1
	const doors_max: int = 4
	const isgone_max: int = 4
	
	var box: Vector2 # coords of upper left corner of "box" room is in 
	
	var isgone: bool
	var isdark: bool
	var ismaze: bool
	
	var istreasure: bool
	var x_tiles: Array # x coords of room 
	var y_tiles: Array # y coords of room 
	var loot: Array # array of treasure items 
	var monsters: Array # array of monsters
	var traps: Array # array of traps 


# Called when the node enters the scene tree for the first time.
func generate_floor(room, rfloor): 
	var thisFloor = rfloor.new 
	
	for i in range(1, rfloor.rooms_count):
			
		thisFloor.rooms.append(generate_room(rfloor, room, i)) 
		# for a var, cant just call the "floor" class, have to create 
		# an object with the floor class and then call that object.rooms 

func generate_room(rfloor, room, i):
	# create a room object 
	var thisRoom = room.new 
	
	# determine which "box" this room is in (top left corner)
	#thisRoom.box = Vector2.ZERO
	#thisRoom.box[0] = i % 3 * room.x_max + 1
	#thisRoom.box[1] = i / 3 * room.y_max 
	#print(thisRoom.box)
	
	# decide room type 
	# gone rooms-- pick random number of rooms, 0-3, randomly pick that number of rooms as gone 
	
	# dark or maze room 
	if(randi_range(0,10) < level - 1): 
		thisRoom.isdark = true 
		if(randi_range(0,15) == 0):
			thisRoom.ismaze = true
	
	# decide location of room 
	
	
	# decide size of room 
	
	# add a monster 
	
	# add gold 
	return room
# if the player is below the amulet spawn floor and does not ahve it, then the
# the game will place it down, seemingly at each level.



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_floor(room, rfloor) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


