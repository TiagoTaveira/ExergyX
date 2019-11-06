extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GridContainer/Button").connect("pressed", self, "_on_Button_pressed")
	get_node("GridContainer2/Button").connect("pressed", self, "on_History_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Minus").connect("pressed", self, "on_Transport_Minus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Plus").connect("pressed", self, "on_Transport_Plus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Minus").connect("pressed", self, "on_Industry_Minus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Plus").connect("pressed", self, "on_Industry_Plus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Minus").connect("pressed", self, "on_Residential_Minus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Plus").connect("pressed", self, "on_Residential_Plus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Minus").connect("pressed", self, "on_Services_Minus_Button_pressed")
	get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Plus").connect("pressed", self, "on_Services_Plus_Button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Button presses
func on_Transport_Minus_Button_pressed():
	if(PlayerVariables.economy_type_level_transportation > 1):
		PlayerVariables.economy_type_level_transportation = PlayerVariables.economy_type_level_transportation - 1
		update_level_images()
		
func on_Transport_Plus_Button_pressed():
	if(PlayerVariables.economy_type_level_transportation < 11):
		PlayerVariables.economy_type_level_transportation = PlayerVariables.economy_type_level_transportation + 1
		update_level_images()
		
func on_Industry_Minus_Button_pressed():
	if(PlayerVariables.economy_type_level_industry > 1):
		PlayerVariables.economy_type_level_industry = PlayerVariables.economy_type_level_industry - 1
		update_level_images()
		
func on_Industry_Plus_Button_pressed():
	if(PlayerVariables.economy_type_level_industry < 11):
		PlayerVariables.economy_type_level_industry = PlayerVariables.economy_type_level_industry + 1
		update_level_images()
		
func on_Residential_Minus_Button_pressed():
	if(PlayerVariables.economy_type_level_residential > 1):
		PlayerVariables.economy_type_level_residential = PlayerVariables.economy_type_level_residential - 1
		update_level_images()
		
func on_Residential_Plus_Button_pressed():
	if(PlayerVariables.economy_type_level_residential < 11):
		PlayerVariables.economy_type_level_residential = PlayerVariables.economy_type_level_residential + 1
		update_level_images()
		
func on_Services_Minus_Button_pressed():
	if(PlayerVariables.economy_type_level_services > 1):
		PlayerVariables.economy_type_level_services = PlayerVariables.economy_type_level_services - 1
		update_level_images()
		
func on_Services_Plus_Button_pressed():
	if(PlayerVariables.economy_type_level_services < 11):
		PlayerVariables.economy_type_level_services = PlayerVariables.economy_type_level_services + 1
		update_level_images()


func on_History_Button_pressed():
	get_node("GrafHistorico").popup()


func _on_Button_pressed(): #Submit Decisions Button
	#get_node("AcceptDialog").popup_centered_ratio(0.20)
	calculate_percentages()
	process_next_year()
	get_node("AnoAtual").text = str(PlayerVariables.current_year)
	get_node("EstadoAtual/HistText").text = "PIB: 197.5 mil milhões de euros\n\nPIB p/ Energias Renováveis: " + str(PlayerVariables.investment_renewables_percentage) + "%\n\nTaxa de desemprego: 6.4%\n\nCrescimento Económico: 1%\n\nEmissões: 70 MT\n\nFelicidade dos cidadãos: 100\n\nShares (Transportes): " + str(PlayerVariables.economy_type_percentage_transportation) + "%\n\nShares (Indústria): " + str(PlayerVariables.economy_type_percentage_industry) + "%\n\nShares (Residencial): " + str(PlayerVariables.economy_type_percentage_residential) + "%\n\nShares (Serviços): " + str(PlayerVariables.economy_type_percentage_services) + "%"
	
	#####EXPERIMENTAL#####
	get_node("GrafHistorico/Control/TestLine2D").add_point(Vector2(PlayerVariables.current_year-2000, PlayerVariables.final_year_utility))
	######################
	
	if PlayerVariables.current_year < PlayerVariables.final_year:
		get_node("GridContainer/AnoAtual2").text = str(PlayerVariables.current_year + 1) + " - Decisões"
		get_node("GridContainer2/RichTextLabel").text = str(PlayerVariables.final_year) + " - Previsões (Objetivos)"
		get_node("GridContainer2/RichTextLabel2").bbcode_text = "Felicidade: " + str(PlayerVariables.final_year_utility) + "\n\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n\n" + "Crescimento Económico: [color=green]1%[/color] (1%)"  #exemplo de texto
		##Actual bbcode text setting (with conditions)
		get_node("GridContainer2/RichTextLabel2").bbcode_text = "Felicidade: " + ("[color=red]" if PlayerVariables.final_year_utility < PlayerVariables.utility_goals else "[color=green]") + str(PlayerVariables.final_year_utility) + "[/color] (" + str(PlayerVariables.utility_goals) + ")\n\n"    +   "Emissões CO2: " + ("[color=red]" if PlayerVariables.final_year_emissions > PlayerVariables.emission_goals else "[color=green]") + str(PlayerVariables.final_year_emissions) + " MT[/color] (" + str(PlayerVariables.emission_goals) + " MT)\n\n"    +    "Crescimento Económico: " + ("[color=red]" if PlayerVariables.final_year_economic_growth < PlayerVariables.economic_growth_goals else "[color=green]") + str(PlayerVariables.final_year_economic_growth) + "%[/color] (" + str(PlayerVariables.economic_growth_goals) + "%)"
		get_node("GridContainer2/Panel/PreviousYear").text = str(PlayerVariables.current_year  - 1)
		get_node("GridContainer2/Panel/CurrentYear").text = str(PlayerVariables.current_year)
		get_node("GridContainer2/Panel/NextYear").text = str(PlayerVariables.current_year + 1)
	else:
		get_node("GridContainer/Button").disabled = true
		var won = (PlayerVariables.final_year_utility >= PlayerVariables.utility_goals) && (PlayerVariables.final_year_emissions <= PlayerVariables.emission_goals)
		if won:
			get_node("PopupPanel/Control/WonLostText").text = "VENCEU!"
			PlayerVariables.extra_year_text = " - Venceu!"
			get_node("AnoAtual").text = str(PlayerVariables.current_year) + PlayerVariables.extra_year_text
		else:
			var red_style = StyleBoxFlat.new()
			red_style.set_bg_color(Color("#800000"))
			red_style.corner_radius_bottom_left = 20
			red_style.corner_radius_bottom_right = 20
			red_style.corner_radius_top_left = 20
			red_style.corner_radius_top_right = 20
			get_node("PopupPanel").set('custom_styles/panel', red_style)
			get_node("PopupPanel/Control/WonLostText").text = "PERDEU!"
			PlayerVariables.extra_year_text = " - Perdeu!"
			get_node("AnoAtual").text = str(PlayerVariables.current_year) + PlayerVariables.extra_year_text
		get_node("GridContainer2/RichTextLabel").text = str(PlayerVariables.final_year) + " - Resultados (Objetivos)"
		get_node("PopupPanel/Control/Results").text = "Felicidade dos Cidadãos: " + str(PlayerVariables.final_year_utility) + "\n" + "Objetivo: " + str(PlayerVariables.utility_goals) + "\n\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n" + "Objetivo: " + str(PlayerVariables.emission_goals) + " MT"+ "\n\n" + "Crescimento Económico: " + str(PlayerVariables.final_year_economic_growth) + "%" + "\n" + "Objetivo: " + str(PlayerVariables.economic_growth_goals) + "%"
		get_node("PopupPanel").popup_centered()
			
			
func calculate_percentages():
	##Economy Types
	var total_points = PlayerVariables.economy_type_level_transportation + PlayerVariables.economy_type_level_industry + PlayerVariables.economy_type_level_residential + PlayerVariables.economy_type_level_services
	PlayerVariables.economy_type_percentage_transportation = stepify((PlayerVariables.economy_type_level_transportation / float(total_points)) * 100, 0.1)
	PlayerVariables.economy_type_percentage_industry = stepify((PlayerVariables.economy_type_level_industry / float(total_points)) * 100, 0.1)
	PlayerVariables.economy_type_percentage_residential = stepify((PlayerVariables.economy_type_level_residential / float(total_points)) * 100, 0.1)
	PlayerVariables.economy_type_percentage_services = stepify((PlayerVariables.economy_type_level_services / float(total_points)) * 100, 0.1)
	##Electrification
	
	
func process_next_year():
	
	PlayerVariables.yearly_decisions.push_back(PlayerVariables.YearlyDecision.new(PlayerVariables.current_year, PlayerVariables.investment_renewables_percentage, PlayerVariables.utility, PlayerVariables.co2_emissions))
	get_node("Historico/HistText").text = get_node("Historico/HistText").text + str(PlayerVariables.current_year) + "\n" + "% PIB En. Ren.: " + str(PlayerVariables.investment_renewables_percentage) + "%" + "\n" + "Felicidade: " + str(PlayerVariables.final_year_utility) + "\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n\n"
	#above should be current utility+emissions, not final, but leaving like this for demo purposes
	
	PlayerVariables.current_year = PlayerVariables.current_year + 1
	var last_year_investment = PlayerVariables.investment_renewables_percentage
	PlayerVariables.investment_renewables_percentage = get_node("GridContainer/ScrollContainer/VBoxContainer/Control/PIBRenovaveis").get_value()

	if last_year_investment != PlayerVariables.investment_renewables_percentage:
		#mock formula follows:
		PlayerVariables.final_year_utility = round(PlayerVariables.final_year_utility*(rand_range(0.9, 1.1) + 0.0005 * PlayerVariables.investment_renewables_percentage))
		PlayerVariables.final_year_emissions = round(PlayerVariables.final_year_emissions*(rand_range(0.9, 1.1) - 0.005 * PlayerVariables.investment_renewables_percentage))

func update_level_images():
	##Economy Types
	#Transports
	if(PlayerVariables.economy_type_level_transportation == 1):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://down5.png")
	if(PlayerVariables.economy_type_level_transportation == 2):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://down4.png")
	if(PlayerVariables.economy_type_level_transportation == 3):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://down3.png")
	if(PlayerVariables.economy_type_level_transportation == 4):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://down2.png")	
	if(PlayerVariables.economy_type_level_transportation == 5):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://down1.png")	
	if(PlayerVariables.economy_type_level_transportation == 6):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://middle0.png")	
	if(PlayerVariables.economy_type_level_transportation == 7):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://up1.png")	
	if(PlayerVariables.economy_type_level_transportation == 8):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://up2.png")	
	if(PlayerVariables.economy_type_level_transportation == 9):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://up3.png")	
	if(PlayerVariables.economy_type_level_transportation == 10):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://up4.png")	
	if(PlayerVariables.economy_type_level_transportation == 11):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control3/Level").texture = load("res://up5.png")	
	#Industry
	if(PlayerVariables.economy_type_level_industry == 1):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://down5.png")
	if(PlayerVariables.economy_type_level_industry == 2):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://down4.png")
	if(PlayerVariables.economy_type_level_industry == 3):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://down3.png")
	if(PlayerVariables.economy_type_level_industry == 4):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://down2.png")	
	if(PlayerVariables.economy_type_level_industry == 5):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://down1.png")	
	if(PlayerVariables.economy_type_level_industry == 6):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://middle0.png")	
	if(PlayerVariables.economy_type_level_industry == 7):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://up1.png")	
	if(PlayerVariables.economy_type_level_industry == 8):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://up2.png")	
	if(PlayerVariables.economy_type_level_industry == 9):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://up3.png")	
	if(PlayerVariables.economy_type_level_industry == 10):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://up4.png")	
	if(PlayerVariables.economy_type_level_industry == 11):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control4/Level").texture = load("res://up5.png")		
	#Residential
	if(PlayerVariables.economy_type_level_residential == 1):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://down5.png")
	if(PlayerVariables.economy_type_level_residential == 2):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://down4.png")
	if(PlayerVariables.economy_type_level_residential == 3):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://down3.png")
	if(PlayerVariables.economy_type_level_residential == 4):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://down2.png")	
	if(PlayerVariables.economy_type_level_residential == 5):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://down1.png")	
	if(PlayerVariables.economy_type_level_residential == 6):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://middle0.png")	
	if(PlayerVariables.economy_type_level_residential == 7):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://up1.png")	
	if(PlayerVariables.economy_type_level_residential == 8):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://up2.png")	
	if(PlayerVariables.economy_type_level_residential == 9):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://up3.png")	
	if(PlayerVariables.economy_type_level_residential == 10):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://up4.png")	
	if(PlayerVariables.economy_type_level_residential == 11):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control5/Level").texture = load("res://up5.png")		
	#Services
	if(PlayerVariables.economy_type_level_services == 1):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://down5.png")
	if(PlayerVariables.economy_type_level_services == 2):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://down4.png")
	if(PlayerVariables.economy_type_level_services == 3):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://down3.png")
	if(PlayerVariables.economy_type_level_services == 4):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://down2.png")	
	if(PlayerVariables.economy_type_level_services == 5):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://down1.png")	
	if(PlayerVariables.economy_type_level_services == 6):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://middle0.png")	
	if(PlayerVariables.economy_type_level_services == 7):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://up1.png")	
	if(PlayerVariables.economy_type_level_services == 8):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://up2.png")	
	if(PlayerVariables.economy_type_level_services == 9):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://up3.png")	
	if(PlayerVariables.economy_type_level_services == 10):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://up4.png")	
	if(PlayerVariables.economy_type_level_services == 11):
		get_node("GridContainer/ScrollContainer/VBoxContainer/Control6/Level").texture = load("res://up5.png")		
	
	
	
	
	
	##Electrification