class_name new_level
extends Node
	
var level_number: int = 1



class floor_parameters:
	const rooms_count: int = 9
	const x_length: int = 42 # from original rogue, mac may be different
	const y_length: int = 30 # from original rogue, mac may be different
 
class room_parameters:
	#const rooms_min: int = 1
	const rooms_max: int = 9
	const x_min: int = 2
	const y_min: int = 2
	const x_max: int = floor_parameters.x_length / 3
	const y_max: int = floor_parameters.y_length / 3
	const doors_min: int = 1
	const doors_max: int = 4
	
	const isgone_max: int = 4
	const isdark_
	const ismaze
	
	const treasureroom_chance: float = 1/20
	const treasures_max: int = 10
	const treasures_min: int = 2
	const monsters_min: int = 0
	const monsters_max: int = 10 # fill in value, i have no idea, might not even be a limit!

class room:
	var isgone: bool
	var isdark: bool
	var ismaze: bool
	
	var istreasure: bool
	var x_tiles: arr[int] # x coords of room 
	var y_tiles: arr[int] # y coords of room 
	var loot: arr[treasure]
	var monsters: arr[monster]
	var traps: arr[trap]



class level:
	#var rooms_count: int
	var rooms: arr[room]


# Called when the node enters the scene tree for the first time.
func generate_level(floorP, roomP, room, floor):

	for i in range(1, floorP.rooms_count):
		append(level.rooms, generate_room(floorP, roomP))

func generate_room(floorP, roomP):
	
	return room
# if the player is below the amulet spawn floor and does not ahve it, then the
# the game will place it down, seemingly at each level.



# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
