# This file stores helper functions for the NextYearAnimationPlayer node

extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Animation functions:

func hide_year_for_animation():
	self.rect_position = Vector2(135,148)
	
func increase_year_text_by_one():
	text = str(PlayerVariables.current_year + 4)
