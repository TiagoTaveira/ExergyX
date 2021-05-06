# Global player variables, used by the game (MainScene.gd)
# The goals of the game are defined here

extends Node

var starting_year = 2011

# Current year variables
var current_year = 2011
var money = 50000000
var expenditure = 0 #"consumo"
var utility = 100
var co2_emissions = 70
var economic_growth = 1
var cost_per_gigawatt = 20100
var efficiency = 0.7
var total_installed_power = 0.00
var renewable_energy = 0.00

var economy_type_percentage_transportation = 25.00     #from 0 to 100, sum of all four 100%
var economy_type_percentage_industry = 25.00
var economy_type_percentage_residential = 25.00
var economy_type_percentage_services = 25.00
var electrification_by_sector_percentage_transportation = 25.00  #from 0 to 100
var electrification_by_sector_percentage_industry = 25.00
var electrification_by_sector_percentage_residential = 25.00
var electrification_by_sector_percentage_services = 25.00

# Final year predictions
var final_year = 2050
var final_year_utility = 100
var final_year_emissions = 70
var final_year_efficiency = 0.00
var final_year_expenditure = 0
var final_year_money = 0
var final_year_economic_growth = 1

# Final year goals
var utility_goals = 1
var emission_goals = 14  # NOTA: No roteiro este valor é de 2 Mt CO2
var economic_growth_goals = 1 # Unused as of this version
# Player decisions here
var investment_renewables_percentage = 0.00
var investment_cost = 0
var economy_type_level_transportation = 6       #from 1 to 11 (visual -5 to 5), maps to percentage
var economy_type_level_industry = 6
var economy_type_level_residential = 6
var economy_type_level_services = 6
var electrification_by_sector_level_transportation = 6   #from 1 to 11 (visual -5 to 5), maps to percentage
var electrification_by_sector_level_industry = 6
var electrification_by_sector_level_residential = 6
var electrification_by_sector_level_services = 6

var extra_year_text = ""
var budget = money * 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
