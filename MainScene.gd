extends Panel

# Declare member variables here.
var FINAL_YEAR = 2050

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGamePopup.popup()
	randomize()
	initial_model_loading()
	#function that initializes text from variables () goes here
	update_text()
	#first_year_text()
	update_simulator_text()
	get_node("ContainerDecisoes/EnviarDecisoes").connect("pressed", self, "_on_Button_pressed")
	get_node("ContainerPrevisoes/HistoricoPrevisoes").connect("pressed", self, "on_History_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control/Minus").connect("pressed", self, "on_Investment_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control/Plus").connect("pressed", self, "on_Investment_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control3/Minus").connect("pressed", self, "on_Transport_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control3/Plus").connect("pressed", self, "on_Transport_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control4/Minus").connect("pressed", self, "on_Industry_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control4/Plus").connect("pressed", self, "on_Industry_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control5/Minus").connect("pressed", self, "on_Residential_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control5/Plus").connect("pressed", self, "on_Residential_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control6/Minus").connect("pressed", self, "on_Services_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control6/Plus").connect("pressed", self, "on_Services_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control8/Minus").connect("pressed", self, "on_Transport_Electrification_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control8/Plus").connect("pressed", self, "on_Transport_Electrification_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control9/Minus").connect("pressed", self, "on_Industry_Electrification_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control9/Plus").connect("pressed", self, "on_Industry_Electrification_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control10/Minus").connect("pressed", self, "on_Residential_Electrification_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control10/Plus").connect("pressed", self, "on_Residential_Electrification_Plus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control11/Minus").connect("pressed", self, "on_Services_Electrification_Minus_Button_pressed")
	get_node("ContainerDecisoes/ScrollContainer/Control11/Plus").connect("pressed", self, "on_Services_Electrification_Plus_Button_pressed")
	get_node("ConfirmationPopup/Control/ConfirmarDecisoes").connect("pressed", self, "on_Confirm_Button_pressed") 
	get_node("ConfirmationPopup/Control/CancelarDecisoes").connect("pressed", self, "on_Cancel_Button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Model handling
func initial_model_loading():
	PlayerVariables.starting_year = Model.ANO_INICIAL
	PlayerVariables.current_year = Model.ano_atual
	PlayerVariables.final_year = FINAL_YEAR
	PlayerVariables.money = Model.pib_do_ano[Model.ano_atual_indice]
	PlayerVariables.expenditure = Model.consumo_do_ano[Model.ano_atual_indice]
	PlayerVariables.utility = Model.utilidade_do_ano[Model.ano_atual_indice]
	PlayerVariables.co2_emissions = Model.emissoes_totais_do_ano[Model.ano_atual_indice]
	PlayerVariables.economic_growth = 1
	PlayerVariables.cost_per_gigawatt = Model.CUSTO_POR_GIGAWATT_INSTALADO
	PlayerVariables.efficiency = Model.eficiencia_agregada_do_ano[Model.ano_atual_indice]
	PlayerVariables.total_installed_power = Model.potencia_do_ano_solar[Model.ano_atual_indice] + Model.potencia_do_ano_biomassa[Model.ano_atual_indice] + Model.potencia_do_ano_vento[Model.ano_atual_indice] + Model.POTENCIA_ANUAL_HIDRO
	PlayerVariables.renewable_energy = Model.eletricidade_renovavel_do_ano[Model.ano_atual_indice]
	
	PlayerVariables.economy_type_percentage_transportation = Model.shares_exergia_final_transportes_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.economy_type_percentage_industry = Model.shares_exergia_final_industria_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.economy_type_percentage_residential = Model.shares_exergia_final_residencial_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.economy_type_percentage_services = Model.shares_exergia_final_servicos_do_ano[Model.ano_atual_indice] * 100.0
	
	PlayerVariables.electrification_by_sector_percentage_transportation = Model.shares_exergia_final_transportes_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_industry = Model.shares_exergia_final_industria_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_residential = Model.shares_exergia_final_residencial_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_services = Model.shares_exergia_final_servicos_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	
func send_game_decisions_to_model():
	Model.input_potencia_a_instalar = PlayerVariables.investment_renewables_percentage
	
	
	print("Sent " + str(PlayerVariables.investment_renewables_percentage) +
	 ". Model received " + str(Model.input_potencia_a_instalar))

	Model.input_percentagem_tipo_economia_transportes = PlayerVariables.economy_type_level_transportation - 6
	Model.input_percentagem_tipo_economia_industria = PlayerVariables.economy_type_level_industry - 6
	Model.input_percentagem_tipo_economia_residencial = PlayerVariables.economy_type_level_residential - 6
	Model.input_percentagem_tipo_economia_servicos = PlayerVariables.economy_type_level_services - 6

	Model.input_percentagem_eletrificacao_transportes = PlayerVariables.electrification_by_sector_level_transportation - 6
	Model.input_percentagem_eletrificacao_industria = PlayerVariables.electrification_by_sector_level_industry - 6
	Model.input_percentagem_eletrificacao_residencial = PlayerVariables.electrification_by_sector_level_residential - 6
	Model.input_percentagem_eletrificacao_servicos = PlayerVariables.electrification_by_sector_level_services - 6
	
func update_model():
	Model.mudar_de_ano()
	Model.calcular_distribuicao_por_fonte()
	Model.calcular_custo()
	Model.calcular_investimento()
	Model.calcular_capital()
	Model.calcular_labour()
	Model.calcular_tfp()
	Model.calcular_pib()
	Model.calcular_exergia_util()
	Model.calcular_exergia_final()
	Model.calcular_shares_de_exergia_final_por_setor()
	Model.calcular_eletrificacao_etc_de_setores()
	Model.calcular_shares_de_exergia_final_por_setor_por_carrier()
	Model.calcular_valores_absolutos_de_exergia_final_por_setor()
	Model.calcular_valores_absolutos_de_exergia_final_por_setor_por_carrier()
	Model.calcular_eficiencia_por_setor()
	Model.calcular_eficiencia_agregada()
	Model.calcular_valores_absolutos_de_exergia_final_por_carrier()
	Model.calcular_emissoes_CO2_carvao_petroleo_gas_natural()
	Model.calcular_eletricidade_de_fontes_renovaveis()
	Model.calcular_eletricidade_nao_renovavel()
	Model.calcular_emissoes_nao_renovaveis()
	Model.calcular_emissoes_totais()
	Model.calcular_consumo()
	Model.calcular_utilidade()

func update_game_after_model(): #TODO: change final year names to current year
	PlayerVariables.current_year = Model.ano_atual
	PlayerVariables.money = Model.pib_do_ano[Model.ano_atual_indice]
	PlayerVariables.expenditure = Model.consumo_do_ano[Model.ano_atual_indice]
	PlayerVariables.utility = Model.utilidade_do_ano[Model.ano_atual_indice]
	PlayerVariables.co2_emissions = Model.emissoes_totais_do_ano[Model.ano_atual_indice]
	PlayerVariables.economic_growth = 1
	PlayerVariables.cost_per_gigawatt = Model.CUSTO_POR_GIGAWATT_INSTALADO
	PlayerVariables.efficiency = Model.eficiencia_agregada_do_ano[Model.ano_atual_indice]
	PlayerVariables.total_installed_power = Model.potencia_do_ano_solar[Model.ano_atual_indice] + Model.potencia_do_ano_biomassa[Model.ano_atual_indice] + Model.potencia_do_ano_vento[Model.ano_atual_indice] + Model.POTENCIA_ANUAL_HIDRO
	PlayerVariables.renewable_energy = Model.eletricidade_renovavel_do_ano[Model.ano_atual_indice]
	
	PlayerVariables.economy_type_percentage_transportation = Model.shares_exergia_final_transportes_do_ano[Model.ano_atual_indice] * 100.0  #TODO: Apresentar com 1 casa decimal
	PlayerVariables.economy_type_percentage_industry = Model.shares_exergia_final_industria_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.economy_type_percentage_residential = Model.shares_exergia_final_residencial_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.economy_type_percentage_services = Model.shares_exergia_final_servicos_do_ano[Model.ano_atual_indice] * 100.0

	PlayerVariables.electrification_by_sector_percentage_transportation = Model.shares_exergia_final_transportes_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_industry = Model.shares_exergia_final_industria_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_residential = Model.shares_exergia_final_residencial_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	PlayerVariables.electrification_by_sector_percentage_services = Model.shares_exergia_final_servicos_eletricidade_do_ano[Model.ano_atual_indice] * 100.0
	
func update_predictions():
	PredictionsModel.carregar_modelo_original()
	var current_year = PlayerVariables.current_year
	var final_year = PlayerVariables.final_year
	
	# loop for y = current_year + 1 (next year) to final_year + 1 (not a typo, gdscript for doesn't include outter boundary)
	for y in range(current_year + 1, final_year + 2):
		PredictionsModel.ano_atual = y
		PredictionsModel.ano_atual_indice = PredictionsModel.indice_do_ano(y)
		PredictionsModel.calcular_distribuicao_por_fonte()
		PredictionsModel.calcular_custo()
		PredictionsModel.calcular_investimento()
		PredictionsModel.calcular_capital()
		PredictionsModel.calcular_labour()
		PredictionsModel.calcular_tfp()
		PredictionsModel.calcular_pib()
		PredictionsModel.calcular_exergia_util()
		PredictionsModel.calcular_exergia_final()
		PredictionsModel.calcular_shares_de_exergia_final_por_setor()
		PredictionsModel.calcular_eletrificacao_etc_de_setores()
		PredictionsModel.calcular_shares_de_exergia_final_por_setor_por_carrier()
		PredictionsModel.calcular_valores_absolutos_de_exergia_final_por_setor()
		PredictionsModel.calcular_valores_absolutos_de_exergia_final_por_setor_por_carrier()
		PredictionsModel.calcular_eficiencia_por_setor()
		PredictionsModel.calcular_eficiencia_agregada()
		PredictionsModel.calcular_valores_absolutos_de_exergia_final_por_carrier()
		PredictionsModel.calcular_emissoes_CO2_carvao_petroleo_gas_natural()
		PredictionsModel.calcular_eletricidade_de_fontes_renovaveis()
		PredictionsModel.calcular_eletricidade_nao_renovavel()
		PredictionsModel.calcular_emissoes_nao_renovaveis()
		PredictionsModel.calcular_emissoes_totais()
		PredictionsModel.calcular_consumo()
		PredictionsModel.calcular_utilidade()
	
	PlayerVariables.final_year_utility = PredictionsModel.utilidade_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_emissions = PredictionsModel.emissoes_totais_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_efficiency = PredictionsModel.eficiencia_agregada_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_expenditure = PredictionsModel.consumo_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_money = PredictionsModel.pib_do_ano[PredictionsModel.indice_do_ano(final_year)]
	
# Handle game text
func update_text():
	get_node("EstadoAtual/AnoAtual/Ano").text = str(PlayerVariables.current_year)
	get_node("EstadoAtual/TextoAnoAtual").text = "Ano Atual"

	get_node("EstadoAtual/TextoDadosEnergeticos").text = "Potência Total Instalada (Fração Renovável): " + str(stepify(PlayerVariables.total_installed_power, 0.1)) + " GW" + "\n\nFração de Eletricidade Renovável: " + str(stepify(PlayerVariables.renewable_energy, 0.1)) + " GWh (" + str(1) + "% do total)" + "\n\nEmissões: " + str(stepify(PlayerVariables.co2_emissions, 0.1)) + " MT" + "\n\nEficiência Agregada do País: " + str(stepify(PlayerVariables.efficiency * 100, 0.1)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesTransportes").text = str(stepify(PlayerVariables.economy_type_percentage_transportation, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesIndustria").text = str(stepify(PlayerVariables.economy_type_percentage_industry, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesResidencial").text = str(stepify(PlayerVariables.economy_type_percentage_residential, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesServicos").text = str(stepify(PlayerVariables.economy_type_percentage_services, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoTransportes").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_transportation, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoIndustria").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_industry, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoResidencial").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_residential, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoServicos").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_services, 0.01)) + "%"
	get_node("EstadoAtual/TextoDadosSocioeconomicos").text = "PIB: " + str(stepify(PlayerVariables.money, 1)) + "€" + "\n\nConsumo: " + str(stepify(PlayerVariables.expenditure, 1)) + "€" + "\n\nFelicidade dos Cidadãos: " + str(stepify(PlayerVariables.utility, 1))
	get_node("ContainerPrevisoes/TextoOutrosDados").text = "Eficiência Agregada do País: " + str(stepify(PlayerVariables.final_year_efficiency * 100, 0.1)) + "\n\nPIB: " + str(stepify(PlayerVariables.final_year_money, 1)) +"€" + "\n\nConsumo: " + str(stepify(PlayerVariables.final_year_expenditure, 1)) + "€"
	#get_node("ContainerDecisoes/ProximoAno").text = "Decisões para " + str(PlayerVariables.current_year + 1)
	get_node("ContainerDecisoes/ProximoAno").text = "Decisões"
	get_node("ContainerPrevisoes/RichTextLabel").text = str(PlayerVariables.final_year) + " - Previsões"
	get_node("ContainerPrevisoes/RichTextLabel2").bbcode_text = "Felicidade dos Cidadãos: " + str(stepify(PlayerVariables.final_year_utility, 1)) + "\n\n" + "Emissões CO2: " + str(stepify(PlayerVariables.final_year_emissions, 0.01)) + " MT" + "\n\n" + "Crescimento Económico: [color=green]1%[/color] (1%)"  #exemplo de texto
	##Actual bbcode text setting (with conditions)
	get_node("ContainerPrevisoes/RichTextLabel2").bbcode_text = "Felicidade dos Cidadãos: " + ("[color=red]" if PlayerVariables.final_year_utility < PlayerVariables.utility_goals else "[color=green]") + str(stepify(PlayerVariables.final_year_utility, 1)) + "[/color] (" + str(PlayerVariables.utility_goals) + ")\n\n"    +   "Emissões CO2: " + ("[color=red]" if PlayerVariables.final_year_emissions > PlayerVariables.emission_goals else "[color=green]") + str(stepify(PlayerVariables.final_year_emissions, 0.01)) + " MT[/color] (" + str(stepify(PlayerVariables.emission_goals, 0.1)) + " MT)"
	get_node("ContainerPrevisoes/Panel/PreviousYear").text = str(PlayerVariables.current_year  - 1)
	get_node("ContainerPrevisoes/Panel/CurrentYear").text = str(PlayerVariables.current_year)
	get_node("ContainerPrevisoes/Panel/NextYear").text = str(PlayerVariables.current_year + 1)

	
# Button presses
func _on_StartGame_pressed():
	$NewGamePopup.hide()


func on_Investment_Minus_Button_pressed():
	if(PlayerVariables.investment_renewables_percentage > 0.00):
		PlayerVariables.investment_renewables_percentage -= 0.10
		if(PlayerVariables.investment_renewables_percentage < 0.01):
			PlayerVariables.investment_renewables_percentage = 0.00
		$ContainerDecisoes/ScrollContainer/Control/ValorPotencia.bbcode_text = "[right]" + str(PlayerVariables.investment_renewables_percentage) + "[/right]"
		PlayerVariables.investment_cost = PlayerVariables.investment_renewables_percentage * PlayerVariables.cost_per_gigawatt
		$ContainerDecisoes/ScrollContainer/Control/ValorCusto.bbcode_text = "[right]" + str(PlayerVariables.investment_cost) + "[/right]"

func on_Investment_Plus_Button_pressed():
	if(PlayerVariables.investment_renewables_percentage < 10.00):
		PlayerVariables.investment_renewables_percentage += 0.10
		if(PlayerVariables.investment_renewables_percentage > 9.99):
			PlayerVariables.investment_renewables_percentage = 10.00
		$ContainerDecisoes/ScrollContainer/Control/ValorPotencia.bbcode_text = "[right]" + str(PlayerVariables.investment_renewables_percentage) + "[/right]"
		PlayerVariables.investment_cost = PlayerVariables.investment_renewables_percentage * PlayerVariables.cost_per_gigawatt
		$ContainerDecisoes/ScrollContainer/Control/ValorCusto.bbcode_text = "[right]" + str(PlayerVariables.investment_cost) + "[/right]"

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
		
		
func on_Transport_Electrification_Minus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_transportation > 1):
		PlayerVariables.electrification_by_sector_level_transportation = PlayerVariables.electrification_by_sector_level_transportation - 1
		update_level_images()
		
func on_Transport_Electrification_Plus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_transportation < 11):
		PlayerVariables.electrification_by_sector_level_transportation = PlayerVariables.electrification_by_sector_level_transportation + 1
		update_level_images()
		
func on_Industry_Electrification_Minus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_industry > 1):
		PlayerVariables.electrification_by_sector_level_industry = PlayerVariables.electrification_by_sector_level_industry - 1
		update_level_images()
		
func on_Industry_Electrification_Plus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_industry < 11):
		PlayerVariables.electrification_by_sector_level_industry = PlayerVariables.electrification_by_sector_level_industry + 1
		update_level_images()
		
func on_Residential_Electrification_Minus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_residential > 1):
		PlayerVariables.electrification_by_sector_level_residential = PlayerVariables.electrification_by_sector_level_residential - 1
		update_level_images()
		
func on_Residential_Electrification_Plus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_residential < 11):
		PlayerVariables.electrification_by_sector_level_residential = PlayerVariables.electrification_by_sector_level_residential + 1
		update_level_images()
		
func on_Services_Electrification_Minus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_services > 1):
		PlayerVariables.electrification_by_sector_level_services = PlayerVariables.electrification_by_sector_level_services - 1
		update_level_images()
		
func on_Services_Electrification_Plus_Button_pressed():
	if(PlayerVariables.electrification_by_sector_level_services < 11):
		PlayerVariables.electrification_by_sector_level_services = PlayerVariables.electrification_by_sector_level_services + 1
		update_level_images()


func on_History_Button_pressed():
	get_node("GrafHistorico").popup()


func _on_FecharHistorico_pressed():
	get_node("GrafHistorico").hide()
	
func update_graph():
	
	var years_passed = PlayerVariables.current_year - PlayerVariables.starting_year
	var point_x_distance = 750 / years_passed
	var max_y = 700
	var values_text_offset = 739 - 15
	
	get_node("GrafHistorico/Control/StartingYear").bbcode_text = str(PlayerVariables.starting_year + 1)
	get_node("GrafHistorico/Control/CurrentYear").bbcode_text = str(PlayerVariables.current_year)
	get_node("GrafHistorico/Control/FinalYear").bbcode_text = str(PlayerVariables.final_year)
	
	$GrafHistorico/Control/EmissionsLine.clear_points()
	
	#Get points y-values
	var emissions_values = []
	for e in range(Model.emissoes_totais_do_ano.size()):
		if e != 0:
			emissions_values.push_back(Model.emissoes_totais_do_ano[e])
	
	#Normalize values for chart y-boundaries
	var emissions_max = emissions_values.max()
	var emissions_y_values = []
	for e in range(emissions_values.size()):
		emissions_y_values.push_back((emissions_values[e] * max_y) / emissions_max)
		
	#test
	#for v in range(emissions_values.size()):
	#	print("Value " + str(v) + ": " + str(emissions_values[v]))
	
	#Test values (run up to 2 years)
	#emissions_y_values = [100, 0, 650]
	for v in range(emissions_y_values.size()):
		pass
		#print("Value " + str(v) + ": " + str(emissions_y_values[v]))
	
	#Draw lines and Update values' text
	for y in range(years_passed + 1):
		$GrafHistorico/Control/EmissionsLine.add_point((Vector2(point_x_distance * y, emissions_y_values[y] * -1)))
		if y == 0:
			$GrafHistorico/Control/EmissionsValueStart.rect_position = Vector2($GrafHistorico/Control/EmissionsValueStart.rect_position.x, values_text_offset - emissions_y_values[y])
			$GrafHistorico/Control/EmissionsValueStart.bbcode_text = "[right]" + str(stepify(Model.emissoes_totais_do_ano[y + 1], 0.1))+ " MT[/right]"
		if y == years_passed:
			$GrafHistorico/Control/EmissionsValueCurrent.rect_position = Vector2($GrafHistorico/Control/EmissionsValueCurrent.rect_position.x, values_text_offset - emissions_y_values[y])
			$GrafHistorico/Control/EmissionsValueCurrent.bbcode_text = str(stepify(Model.emissoes_totais_do_ano[y], 0.1))+ " MT"
	
	#####EXPERIMENTAL#####
	#get_node("GrafHistorico/Control/TestLine2D").add_point(Vector2(400, 400))
	#get_node("GrafHistorico/Control/TestLine2D").add_point(Vector2(500, 500))
	######################


func _on_ShowEmissions_toggled(button_pressed):
	if $GrafHistorico/Control/ShowEmissions.is_pressed():
		$GrafHistorico/Control/EmissionsLine.visible = true
		$GrafHistorico/Control/EmissionsValueStart.visible = true
		$GrafHistorico/Control/EmissionsValueCurrent.visible = true
	else:
		$GrafHistorico/Control/EmissionsLine.visible = false
		$GrafHistorico/Control/EmissionsValueStart.visible = false
		$GrafHistorico/Control/EmissionsValueCurrent.visible = false


func _on_Button_pressed(): #Submit Decisions Button
	#get_node("AcceptDialog").popup_centered_ratio(0.20)
	disable_all_buttons()
	update_confirmation_popup()
	get_node("ConfirmationPopup").popup()
	#var packed_scene = PackedScene.new()
	#packed_scene.pack(get_tree().get_current_scene())
	#ResourceSaver.save("res://my_scene.tscn", packed_scene)
	#get_tree().change_scene("res://DecisionsScene.tscn")
	
	
#move this function under the next one after done, and delete this comment
func next_year_animation():
	get_node("EstadoAtual/AnoAtual/Ano/NextYearAnimationPlayer").play("NextYear")
	pass

func on_Confirm_Button_pressed():
	get_node("ConfirmationPopup").hide()
	#animation goes here
	next_year_animation()
	yield(get_tree().create_timer(1.0), "timeout") #wait() in GDscript
	enable_all_buttons()
	process_next_year()
	update_graph()
	update_text()
	
	
	
	if PlayerVariables.current_year < PlayerVariables.final_year:
		pass
	else:
		get_node("ContainerDecisoes/EnviarDecisoes").disabled = true
		var won = (PlayerVariables.final_year_utility >= PlayerVariables.utility_goals) && (PlayerVariables.final_year_emissions <= PlayerVariables.emission_goals)
		if won:
			get_node("PopupPanel/Control/WonLostText").text = "VENCEU!"
		else:
			var red_style = StyleBoxFlat.new()
			red_style.set_bg_color(Color("#800000"))
			red_style.corner_radius_bottom_left = 20
			red_style.corner_radius_bottom_right = 20
			red_style.corner_radius_top_left = 20
			red_style.corner_radius_top_right = 20
			get_node("PopupPanel").set('custom_styles/panel', red_style)
			get_node("PopupPanel/Control/WonLostText").text = "PERDEU!"
		get_node("ContainerPrevisoes/RichTextLabel").text = str(PlayerVariables.final_year) + " - Resultados (Objetivos)"
		get_node("PopupPanel/Control/Results").text = "Felicidade dos Cidadãos: " + str(PlayerVariables.final_year_utility) + "\n" + "Objetivo: " + str(PlayerVariables.utility_goals) + "\n\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " MT" + "\n" + "Objetivo: " + str(PlayerVariables.emission_goals) + " MT"+ "\n\n" + "Crescimento Económico: " + str(PlayerVariables.final_year_economic_growth) + "%" + "\n" + "Objetivo: " + str(PlayerVariables.economic_growth_goals) + "%"
		get_node("PopupPanel").popup_centered()
	
func on_Cancel_Button_pressed():
	get_node("ConfirmationPopup").hide()
	enable_all_buttons()


func process_next_year():

	#Send decisions to model
	send_game_decisions_to_model()
	
	#Update model
	update_model()
	
	#Update game
	update_game_after_model()
	
	#Update predictions by using the mock Predictions Model
	update_predictions()
		
	#Enable History button after at least one turn
	if PlayerVariables.current_year != PlayerVariables.starting_year:
		$ContainerPrevisoes/HistoricoPrevisoes.disabled = false


func disable_all_buttons():
	get_node("ContainerDecisoes/ScrollContainer/Control/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control3/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control3/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control4/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control4/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control5/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control5/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control6/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control6/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control8/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control8/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control9/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control9/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control10/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control10/Plus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control11/Minus").disabled = true
	get_node("ContainerDecisoes/ScrollContainer/Control11/Plus").disabled = true
	get_node("ContainerDecisoes/EnviarDecisoes").disabled = true
	get_node("ContainerPrevisoes/HistoricoPrevisoes").disabled = true
	
	
func enable_all_buttons():
	get_node("ContainerDecisoes/ScrollContainer/Control/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control3/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control3/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control4/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control4/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control5/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control5/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control6/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control6/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control8/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control8/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control9/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control9/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control10/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control10/Plus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control11/Minus").disabled = false
	get_node("ContainerDecisoes/ScrollContainer/Control11/Plus").disabled = false
	get_node("ContainerDecisoes/EnviarDecisoes").disabled = false
	if PlayerVariables.current_year != PlayerVariables.starting_year:
		get_node("ContainerPrevisoes/HistoricoPrevisoes").disabled = false
	
	
func update_confirmation_popup():
	get_node("ConfirmationPopup/Control/ConfirmarDecisoes").text = "Confirmar e ir para " + str(PlayerVariables.current_year + 1)
	get_node("ConfirmationPopup/Control/ResumoPotenciaInstalada").text = "Instalação: " + str(PlayerVariables.investment_renewables_percentage) + " GW \nCusto: " + str(PlayerVariables.investment_cost) + " € (" + str(stepify(((PlayerVariables.investment_cost / PlayerVariables.money)) * 100, 0.1)) + "% do PIB)"

	

func update_level_images():
	##Economy Types
	#Transports
	if(PlayerVariables.economy_type_level_transportation == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://down5.png")
	if(PlayerVariables.economy_type_level_transportation == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://down4.png")
	if(PlayerVariables.economy_type_level_transportation == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://down3.png")
	if(PlayerVariables.economy_type_level_transportation == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://down2.png")
	if(PlayerVariables.economy_type_level_transportation == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://down1.png")
	if(PlayerVariables.economy_type_level_transportation == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.economy_type_level_transportation == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://up1.png")
	if(PlayerVariables.economy_type_level_transportation == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://up2.png")
	if(PlayerVariables.economy_type_level_transportation == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://up3.png")
	if(PlayerVariables.economy_type_level_transportation == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://up4.png")
	if(PlayerVariables.economy_type_level_transportation == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control3/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Transportes/Level").texture  = load("res://up5.png")
	#Industry
	if(PlayerVariables.economy_type_level_industry == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://down5.png")
	if(PlayerVariables.economy_type_level_industry == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://down4.png")
	if(PlayerVariables.economy_type_level_industry == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://down3.png")
	if(PlayerVariables.economy_type_level_industry == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://down2.png")
	if(PlayerVariables.economy_type_level_industry == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://down1.png")
	if(PlayerVariables.economy_type_level_industry == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.economy_type_level_industry == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://up1.png")
	if(PlayerVariables.economy_type_level_industry == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://up2.png")
	if(PlayerVariables.economy_type_level_industry == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://up3.png")
	if(PlayerVariables.economy_type_level_industry == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://up4.png")
	if(PlayerVariables.economy_type_level_industry == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control4/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Industria/Level").texture  = load("res://up5.png")
	#Residential
	if(PlayerVariables.economy_type_level_residential == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://down5.png")
	if(PlayerVariables.economy_type_level_residential == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://down4.png")
	if(PlayerVariables.economy_type_level_residential == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://down3.png")
	if(PlayerVariables.economy_type_level_residential == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://down2.png")
	if(PlayerVariables.economy_type_level_residential == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://down1.png")
	if(PlayerVariables.economy_type_level_residential == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.economy_type_level_residential == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://up1.png")
	if(PlayerVariables.economy_type_level_residential == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://up2.png")
	if(PlayerVariables.economy_type_level_residential == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://up3.png")
	if(PlayerVariables.economy_type_level_residential == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://up4.png")
	if(PlayerVariables.economy_type_level_residential == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control5/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Residencial/Level").texture  = load("res://up5.png")
	#Services
	if(PlayerVariables.economy_type_level_services == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://down5.png")
	if(PlayerVariables.economy_type_level_services == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://down4.png")
	if(PlayerVariables.economy_type_level_services == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://down3.png")
	if(PlayerVariables.economy_type_level_services == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://down3.png")
	if(PlayerVariables.economy_type_level_services == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://down1.png")
	if(PlayerVariables.economy_type_level_services == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.economy_type_level_services == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://up1.png")
	if(PlayerVariables.economy_type_level_services == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://up2.png")
	if(PlayerVariables.economy_type_level_services == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://up3.png")
	if(PlayerVariables.economy_type_level_services == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://up4.png")
	if(PlayerVariables.economy_type_level_services == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control6/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Servicos/Level").texture  = load("res://up5.png")
	
	
	
	
	
	##Electrification
	#Transports
	if(PlayerVariables.electrification_by_sector_level_transportation == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://down5.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://down4.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://down3.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://down2.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://down1.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://up1.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://up2.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://up3.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://up4.png")
	if(PlayerVariables.electrification_by_sector_level_transportation == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control8/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Transportes2/Level").texture  = load("res://up5.png")
	#Industry
	if(PlayerVariables.electrification_by_sector_level_industry == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://down5.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://down4.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://down3.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://down2.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://down1.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://up1.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://up2.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://up3.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://up4.png")
	if(PlayerVariables.electrification_by_sector_level_industry == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control9/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Industria2/Level").texture  = load("res://up5.png")
	#Residential
	if(PlayerVariables.electrification_by_sector_level_residential == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://down5.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://down4.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://down3.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://down2.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://down1.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://up1.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://up2.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://up3.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://up4.png")
	if(PlayerVariables.electrification_by_sector_level_residential == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control10/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Residencial2/Level").texture  = load("res://up5.png")
	#Services
	if(PlayerVariables.electrification_by_sector_level_services == 1):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://down5.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://down5.png")
	if(PlayerVariables.electrification_by_sector_level_services == 2):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://down4.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://down4.png")
	if(PlayerVariables.electrification_by_sector_level_services == 3):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://down3.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://down3.png")
	if(PlayerVariables.electrification_by_sector_level_services == 4):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://down2.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://down3.png")
	if(PlayerVariables.electrification_by_sector_level_services == 5):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://down1.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://down1.png")
	if(PlayerVariables.electrification_by_sector_level_services == 6):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://middle0.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://middle0.png")
	if(PlayerVariables.electrification_by_sector_level_services == 7):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://up1.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://up1.png")
	if(PlayerVariables.electrification_by_sector_level_services == 8):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://up2.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://up2.png")
	if(PlayerVariables.electrification_by_sector_level_services == 9):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://up3.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://up3.png")
	if(PlayerVariables.electrification_by_sector_level_services == 10):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://up4.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://up4.png")
	if(PlayerVariables.electrification_by_sector_level_services == 11):
		get_node("ContainerDecisoes/ScrollContainer/Control11/Level").texture = load("res://up5.png")
		get_node("ConfirmationPopup/Control/Servicos2/Level").texture  = load("res://up5.png")
	








## MODEL SIMULATOR POPUP
func _on_Model_Button_pressed(): 
	get_node("ModelPopup").popup()
	
func _on_Fechar_pressed():
	update_game_after_model()
	update_text()
	get_node("ModelPopup").hide()


func _on_Simular_pressed():
	Model.input_potencia_a_instalar = get_node("ModelPopup/Control/Potencia").value
	Model.input_percentagem_tipo_economia_transportes = get_node("ModelPopup/Control/TipoEconomiaTransportes").value
	Model.input_percentagem_tipo_economia_industria = get_node("ModelPopup/Control/TipoEconomiaIndustria").value
	Model.input_percentagem_tipo_economia_residencial = get_node("ModelPopup/Control/TipoEconomiaResidencial").value
	Model.input_percentagem_tipo_economia_servicos = get_node("ModelPopup/Control/TipoEconomiaServicos").value	
	Model.input_percentagem_eletrificacao_transportes = get_node("ModelPopup/Control/EletrificacaoTransportes").value
	Model.input_percentagem_eletrificacao_industria = get_node("ModelPopup/Control/EletrificacaoIndustria").value
	Model.input_percentagem_eletrificacao_residencial = get_node("ModelPopup/Control/EletrificacaoResidencial").value
	Model.input_percentagem_eletrificacao_servicos = get_node("ModelPopup/Control/EletrificacaoServicos").value
	
	Model.mudar_de_ano()
	Model.calcular_distribuicao_por_fonte()
	Model.calcular_custo()
	Model.calcular_investimento()
	Model.calcular_capital()
	Model.calcular_labour()
	Model.calcular_tfp()
	Model.calcular_pib()
	Model.calcular_exergia_util()
	Model.calcular_exergia_final()
	Model.calcular_shares_de_exergia_final_por_setor()
	Model.calcular_eletrificacao_etc_de_setores()
	Model.calcular_shares_de_exergia_final_por_setor_por_carrier()
	Model.calcular_valores_absolutos_de_exergia_final_por_setor()
	Model.calcular_valores_absolutos_de_exergia_final_por_setor_por_carrier()
	Model.calcular_eficiencia_por_setor()
	Model.calcular_eficiencia_agregada()
	Model.calcular_valores_absolutos_de_exergia_final_por_carrier()
	Model.calcular_emissoes_CO2_carvao_petroleo_gas_natural()
	Model.calcular_eletricidade_de_fontes_renovaveis()
	Model.calcular_eletricidade_nao_renovavel()
	Model.calcular_emissoes_nao_renovaveis()
	Model.calcular_emissoes_totais()
	Model.calcular_consumo()
	Model.calcular_utilidade()

	update_simulator_text()
	

func _on_EscreverFicheiro_pressed():
	get_node("FileWritePopup").popup()

	
	
func update_simulator_text():
	$ModelPopup/Control/Texto.text = ""
	
	# loop for n = 0 to ano_atual_indice
	for n in range(Model.ano_atual_indice + 1):
		$ModelPopup/Control/Texto.text += "Ano: " + str(Model.ano_do_indice(n)) \
			+ "\nPotencia Instalada Solar: " + str(Model.potencia_do_ano_solar[n]) + " GW" \
			+ "\nPotencia Instalada Vento: " + str(Model.potencia_do_ano_vento[n]) + " GW" \
			+ "\nPotencia Instalada Biomassa: " + str(Model.potencia_do_ano_biomassa[n]) + " GW" \
			+ "\nCusto solar: " + str(Model.custo_do_ano_solar[n]) + " euros" \
			+ "\nCusto vento: " + str(Model.custo_do_ano_vento[n]) + " euros" \
			+ "\nCusto biomassa: " + str(Model.custo_do_ano_biomassa[n]) + " euros" \
			+ "\nCusto total: " + str(Model.custo_total_do_ano[n]) + " euros" \
			+ "\nPIB: " + str(Model.pib_do_ano[n]) + " milhares de milhões euros" \
			+ "\nInvestimento para capital: " + str(Model.investimento_para_capital_do_ano[n]) + " euros" \
			+ "\nCapital: " + str(Model.capital_do_ano[n]) + " euros" \
			+ "\nLabour: " + str(Model.labour_do_ano[n]) + " horas de trabalho" \
			+ "\nTFP: " + str(Model.tfp_do_ano[n]) \
			+ "\neficiencia_agregada_do_ano.back(): " + str(Model.eficiencia_agregada_do_ano[n-1]) \
			+ "\nExergia Útil: " + str(Model.exergia_util_do_ano[n]) + " TJ" \
			+ "\nExergia Final: " + str(Model.exergia_final_do_ano[n]) + " TJ" \
			+ "\nShares Exergia Final Transportes: " + str(Model.shares_exergia_final_transportes_do_ano[n]) \
			+ "\nShares Exergia Final Indústria: " + str(Model.shares_exergia_final_industria_do_ano[n]) \
			+ "\nShares Exergia Final Residencial: " + str(Model.shares_exergia_final_residencial_do_ano[n]) \
			+ "\nShares Exergia Final Serviços: " + str(Model.shares_exergia_final_servicos_do_ano[n]) \
			+ "\nEletrificação Transportes: " + str(Model.eletrificacao_transportes[n]) \
			+ "\nEletrificação Industria: " + str(Model.eletrificacao_industria[n]) \
			+ "\nEletrificação Residencial: " + str(Model.eletrificacao_residencial[n]) \
			+ "\nEletrificação Serviços: " + str(Model.eletrificacao_servicos[n]) \
			+ "\nShares Exergia Final Transportes Eletricidade: " + str(Model.shares_exergia_final_transportes_eletricidade_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Eletricidade: " + str(Model.shares_exergia_final_industria_eletricidade_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Eletricidade: " + str(Model.shares_exergia_final_residencial_eletricidade_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Eletricidade: " + str(Model.shares_exergia_final_servicos_eletricidade_do_ano[n]) \
			+ "\nShares Exergia Final Transportes Carvão: " + str(Model.shares_exergia_final_transportes_carvao_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Carvão: " + str(Model.shares_exergia_final_industria_carvao_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Carvão: " + str(Model.shares_exergia_final_residencial_carvao_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Carvão: " + str(Model.shares_exergia_final_servicos_carvao_do_ano[n]) \
			+ "\nShares Exergia Final Transportes Petróleo: " + str(Model.shares_exergia_final_transportes_petroleo_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Petróleo: " + str(Model.shares_exergia_final_industria_petroleo_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Petróleo: " + str(Model.shares_exergia_final_residencial_petroleo_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Petróleo: " + str(Model.shares_exergia_final_servicos_petroleo_do_ano[n]) \
			+ "\nShares Exergia Final Transportes Gás Natural: " + str(Model.shares_exergia_final_transportes_gas_natural_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Gás Natural: " + str(Model.shares_exergia_final_industria_gas_natural_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Gás Natural: " + str(Model.shares_exergia_final_residencial_gas_natural_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Gás Natural: " + str(Model.shares_exergia_final_servicos_gas_natural_do_ano[n]) \
			+ "\nExergia Final Transportes: " + str(Model.exergia_final_transportes_do_ano[n]) + " TJ"  \
			+ "\nExergia Final Indústria: " + str(Model.exergia_final_industria_do_ano[n]) + " TJ"  \
			+ "\nExergia Final Residencial: " + str(Model.exergia_final_residencial_do_ano[n]) + " TJ"  \
			+ "\nExergia Final Serviços: " + str(Model.exergia_final_servicos_do_ano[n]) + " TJ"  \
			+ "\nExergia Útil Transportes: " + str(Model.exergia_util_transportes_do_ano[n]) + " TJ"  \
			+ "\nExergia Útil Indústria: " + str(Model.exergia_util_industria_do_ano[n]) + " TJ"  \
			+ "\nExergia Útil Residencial: " + str(Model.exergia_util_residencial_do_ano[n]) + " TJ"  \
			+ "\nExergia Útil Serviços: " + str(Model.exergia_util_servicos_do_ano[n]) + " TJ"  \
			+ "\nEficiência Transportes: " + str(Model.eficiencia_transportes_do_ano[n])  \
			+ "\nEficiência Indústria: " + str(Model.eficiencia_industria_do_ano[n])  \
			+ "\nEficiência Residencial: " + str(Model.eficiencia_residencial_do_ano[n])  \
			+ "\n..." \
			+ "\nEficiência Agregada: " + str(Model.eficiencia_agregada_do_ano[n])  \
			+ "\n..." \
			+ "\nEletricidade Renovável: " + str(Model.eletricidade_renovavel_do_ano[n]) + " TJ"  \
			+ "\nEletricidade Não Renovável: " + str(Model.eletricidade_nao_renovavel_do_ano[n]) + " GWh"  \
			+ "\nEmissões Não Renováveis: " + str(Model.emissoes_nao_renovaveis_do_ano[n]) + " Tons"  \
			+ "\nEMISSÔES TOTAIS DO ANO: " + str(Model.emissoes_totais_do_ano[n]) + " Tons"  \
			+ "\nConsumo: " + str(Model.consumo_do_ano[n]) + " euros?"  \
			+ "\nUTILIDADE (felicidade dos cidadãos): " + str(Model.utilidade_do_ano[n])  \
			+ "\n\n"
		


func _on_FecharEscreverFicheiro_pressed():
	get_node("FileWritePopup").hide()

