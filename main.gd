extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# just for testing-- shows boxes for level generation 
func _draw(): 
	draw_dashed_line(Vector2(252,0), Vector2(252,540), Color.BLACK, -1.0, 1.0)
	draw_dashed_line(Vector2(504,0), Vector2(504,540), Color.BLACK, -1.0, 1.0)
	draw_dashed_line(Vector2(756,0), Vector2(756,540), Color.BLACK, -1.0, 1.0)
	
	draw_dashed_line(Vector2(0,180), Vector2(756,180), Color.BLACK, -1.0, 1.0)
	draw_dashed_line(Vector2(0,360), Vector2(756,360), Color.BLACK, -1.0, 1.0)
	draw_dashed_line(Vector2(0,540), Vector2(756,540), Color.BLACK, -1.0, 1.0)
	#const x_length: int = 42 
		# 42 * 18 = 756 pixels 
		# 252 
		# 504 
		# 756 
	#const y_length: int = 30 
		# 30 * 18 = 540 pixels 
		# 180 
		# 360 
		# 540 
