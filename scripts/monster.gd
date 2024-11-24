extends Node

const level_monsters: Array[String] = [
	"kestrel", "emu", "bat", "slime", "hobgoblin", "ice monster", "rattlesnake", 
	"orc", "zombie", "leprechaun", "centaur", "quagga", "aquator", "nymph",
	"yeti", "venus flytrap", "troll", "wraith", "phantom", "xeroc", "urvile",
	"medusa", "vampire", "griffin", "jabberwock", "dragon" 
]

const wandering_monsters: Array = [
	"kestrel", "emu", "bat", "slime", "hobgoblin", 0, "rattlesnake", 
	"orc", "zombie", 0, "centaur", "quagga", "aquator", 0,
	"yeti", 0, "troll", "wraith", "phantom", 0, "urvile",
	"medusa", "vampire", "griffin", "jabberwock", 0 
]

# select what kind of monster we are going to spawn
## dependent on the current level 
## AND on whether it is a wandering or level-start monster

#### for now, resolve "level" at the function scope, rather than global
func random_monster(isWander, level):
	if isWander == true:
		var d: int = level + randi_range(0,10) - 6
		if d < 0:
			d = randi_range(0,5)
		elif d > 25:
			# TESTING randi_range is [0, 4], as discussed in Code Annotations 2.
			d = randi_range(0,4) + 21
		
		return wandering_monsters[d]
	else:

		while true:
			var d: int = level + randi_range(0,10) - 6
			if d < 0:
				d = randi_range(0,5)
			elif d > 25:
				d = randi_range(0,4) + 21
			if typeof(level_monsters[d]) != TYPE_INT:
				return level_monsters[d]
			
		
	

class monster_parameters:
	var doiy: int

class monster: 
	var position: Array[int]
	var health: int


func new_monster():
	monster.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
