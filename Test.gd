extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GridContainer/Button").connect("pressed", self, "_on_Button_pressed")
	get_node("EstadoAtual/Button").connect("pressed", self, "on_History_Button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_History_Button_pressed():
	get_node("GrafHistorico").popup()


func _on_Button_pressed():
	get_node("AcceptDialog").popup_centered_ratio(0.20)
	process_next_year()
	get_node("AnoAtual").text = "Ano Atual: " + str(PlayerVariables.current_year)
	
	if PlayerVariables.current_year < PlayerVariables.final_year:
		get_node("GridContainer/AnoAtual2").text = "Decisões para o ano de " + str(PlayerVariables.current_year + 1)
		get_node("GridContainer2/RichTextLabel").text = "Previsões para ano " + str(PlayerVariables.final_year)
		get_node("GridContainer2/RichTextLabel2").text = "Utilidade: " + str(PlayerVariables.final_year_utility) + "\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT"
	else:
		get_node("GridContainer/Button").disabled = true
		var won = (PlayerVariables.final_year_utility >= PlayerVariables.utility_goals) && (PlayerVariables.final_year_emissions <= PlayerVariables.emission_goals)
		if won:
			get_node("PopupPanel/Control/WonLostText").text = "VENCEU!"
		else:
			get_node("PopupPanel/Control/WonLostText").text = "PERDEU!"
		get_node("PopupPanel/Control/Results").text = "Utilidade: " + str(PlayerVariables.final_year_utility) + "\n" + "Objetivo: " + str(PlayerVariables.utility_goals) + "\n\n" + "Emisssões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n" + "Objetivo: " + str(PlayerVariables.emission_goals) + " MT"
		get_node("PopupPanel").popup_centered()
			
func process_next_year():
	
	PlayerVariables.yearly_decisions.push_back(PlayerVariables.YearlyDecision.new(PlayerVariables.current_year, PlayerVariables.investment_renewables_percentage, PlayerVariables.utility, PlayerVariables.co2_emissions))
	get_node("Historico/HistText").text = get_node("Historico/HistText").text + str(PlayerVariables.current_year) + "\n" + "% PIB En. Ren.: " + str(PlayerVariables.investment_renewables_percentage) + "%" + "\n" + "Utilidade: " + str(PlayerVariables.final_year_utility) + "\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n\n"
	#above should be current utility+emissions, not final, but leaving like this for demo purposes
	
	PlayerVariables.current_year = PlayerVariables.current_year + 1
	var last_year_investment = PlayerVariables.investment_renewables_percentage
	PlayerVariables.investment_renewables_percentage = get_node("GridContainer/PIBRenovaveis").get_value()

	if last_year_investment != PlayerVariables.investment_renewables_percentage:
		#mock formula follows:
		PlayerVariables.final_year_utility = round(PlayerVariables.final_year_utility*(rand_range(0.9, 1.1) + 0.0005 * PlayerVariables.investment_renewables_percentage))
		PlayerVariables.final_year_emissions = round(PlayerVariables.final_year_emissions*(rand_range(0.9, 1.1) - 0.005 * PlayerVariables.investment_renewables_percentage))
