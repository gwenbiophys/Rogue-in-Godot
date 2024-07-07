class_name new_level
extends Node

var level: int = 1
var floormap: TileMap 

class rfloor: # changed to "rfloor" to avoid conflict with existing godot functions 
	#parameters 
	const rooms_count: int = 9
	const x_length: int = 42 # from original rogue, mac may be different
	const y_length: int = 30 # from original rogue, mac may be different
	
	const treasureroom_chance: float = 0.05
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
	const x_min: int = 4 
	const y_min: int = 4 
	const x_max: int = rfloor.x_length / 3 # same as bsze.x in source code (box size) 
	const y_max: int = rfloor.y_length / 3 # bsze.y
	const doors_min: int = 1
	const doors_max: int = 4
	const isgone_max: int = 4
	
	var box: Vector2 # coords of upper left corner of "box" room is in, same as top.x and top.y in source code
	var size: Vector2 # size of room 
	var pos: Vector2 # position of room 
	
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
	var thisFloor = rfloor.new()
	
	for i in range(0, rfloor.rooms_count): # 0 - 8, range is exclusive of the second value 
		thisFloor.rooms = [0]
		var rooms = thisFloor.rooms
		rooms.push_back(generate_room(rfloor, room, i)) 

func generate_room(rfloor, room, i):
	# create a room object 
	var thisRoom = room.new() 
	
	#determine which "box" this room is in (top left corner)
	#print(i)
	thisRoom.box = Vector2.ZERO
	thisRoom.box[0] = i % 3 * room.x_max + 1
	thisRoom.box[1] = i / 3 * room.y_max 
	#print(thisRoom.box)
	
	# decide room type 
	# gone rooms-- pick random number of rooms, 0-3, randomly pick that number of rooms as gone 
	
	# dark or maze room 
	if(randi_range(0,10) < level - 1): 
		thisRoom.isdark = true 
		if(randi_range(0,15) == 0):
			thisRoom.ismaze = true
	
	# decide size and location of room 
	# ___________ ISSUE!!! there is currently some overlap of the rooms-- need to fix!! 
	if thisRoom.ismaze == true:
		pass
	else: 
		# choose size of room 
		while(thisRoom.pos.y <= 0):
			thisRoom.size.x = randi_range(0, room.x_max - 4) + 4
			thisRoom.size.y = randi_range(0, room.y_max - 4) + 4 
			# choose position of room based on size 
			thisRoom.pos.x = thisRoom.box.x + randi_range(0, room.x_max - thisRoom.size.x)
			thisRoom.pos.y = thisRoom.box.y + randi_range(0, room.y_max - thisRoom.size.y)
			# if outside map, redo 
			# this only checks for the y position, not sure if we need to also check for the x pos? 
		#print(thisRoom.pos)
	
	# add a monster 
	
	# add gold 
	render_room(thisRoom) # this is only inside the function right now for testing, have to move it later 
	return room
# if the player is below the amulet spawn floor and does not ahve it, then the
# the game will place it down, seemingly at each level.

func render_room(thisRoom): 
	pass 
	# renders the tiles for the rooms 
	# if normal room: 
	# change this to have a match expression later? for the different tiles 
	var coord_name = str("")
	
	var dictCoords = {
		"top_left": thisRoom.pos,
		"top_right": thisRoom.pos + Vector2(thisRoom.size.x, 0),
		"bottom_left": thisRoom.pos + Vector2(0, thisRoom.size.y),
		"bottom_right": thisRoom.pos + Vector2(thisRoom.size.x, thisRoom.size.y), 
		"top": [Vector2(1,0),Vector2(2,0),Vector2(3,0)]
		#"left": 
	}
		
	# corners 
	floormap.set_cell(0,dictCoords["top_left"], 0, Vector2i(3,0), 0) #top left 
	floormap.set_cell(0,dictCoords["top_right"], 0, Vector2i(4,0), 0) # top right 
	floormap.set_cell(0,dictCoords["bottom_left"], 0, Vector2i(5,0), 0) # bottom left
	floormap.set_cell(0,dictCoords["bottom_right"], 0, Vector2i(6,0), 0) # bottom right 
	# sides 
	for each in dictCoords["top"]: 
		floormap.set_cell(0,each, 0, Vector2i(0,0), 0)
	# then copy this for the left, right, and bottom 
	
	
	# if dark room: 


# Called when the node enters the scene tree for the first time.
func _ready():
	floormap = get_node("../FloorMap")
	generate_floor(room, rfloor) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


