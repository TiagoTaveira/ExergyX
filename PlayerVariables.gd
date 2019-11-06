extends Node

# Current year variables
var current_year = 2017
var money = 50000000
var utility = 100
var co2_emissions = 70
var economic_growth = 1

# Player decisions here
var investment_renewables_percentage = 30
var economy_type_level_transportation = 6       #from 1 to 11 (visual -5 to 5), maps to percentage
var economy_type_level_industry = 6
var economy_type_level_residential = 6
var economy_type_level_services = 6
var electrification_by_sector_level_transportation = 6   #from 1 to 11 (visual -5 to 5), maps to percentage
var electrification_by_sector_level_industry = 6
var electrification_by_sector_level_residential = 6
var electrification_by_sector_level_services = 6

var yearly_decisions = [YearlyDecision.new(2016, 30, 100, 71)]  #TODO: Update

# Storage for post-processed player decisions (for percentages, add all values then map to %)
var economy_type_percentage_transportation = 25       #from 0 to 100
var economy_type_percentage_industry = 25
var economy_type_percentage_residential = 25
var economy_type_percentage_services = 25
var electrification_by_sector_percentage_transportation = 25   #from 0 to 100
var electrification_by_sector_percentage_industry = 25
var electrification_by_sector_percentage_residential = 25
var electrification_by_sector_percentage_services = 25

# Final year predictions
var final_year = 2050
var final_year_utility = 100
var final_year_emissions = 70
var final_year_economic_growth = 1

# Final year goals
var utility_goals = 120
var emission_goals = 35
var economic_growth_goals = 1

var extra_year_text = ""

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
