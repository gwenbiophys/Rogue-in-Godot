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
	# can we rename these to match the original code? the current names are confusing 
	@warning_ignore("integer_division")
	const x_max: int = rfloor.x_length / 3 # same as bsze.x in source code (box size) 
	@warning_ignore("integer_division")
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
func generate_floor(): 
	var thisFloor = rfloor.new()
	thisFloor.rooms = [] 
	
	var gone_rooms: Array = []
	# gone rooms-- pick random number of rooms, 0-3, randomly pick that number of rooms as gone 
	for n in randi_range(0,3): 
		gone_rooms.append(randi_range(0,8))
		
	for i in range(0, rfloor.rooms_count): # 0 - 8, range is exclusive of the second value 
		thisFloor.rooms.push_back(generate_room(i, gone_rooms)) 
	#print(thisFloor.rooms)
	return(thisFloor)

func generate_room(i, gone_rooms):
	# create a room object 
	var thisRoom = room.new() 
	
	#determine which "box" this room is in (top left corner)
	#print(i)
	thisRoom.box = Vector2.ZERO
	thisRoom.box[0] = i % 3 * room.x_max 
	thisRoom.box[1] = i / 3 * room.y_max 
	#print("testinggggggggggggggggggggggggg")
	#print(thisRoom.box)
	
	if (i in gone_rooms):
		thisRoom.isgone = true
		thisRoom.pos.x = thisRoom.box.x + randi_range(0, room.x_max - 1)
		thisRoom.pos.y = thisRoom.box.y + randi_range(0, room.y_max - 1)
		thisRoom.size = Vector2.ZERO
		return(thisRoom) 
	
	# decide room type 
	# dark or maze room 
	if(randi_range(0,10) < level - 1): 
		thisRoom.isdark = true 
		if(randi_range(0,15) == 0):
			thisRoom.ismaze = true
	
	# decide size and location of room 
	if thisRoom.ismaze == true:
		pass #have to come back and fix this later!!
	else: 
		# choose size of room 
		while(thisRoom.pos.y  == 0):
			thisRoom.size.x = randi_range(0, room.x_max - 4) + 4
			thisRoom.size.y = randi_range(0, room.y_max - 4) + 4
			#print("size: ", thisRoom.size)
			# choose position of room based on size 
			thisRoom.pos.x = thisRoom.box.x + randi_range(0, room.x_max - thisRoom.size.x)
			thisRoom.pos.y = thisRoom.box.y + randi_range(0, room.y_max - thisRoom.size.y) 
			#print("pos: ", thisRoom.pos)
			# if outside bounds of the box (plus buffer), redo 
			# i think i need to redo these lines to properly keep the rooms inside their boxes <<<<< 
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
	return thisRoom # this... this line was the motherFUCKER 
# if the player is below the amulet spawn floor and does not ahve it, then the
# the game will place it down, seemingly at each level.

# called single but actually does all the passages lmao 
func single_passg(floor, adjrooms):
	# init -1 so we can tell if no rooms have been selected yet 
	var r1: int = -1 
	var r2: int = -1 
	var complete_rooms: Array[int]
	var complete_pairs: Array[Vector2] = []
	var curr_adj_rooms: Array[int]
	var all_conn_rooms: Array[int]
	#print("r1: ", r1)
	#print("r2: ", r2)
	#print("complete_rooms: ", complete_rooms)
	
	# define adjacent rooms 
	var select_adj_rooms = func select_adj_rooms(r1): 
		curr_adj_rooms = []
		for i in range(9): 
			if adjrooms[r1][i] == 1: 
				curr_adj_rooms.append(i)
			#print("curr_adj_rooms", curr_adj_rooms)
		return curr_adj_rooms
	
	# selects room 1 (r1) 
	var room_selecter = func room_selecter(r1, curr_adj_rooms, complete_rooms): 
		if (r1 == -1): # on first selection 
			# pick a random r1 
			return randi_range(0,8) 
		else: 
			# pick a room that is adjacent and not complete  
			var comp_filtered_rooms = range(0,9).filter(func(e): return !(e in complete_rooms))  # only incomplete rooms 
			var comp_adj_filtered_rooms = comp_filtered_rooms.filter(func(e): return e in curr_adj_rooms)
			
			#print("curr_adj_rooms (inside function): ", curr_adj_rooms)
			#print("complete_rooms (inside function): ", complete_rooms)
			#print("filtered_rooms: ", comp_adj_filtered_rooms)
			#print("rooms: ", comp_adj_filtered_rooms.pick_random())
			
			if comp_adj_filtered_rooms.size() == 0:  #if no qualifying rooms 
				if comp_filtered_rooms.size() == 0: # if no incomplete rooms at all 
					pass 
				else: 
					return comp_filtered_rooms.pick_random() # pick a random incomplete room 
			else: 
				return comp_adj_filtered_rooms.pick_random() # pick a random incomplete *and* adjacent room 
	
	
	for i in range(9): 
		if !(i in all_conn_rooms): # if there are any rooms that do not have at least 1 passg 
			for j in range(5): # this value can be adjusted-- higher for more hallways 
				if room_selecter.call(r1, curr_adj_rooms, complete_rooms) == null: #if we ran out of incomplete rooms 
					break 
				else: 
					r1 = room_selecter.call(r1, curr_adj_rooms, complete_rooms)
				#print("r1: ", r1)
				
				# (re)define current adjacent rooms 
				curr_adj_rooms = select_adj_rooms.call(r1)
				#print("curr_adj_rooms: ", curr_adj_rooms)
				
				var check_pairs = func check_pairs(room): # check each pair to see if its in the complete_pairs 
					if Vector2(r1, room) in complete_pairs: 
						return true
					else: 
						return false 
				
				# pick an adjacent r2  
				r2 = curr_adj_rooms.pick_random()
				while (Vector2(r1, r2) in complete_pairs): # if complete, redo until not 
					if curr_adj_rooms.all(check_pairs): # if all pairs are already complete 
						r1 = -1 # reset 
						r2 = -1
						break 
					else: # otherwise, try a diff room 
						r2 = curr_adj_rooms.pick_random() 
				
				if r1 >= 0: 
					# set complete rooms and connections 
					complete_rooms.append(r1) 
					all_conn_rooms.append([r1, r2])
					complete_pairs.append(Vector2(r1,r2))
					complete_pairs.append(Vector2(r2,r1)) 
					#print("complete_pairs: ", complete_pairs)
					dig_passg(floor, r1, r2) 
					#await get_tree().create_timer(1).timeout


func generate_passg(floor: rfloor): 
	var rooms: Array = floor.rooms 
	
	# define an adjacent room 
	var adjrooms: Array[Array] = [[]] #2d array 
	#TODO initialize as variable
	for i in range(9): # i = r1
		adjrooms.append([])
		match i: 
			0:
				adjrooms[i].append_array([0, 1, 0, 1, 0, 0, 0, 0, 0])
			1: 
				adjrooms[i].append_array([1, 0, 1, 0, 1, 0, 0, 0, 0])
			2: 
				adjrooms[i].append_array([0, 1, 0, 0, 0, 1, 0, 0, 0])
			3: 
				adjrooms[i].append_array([1, 0, 0, 0, 1, 0, 1, 0, 0])
			4: 
				adjrooms[i].append_array([0, 1, 0, 1, 0, 1, 0, 1, 0])
			5: 
				adjrooms[i].append_array([0, 0, 1, 0, 1, 0, 0, 0, 1])
			6: 
				adjrooms[i].append_array([0, 0, 0, 1, 0, 0, 0, 1, 0])
			7: 
				adjrooms[i].append_array([0, 0, 0, 0, 1, 0, 1, 0, 1])
			8: 
				adjrooms[i].append_array([0, 0, 0, 0, 0, 1, 0, 1, 0])
	
	#print(adjrooms)
	#print(thisFloor.rooms) # prints "names" (ref #s) of all the rooms 
	single_passg(floor, adjrooms) 
	

func dig_passg(thisFloor, r1, r2): 
	#make passageway 
	# determine direction 
	# only right or down; if other way around, just swap r1 and r2, basically 
	var rpf: int #room pointer from 
	var rpt: int # room pointer to 
	var direc: String 
	if (r1 < r2): # "normal" way around 
		rpf = r1 
		rpt = r2
		if (r1 + 1 == r2): 
			direc = "r"
		else: 
			direc = "d"
	else: 
		rpf = r2 # "reverse" way around 
		rpt = r1
		if (r2 + 1 == r1):
			direc = "r"
		else: 
			direc = "d"
	
	#print("check here now uwuuuuuuuuuu")
	var room1 = thisFloor.rooms[rpf]
	#print(room1)
	var room2 = thisFloor.rooms[rpt]
	#print(room2)
	
	# determine door positions / start & end positions 
	# __________ have to add checks for if room is gone!! _________ 
	# these should default to the room position, to avoid issues when room is gone 
	var spos = Vector2(room1.pos)
	#print(room2.pos)
	var epos = Vector2(room2.pos)
	#print("epos")
	#print(epos)
	var turn = Vector2.ZERO # direction of turn 
	var turn_dist: int 
	var turn_loc: int
	var del = Vector2.ZERO
	
	if (direc == "d"): 
		# set starting position to a random spot on lower wall of room1
		if(room1.isgone == false):
			spos.x = room1.pos.x + randi_range(1, room1.size.x - 2) # subtract one bc weird tile math, subtract another to not put door on corner tile
			spos.y = room1.pos.y + room1.size.y - 1
		# set ending position to a random spot on upper wall of room2
		if(room2.isgone == false):
			epos.x = room2.pos.x + randi_range(1, room2.size.x - 2) 
			epos.y = room2.pos.y 
		# determine turn direction and distance 
		turn.y = 0
		if (spos.x < epos.x):
			turn.x = 1 
		else: 
			turn.x = -1
		turn_dist = abs(spos.x - epos.x)
		# determine relative turn location 
		turn_loc = randi_range(1, epos.y - spos.y - 1) 
		del = Vector2(0,1)
	elif (direc == "r"): 
		# set starting position to a random spot on right wall of room1 
		if(room1.isgone == false):
			spos.x = room1.pos.x + room1.size.x - 1
			spos.y = room1.pos.y + randi_range(1, room1.size.y - 2)
		# set ending position to a random spot on left wall of room2 
		if(room2.isgone == false):
			epos.x = room2.pos.x 
			epos.y = room2.pos.y + randi_range(1, room2.size.y - 2)
		# determine turn direction and distance 
		turn.x = 0
		if (spos.y < epos.y):
			turn.y = 1 
		else: 
			turn.y = -1
		turn_dist = abs(spos.y - epos.y)
		# determine relative turn location 
		turn_loc = randi_range(1, epos.x - spos.x - 1) 
		del = Vector2(1,0)
	else: 
		print("you done goofed")
	# FOR TESTING ONLY-- render doors 
	if (room1.isgone == false):
		floormap.set_cell(1,spos, 0, Vector2i(9,0), 0) 
	else: 
		floormap.set_cell(1,spos, 0, Vector2i(8,0), 0) 
	if (room2.isgone == false):
		floormap.set_cell(1,epos, 0, Vector2i(9,0), 0) 
	else: 
		floormap.set_cell(1,epos, 0, Vector2i(8,0), 0) 
	

	var digpos = spos  
	var dist = 0 # blocks travelled 
	while !(digpos == epos):
		#print("spos: ", spos)
		#print("epos: ", epos)
		#print("digpos: ", digpos)
		#print("dist: ", dist)
		#print("turn_loc: ", turn_loc)
		#print("_____________________")
		# determine which part of pass we're on 
		if dist < turn_loc: # if not yet at turn, move 
			digpos += del
		elif dist == turn_loc and turn_dist > 0: # if at turn 
			del = turn # change direction 
			digpos += del # move in new direction 
		elif dist > turn_loc and dist < turn_loc + turn_dist: # if along turn section 
			digpos += del # continue moving in new direction 
		elif dist > turn_loc + turn_dist: # if past turn section 
			if (direc == "d"): # set direction back to original 
				del = Vector2(0,1)
			else: 
				del = Vector2(1,0)
			digpos += del # move in original direction 
		else: 
			pass 
		
		dist += 1 # travelled another block 
		
		if digpos.x > 100 or digpos.y > 100: # preventing from getting stuck in while loop, for bug testing 
			break
		
		if digpos == spos or digpos== epos: 
			pass 
		else: 
			floormap.set_cell(1,digpos, 0, Vector2i(8,0), 0) # change this to add to an array, render later 
	pass 


func render_room(thisRoom): # renders the tiles for the rooms 
	
	var dictCorn = {
		"top_left": thisRoom.pos,
		"top_right": thisRoom.pos + Vector2(thisRoom.size.x - 1, 0),
		"bottom_left": thisRoom.pos + Vector2(0, thisRoom.size.y - 1),
		"bottom_right": thisRoom.pos + Vector2(thisRoom.size.x - 1, thisRoom.size.y - 1), 
	}
	
	# find coords for top wall 
	var xwall_top = range(dictCorn["top_left"].x + 1, dictCorn["top_right"].x)
	var ywall_top: Array = []
	ywall_top.resize(xwall_top.size()) # make it match the length of the x array 
	ywall_top.fill(dictCorn["top_left"].y) # fill it with the y pos 
	
	var coord: Vector2 
	
	var tilesArray_top: Array = []
	for i in range(0, xwall_top.size()): 
		coord = Vector2(0,0)
		coord = Vector2(xwall_top[i], ywall_top[i])
		tilesArray_top.append(coord)
		
	# find coords for bottom wall 
	var xwall_bottom = range(dictCorn["bottom_left"].x + 1, dictCorn["bottom_right"].x)
	var ywall_bottom: Array = []
	ywall_bottom.resize(xwall_bottom.size()) # make it match the length of the x array 
	ywall_bottom.fill(dictCorn["bottom_left"].y) # fill it with the y pos 
	
	var tilesArray_bottom: Array = []
	for i in range(0, xwall_bottom.size()): 
		coord = Vector2(0,0) 
		coord = Vector2(xwall_bottom[i], ywall_bottom[i])
		tilesArray_bottom.append(coord)
		
	
	# find coords for left wall 
	var ywall_left = range(dictCorn["top_left"].y + 1, dictCorn["bottom_left"].y)
	var xwall_left: Array = []
	xwall_left.resize(ywall_left.size()) # make it match the length of the y array 
	xwall_left.fill(dictCorn["top_left"].x) # fill it with the x pos 
	
	var tilesArray_left: Array = []
	for i in range(0, ywall_left.size()): 
		coord = Vector2(0,0) 
		coord = Vector2(xwall_left[i], ywall_left[i])
		tilesArray_left.append(coord)
		
	# find coords for right wall 
	var ywall_right = range(dictCorn["top_right"].y + 1, dictCorn["bottom_right"].y)
	var xwall_right: Array = []
	xwall_right.resize(ywall_right.size()) # make it match the length of the y array 
	xwall_right.fill(dictCorn["top_right"].x) # fill it with the x pos 
	
	var tilesArray_right: Array= []
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
	floormap.set_cell(1,dictCorn["top_left"], 0, Vector2i(3,0), 0) #top left 
	floormap.set_cell(1,dictCorn["top_right"], 0, Vector2i(4,0), 0) # top right 
	floormap.set_cell(1,dictCorn["bottom_left"], 0, Vector2i(5,0), 0) # bottom left
	floormap.set_cell(1,dictCorn["bottom_right"], 0, Vector2i(6,0), 0) # bottom right 
	# sides 
	for each in dictWalls["top"]: 
		floormap.set_cell(1,each, 0, Vector2i(0,0), 0)
	# then copy this for the left, right, and bottom 
	
	for each in dictWalls["bottom"]: 
		floormap.set_cell(1, each, 0, Vector2i(0,0), 0)
	
	for each in dictWalls["left"]: 
		floormap.set_cell(1, each, 0, Vector2i(1,0), 0)
	
	for each in dictWalls["right"]: 
		floormap.set_cell(1, each, 0, Vector2i(2,0), 0)
	# if dark room: 
	
	# render floor tiles 
	# array <- top_left + 1 : top_right - 1 
	var floorArray: Array = []
	for x in range(dictCorn["top_left"].x + 1, dictCorn["top_right"].x): 
		for y in range(dictCorn["top_left"].y + 1, dictCorn["bottom_left"].y): 
			var coordF = Vector2.ZERO 
			coordF = Vector2(x,y)
			floorArray.append(coordF)
	
	#print(floorArray)
	
	for each in floorArray:
		floormap.set_cell(1, each, 0, Vector2i(7,0), 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	floormap = get_node("../FloorMap")
	var thisFloor = generate_floor() 
	#print(thisFloor.rooms)
	generate_passg(thisFloor)
	
	# FOR BUG TESTING!! delete later 
	floormap.set_layer_enabled(1, true)
	
	#for each in thisFloor.rooms:
		#print(each)
		#print(each.box)
		#print(each.size)
		#print(each.pos)
		#
	#print(thisFloor.rooms[4].box) 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("new-floor"):
		floormap.clear()
		print("New floor")
		var thisFloor = generate_floor() 
		generate_passg(thisFloor)



