extends Node


var Title: String
var Price: int
var Prob: float
var Desc: Array
var isUsed: bool
var Type: String
var impact: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init_this(title, price, prob, desc, type, valuesArray): 
	Title = title
	Price = price
	Prob = prob
	Desc = desc
	isUsed = false
	Type = type
	impact["Ren"] = valuesArray[0]
	impact["Ele"] = valuesArray[1] 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func getTitle():
	return Title

func getPrice():
	return Price

func getProb():
	return Prob

func getDesc():
	return Desc

func setUse(value):
	isUsed = value

func getType():
	return Type

func getImpact():
	return impact
