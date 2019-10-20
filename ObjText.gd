extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Felicidade: " + str(PlayerVariables.utility_goals) + "\n" + "Emissões CO2: " + str(PlayerVariables.emission_goals) + " MT"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
