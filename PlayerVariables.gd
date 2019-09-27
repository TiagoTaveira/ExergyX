extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_year = 2017
var money = 50000000
var utility = 100
var co2_emissions = 70

var investment_renewables_percentage = 30
var yearly_decisions = [YearlyDecision.new(2016, 30, 100, 71)]


var final_year = 2050
var final_year_utility = 100
var final_year_emissions = 70

var utility_goals = 120
var emission_goals = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_yearly_decision(y, i, u, e):
    return YearlyDecision.new(y, i, u, e)

class YearlyDecision:
	
	var year
	var investment_renewables_percentage
	var utility
	var co2_emissions
	
	func _init(y, i, u, e):
		year = y
		investment_renewables_percentage = i
		utility = u
		co2_emissions = e
