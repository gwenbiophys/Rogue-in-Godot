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
	if thisRoom.ismaze == true:
		pass
	else: 
		# choose size of room 
		while(thisRoom.pos.y  == 0):
			thisRoom.size.x = randi_range(0, room.x_max - 4) + 4
			thisRoom.size.y = randi_range(0, room.y_max - 4) + 4
			# choose position of room based on size 
			thisRoom.pos.x = thisRoom.box.x + randi_range(0, room.x_max - thisRoom.size.x)
			thisRoom.pos.y = thisRoom.box.y + randi_range(0, room.y_max - thisRoom.size.y) 
			# if outside bounds of the box (plus buffer), redo 
			if (thisRoom.pos.y >= thisRoom.box.y + thisRoom.size.y - 1 ): 
				thisRoom.pos.y = 0
			if (thisRoom.pos.y <= thisRoom.box.y + 1): 
				thisRoom.pos.y = 0
			if (thisRoom.pos.x <= thisRoom.box.x + 1): 
				thisRoom.pos.y = 0 
			if (thisRoom.pos.x >= thisRoom.box.x + thisRoom.size.x - 1): 
				thisRoom.pos.y = 0 

		#print(thisRoom.pos)
	
	# add a monster 
	
	# add gold 
	
	render_room(thisRoom) # this is only inside the function right now for testing, have to move it later 
		# move to wherever the "when player enters a room" code will be 
	return room
# if the player is below the amulet spawn floor and does not ahve it, then the
# the game will place it down, seemingly at each level.

func render_room(thisRoom): # renders the tiles for the rooms 
	pass 
	
	var dictCorn = {
		"top_left": thisRoom.pos,
		"top_right": thisRoom.pos + Vector2(thisRoom.size.x, 0),
		"bottom_left": thisRoom.pos + Vector2(0, thisRoom.size.y),
		"bottom_right": thisRoom.pos + Vector2(thisRoom.size.x, thisRoom.size.y), 
		
		#"left": 
	}
	
	# find coords for top wall 
	var xwall_top = range(dictCorn["top_left"].x + 1, dictCorn["top_right"].x)
	var ywall_top: Array 
	ywall_top.resize(xwall_top.size()) # make it match the length of the x array 
	ywall_top.fill(dictCorn["top_left"].y) # fill it with the y pos 
	
	var coord: Vector2 
	
	var tilesArray_top: Array
	for i in range(0, xwall_top.size()): 
		coord = Vector2(0,0)
		coord = Vector2(xwall_top[i], ywall_top[i])
		tilesArray_top.append(coord)
		
	# find coords for bottom wall 
	var xwall_bottom = range(dictCorn["bottom_left"].x + 1, dictCorn["bottom_right"].x)
	var ywall_bottom: Array 
	ywall_bottom.resize(xwall_bottom.size()) # make it match the length of the x array 
	ywall_bottom.fill(dictCorn["bottom_left"].y) # fill it with the y pos 
	
	var tilesArray_bottom: Array
	for i in range(0, xwall_bottom.size()): 
		coord = Vector2(0,0) 
		coord = Vector2(xwall_bottom[i], ywall_bottom[i])
		tilesArray_bottom.append(coord)
		
	
	# find coords for left wall 
	var ywall_left = range(dictCorn["top_left"].y + 1, dictCorn["bottom_left"].y)
	var xwall_left: Array 
	xwall_left.resize(ywall_left.size()) # make it match the length of the y array 
	xwall_left.fill(dictCorn["top_left"].x) # fill it with the x pos 
	
	var tilesArray_left: Array
	for i in range(0, ywall_left.size()): 
		coord = Vector2(0,0) 
		coord = Vector2(xwall_left[i], ywall_left[i])
		tilesArray_left.append(coord)
		
	# find coords for right wall 
	var ywall_right = range(dictCorn["top_right"].y + 1, dictCorn["bottom_right"].y)
	var xwall_right: Array 
	xwall_right.resize(ywall_right.size()) # make it match the length of the y array 
	xwall_right.fill(dictCorn["top_right"].x) # fill it with the x pos 
	
	var tilesArray_right: Array
	for i in range(0, ywall_right.size()): 
		coord = Vector2(0,0) 
		coord = Vector2(xwall_right[i], ywall_right[i])
		tilesArray_right.append(coord)
		
	
	var dictWalls = {
		"top": tilesArray_top,
		"bottom": tilesArray_bottom,
		"left": tilesArray_left,
		"right": tilesArray_right
	}
	
	
	# if normal room: 
	# corners 
	floormap.set_cell(0,dictCorn["top_left"], 0, Vector2i(3,0), 0) #top left 
	floormap.set_cell(0,dictCorn["top_right"], 0, Vector2i(4,0), 0) # top right 
	floormap.set_cell(0,dictCorn["bottom_left"], 0, Vector2i(5,0), 0) # bottom left
	floormap.set_cell(0,dictCorn["bottom_right"], 0, Vector2i(6,0), 0) # bottom right 
	# sides 
	for each in dictWalls["top"]: 
		floormap.set_cell(0,each, 0, Vector2i(0,0), 0)
	# then copy this for the left, right, and bottom 
	
	for each in dictWalls["bottom"]: 
		floormap.set_cell(0, each, 0, Vector2i(0,0), 0)
	
	for each in dictWalls["left"]: 
		floormap.set_cell(0, each, 0, Vector2i(1,0), 0)
	
	for each in dictWalls["right"]: 
		floormap.set_cell(0, each, 0, Vector2i(2,0), 0)
	# if dark room: 


# Called when the node enters the scene tree for the first time.
func _ready():
	floormap = get_node("../FloorMap")
	generate_floor(room, rfloor) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


