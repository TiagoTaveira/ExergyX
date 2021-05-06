# The game implementation, uses Model.gd as its backend
# Developed by:
# - André Fidalgo Silva
# Assisted by:
# - Prof. Rui Prada
# - Prof. Tânia Sousa
# - Bárbara Caracol
# - João Santos
# - Laura Felício

extends Panel

# Final year constant. Change here to have the game end at a different year (default = 2050)
var FINAL_YEAR = 2050

# Storage of the history of the player's decisions
var decisions_investment_renewables = [PlayerVariables.investment_renewables_percentage]
var decisions_shares_transportation = [PlayerVariables.economy_type_level_transportation]
var decisions_shares_industry = [PlayerVariables.economy_type_level_industry]
var decisions_shares_residential = [PlayerVariables.economy_type_level_residential]
var decisions_shares_services = [PlayerVariables.economy_type_level_services]
var decisions_eletrification_transportation  = [PlayerVariables.electrification_by_sector_level_transportation]
var decisions_eletrification_industry = [PlayerVariables.electrification_by_sector_level_industry]
var decisions_eletrification_residential = [PlayerVariables.electrification_by_sector_level_residential]
var decisions_eletrification_services = [PlayerVariables.electrification_by_sector_level_services]

var simulator_used = false #true when the model debug simulator is used

var total_cost = 0
var calculated_budget = 0
var politics = []
var selected_politics = []

#List of buttons
var transports_politics = []
var industry_politics = []
var services_politics = []
var residential_politics = []

var politics_dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_intro_text()
	$NewGamePopup.popup()
	randomize()
	initial_model_loading()
	#function that initializes text from variables () goes here
	update_text()
	#first_year_text()
	create_politics()
	create_buttons_by_sector(politics)
	filter_list("Transports")
	update_simulator_text()
	#update_past_data_text()
	get_node("ContainerDecisoes/economyOptions").add_item("Transports",0)
	get_node("ContainerDecisoes/economyOptions").add_item("Industry",1)
	get_node("ContainerDecisoes/economyOptions").add_item("Residential",2)
	get_node("ContainerDecisoes/economyOptions").add_item("Services",3)
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
#	get_node("ContainerDecisoes/sc/ListBox/Politica1").connect("pressed", self, "on_Politic1_pressed")
#	get_node("ContainerDecisoes/sc/ListBox/Politica2").connect("pressed", self, "on_Politic2_pressed")
#	get_node("ContainerDecisoes/sc/ListBox/Politica3").connect("pressed", self, "on_Politic3_pressed")
	get_node("ContainerDecisoes/economyOptions").connect("item_selected", self, "on_EconomyOptions_pressed")
	#Run one year of the game, in order to start with all data filled:
	process_next_year()
	#update_graph()
	update_text()
	update_simulator_text()


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
	PlayerVariables.co2_emissions = Model.emissoes_totais_do_ano[Model.ano_atual_indice]  * pow(10, -9)
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
	
	PlayerVariables.budget = Model.pib_do_ano[Model.ano_atual_indice]*0.01 * 1000
	calculated_budget = Model.pib_do_ano[Model.ano_atual_indice]*0.01 * 1000
	

func send_game_decisions_to_model():
	Model.input_potencia_a_instalar = PlayerVariables.investment_renewables_percentage
	print ("@send_game_decisions_to_model - " + str(PlayerVariables.investment_renewables_percentage))

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
	Model.calcular_valores_absolutos_de_exergia_final_por_setor()
	Model.calcular_eletrificacao_etc_de_setores()
	Model.calcular_shares_de_exergia_final_por_setor_por_carrier()	
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
	print("Current year: " + str(PlayerVariables.current_year))
	PlayerVariables.money = Model.pib_do_ano[-1]
	calculated_budget = PlayerVariables.money
	PlayerVariables.expenditure = Model.consumo_do_ano[-1]
	PlayerVariables.utility = Model.utilidade_do_ano[Model.ano_atual_indice]
	PlayerVariables.co2_emissions = Model.emissoes_totais_do_ano[Model.ano_atual_indice]  * pow(10, -9)
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
	for y in range(current_year +4 , final_year + 2):
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
		PredictionsModel.calcular_valores_absolutos_de_exergia_final_por_setor()
		PredictionsModel.calcular_eletrificacao_etc_de_setores()
		PredictionsModel.calcular_shares_de_exergia_final_por_setor_por_carrier()
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
	PlayerVariables.final_year_emissions = PredictionsModel.emissoes_totais_do_ano[PredictionsModel.indice_do_ano(final_year)] * pow(10, -9)
	PlayerVariables.final_year_efficiency = PredictionsModel.eficiencia_agregada_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_expenditure = PredictionsModel.consumo_do_ano[PredictionsModel.indice_do_ano(final_year)]
	PlayerVariables.final_year_money = PredictionsModel.pib_do_ano[PredictionsModel.indice_do_ano(final_year)]
	
# Handle game text
func update_text():
	get_node("EstadoAtual/AnoAtual/Ano").text = str(PlayerVariables.current_year)
	get_node("EstadoAtual/TextoAnoAtual").text = "Ano Atual"

	get_node("EstadoAtual/TextoDadosEnergeticos").text = "Potência Total Instalada (Fração Renovável): " + str(stepify(PlayerVariables.total_installed_power, 0.1)) + " GW" + "\n\nEletricidade Renovável: " + str(stepify(PlayerVariables.renewable_energy, 0.1)) + " GWh" + "\n\nEmissões: " + str(stepify(PlayerVariables.co2_emissions, 0.001)) + " Mt CO2" + "\n\nEficiência Agregada do País: " + str(stepify(PlayerVariables.efficiency * 100, 0.1)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesTransportes").text = str(stepify(PlayerVariables.economy_type_percentage_transportation, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesIndustria").text = str(stepify(PlayerVariables.economy_type_percentage_industry, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesResidencial").text = str(stepify(PlayerVariables.economy_type_percentage_residential, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/SharesServicos").text = str(stepify(PlayerVariables.economy_type_percentage_services, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoTransportes").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_transportation, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoIndustria").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_industry, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoResidencial").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_residential, 0.01)) + "%"
	get_node("EstadoAtual/FundoTabela/Control/EletrificacaoServicos").text = str(stepify(PlayerVariables.electrification_by_sector_percentage_services, 0.01)) + "%"
	get_node("EstadoAtual/TextoDadosSocioeconomicos").text = "PIB: " + str(stepify(PlayerVariables.money, 1)) + " milhares de milhões €" + "\n\nConsumo: " + str(stepify(PlayerVariables.expenditure, 1)) + " milhares de milhões €" + "\n\nFelicidade do Cidadão: " + str(stepify(PlayerVariables.utility, 0.01))
	get_node("ContainerPrevisoes/TextoOutrosDados").text = "Eficiência Agregada do País: " + str(stepify(PlayerVariables.final_year_efficiency * 100, 0.1)) + "%" + "\n\nPIB: " + str(stepify(PlayerVariables.final_year_money, 1)) +" milhares de milhões €" + "\n\nConsumo: " + str(stepify(PlayerVariables.final_year_expenditure, 1)) + " milhares de milhões €"
	#get_node("ContainerDecisoes/ProximoAno").text = "Decisões para " + str(PlayerVariables.current_year + 1)
	get_node("ContainerDecisoes/ProximoAno").text = "Decisões"
	get_node("ContainerPrevisoes/RichTextLabel").text = str(PlayerVariables.final_year) + " - Previsões"
	get_node("ContainerPrevisoes/TextoPrevisoes").bbcode_text = "Felicidade do Cidadãos: " + str(PlayerVariables.final_year_utility, 0.01) + "\n\n" + "Emissões CO2: " + str(stepify(PlayerVariables.final_year_emissions, 0.01)) + " Mt CO2" + "\n\n" + "Crescimento Económico: [color=green]1%[/color] (1%)"  #exemplo de texto
	##Actual bbcode text setting (with conditions)
	get_node("ContainerPrevisoes/TextoPrevisoes").bbcode_text = "Felicidade do Cidadão: " + ("[color=red]" if PlayerVariables.final_year_utility < PlayerVariables.utility_goals else "[color=green]") + str(stepify(PlayerVariables.final_year_utility, 0.01)) + "[/color]\n\n"    +   "Emissões CO2: " + ("[color=red]" if PlayerVariables.final_year_emissions > PlayerVariables.emission_goals else "[color=green]") + str(stepify(PlayerVariables.final_year_emissions, 0.001)) + " Mt CO2[/color]"
	get_node("ContainerPrevisoes/TextoMetas").bbcode_text = "Felicidade do Cidadão: ≥ " + str(PlayerVariables.utility_goals) + "\n\nEmissões CO2: ≤ " + str(PlayerVariables.emission_goals) + " Mt CO2"
	get_node("ContainerPrevisoes/Metas").hint_tooltip = "Estes são os objetivos do jogo.\n\nSe em " + str(PlayerVariables.final_year) + " atingires as duas metas (têm de ser mesmo as duas!), vences o jogo!"
	get_node("ContainerPrevisoes/TextoMetas").hint_tooltip = "Estes são os objetivos do jogo.\n\nSe em " + str(PlayerVariables.final_year) + " atingires as duas metas (têm de ser mesmo as duas!), vences o jogo!"
	get_node("ContainerPrevisoes/Panel/PreviousYear").text = str(PlayerVariables.current_year  - 1)
	get_node("ContainerPrevisoes/Panel/CurrentYear").text = str(PlayerVariables.current_year)
	get_node("ContainerPrevisoes/Panel/NextYear").text = str(PlayerVariables.current_year + 1)
	
	calculated_budget = calculated_budget*10
	get_node("ContainerDecisoes/Budget").text = "Orçamento: " + str(stepify(calculated_budget, 0.01)) + " M€"

func first_year_text():
	get_node("ContainerPrevisoes/TextoPrevisoes").bbcode_text = "Felicidade do Cidadão: n/d\n\n"    +   "Emissões CO2: n/d"
	get_node("ContainerPrevisoes/TextoOutrosDados").text = "Eficiência Agregada do País: " + "n/d" + "\n\nPIB: " + "n/d" + "\n\nConsumo: " + "n/d"
	get_node("EstadoAtual/TextoDadosEnergeticos").text = "Potência Total Instalada (Fração Renovável): " + str(stepify(PlayerVariables.total_installed_power, 0.1)) + " GW" + "\n\nEletricidade Renovável: " + "n/d" + "\n\nEmissões: " + "n/d" + "\n\nEficiência Agregada do País: " + str(stepify(PlayerVariables.efficiency * 100, 0.1)) + "%"
	get_node("EstadoAtual/TextoDadosSocioeconomicos").text = "PIB: " + str(stepify(PlayerVariables.money, 1)) + " milhares de milhões €" + "\n\nConsumo: " + "n/d" + "\n\nFelicidade do Cidadão: " + "n/d"
	
func set_intro_text():
	get_node("NewGamePopup/Control/Text").text = "Parabéns! Devido aos teus conhecimentos, foste escolhido como assessor do governo português. A tua missão é assegurar que Portugal usa os seus recursos económicos e energéticos de forma a que o país possa alcançar as suas metas futuras (em termos de emissões de CO2 enquanto garantes a felicidade da população) para o ano de " + str(FINAL_YEAR) + "." \
		+ "\n\nA redução das emissões de CO2 exige que haja uma eletrificação renovável significativa dos setores da sociedade. À crescente eletrificação dos usos está associado um aumento da eficiência que promove crescimento económico e, portanto, um uso crescente de energia. O fornecimento desta energia extra de forma renovável exige um investimento massivo na instalação de potência elétrica renovável. No entanto, este investimento diminui o rendimento disponível para consumo. " \
		+ "A felicidade dos cidadãos aumenta com a diminuição das emissões de CO2 e com o rendimento disponível para consumo."  \
		+ "\n\nCom a tua influência, poderás fazer com que o governo tome as ações necessárias para garantir o sucesso da tua missão." \
		+ " Poderás tomar vários tipos de decisões, incluindo a instalação de infraestruturas que aumentem a produção da potência elétrica renovável, e que alterem a importância relativa e aumentem a eletrificação de cada um dos setores." \
		+ "\n\nColoca o cursor do rato sobre qualquer elemento do jogo para obteres mais informação." \
		+ "\n\nBoa sorte!"

#>Parágrafo sobre tipo de decisões que pode tomar


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
		refund_to_budget(PlayerVariables.cost_per_gigawatt*0.000001)
		$ContainerDecisoes/ScrollContainer/Control/ValorCusto.bbcode_text = "[right]" + str(stepify(PlayerVariables.investment_cost,1)) + "[/right]"

func on_Investment_Plus_Button_pressed():
	if(PlayerVariables.investment_renewables_percentage < 10.00):
		PlayerVariables.investment_renewables_percentage += 0.10
		if(PlayerVariables.investment_renewables_percentage > 9.99):
			PlayerVariables.investment_renewables_percentage = 10.00
		$ContainerDecisoes/ScrollContainer/Control/ValorPotencia.bbcode_text = "[right]" + str(PlayerVariables.investment_renewables_percentage) + "[/right]"
		
		if(reduce_budget(PlayerVariables.cost_per_gigawatt*0.000001)):
			PlayerVariables.investment_cost = PlayerVariables.investment_renewables_percentage * PlayerVariables.cost_per_gigawatt
			$ContainerDecisoes/ScrollContainer/Control/ValorCusto.bbcode_text = "[right]" + str(stepify(PlayerVariables.investment_cost,1)) + "[/right]"

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

func store_decision_history():
	decisions_investment_renewables.push_back(PlayerVariables.investment_renewables_percentage)
	decisions_shares_transportation.push_back(PlayerVariables.economy_type_level_transportation)
	decisions_shares_industry.push_back(PlayerVariables.economy_type_level_industry)
	decisions_shares_residential.push_back(PlayerVariables.economy_type_level_residential)
	decisions_shares_services.push_back(PlayerVariables.economy_type_level_services)
	decisions_eletrification_transportation .push_back(PlayerVariables.electrification_by_sector_level_transportation)
	decisions_eletrification_industry.push_back(PlayerVariables.electrification_by_sector_level_industry)
	decisions_eletrification_residential.push_back(PlayerVariables.electrification_by_sector_level_residential)
	decisions_eletrification_services.push_back(PlayerVariables.electrification_by_sector_level_services)


func on_History_Button_pressed():
	get_node("GrafHistorico").popup()


func _on_FecharHistorico_pressed():
	get_node("GrafHistorico").hide()
	
#func update_graph():
#	if !simulator_used:
#		update_past_data_text()
#	else:
#		update_past_data_text_simulator()
		
	var MAX_Y = 700
	var MAX_X = 750
	var TEXT_Y_OFFSET = 15
	
	var years_passed = (PlayerVariables.current_year - PlayerVariables.starting_year -4)/4
	var point_x_distance = 0 if years_passed == 1 else MAX_X / (years_passed - 1)
	var max_y = MAX_Y
	var values_text_offset = 739 - TEXT_Y_OFFSET
	var current_final_x_emissions
	var current_final_y_emissions
	var current_final_x_utility
	var current_final_y_utility
	
	get_node("GrafHistorico/Control/StartingYear").bbcode_text = str(PlayerVariables.starting_year + 1)
	get_node("GrafHistorico/Control/CurrentYear").bbcode_text = str(PlayerVariables.current_year)
	get_node("GrafHistorico/Control/FinalYear").bbcode_text = str(PlayerVariables.final_year)
	
	$GrafHistorico/Control/EmissionsLine.clear_points()
	$GrafHistorico/Control/UtilityLine.clear_points()
	$GrafHistorico/Control/EmissionsLinePrediction.clear_points()
	$GrafHistorico/Control/UtilityLinePrediction.clear_points()
	
	#Get points y-values
	var emissions_values = []
	for e in range(Model.emissoes_totais_do_ano.size()):
		if e != 0:
			emissions_values.push_back(Model.emissoes_totais_do_ano[e])
	
	var utility_values = []
	for u in range(Model.utilidade_do_ano.size()):
		if u != 0:
			utility_values.push_back(Model.utilidade_do_ano[u])
	
	#Normalize values for chart y-boundaries
	var emissions_max = emissions_values.max()
	if emissions_max < PlayerVariables.final_year_emissions * pow(10, 9):
		emissions_max = PlayerVariables.final_year_emissions * pow(10, 9)
	var emissions_y_values = []
	for e in range(emissions_values.size()):
		emissions_y_values.push_back((emissions_values[e] * max_y) / emissions_max)
	
	var utility_max = utility_values.max()
	if utility_max < PlayerVariables.final_year_utility:
		utility_max = PlayerVariables.final_year_utility
	var utility_y_values = []
	for u in range(utility_values.size()):
		utility_y_values.push_back((utility_values[u] * max_y) / utility_max)
		
	#test
	#for v in range(emissions_values.size()):
	#	print("Value " + str(v) + ": " + str(emissions_values[v]))
	
	#Test values (run up to 2 years)
	#emissions_y_values = [100, 0, 650]
	#for v in range(emissions_y_values.size()):
		#pass
		#print("Value " + str(v) + ": " + str(emissions_y_values[v]))
	
	#Draw lines and update values' text
	for y in range(years_passed):
		$GrafHistorico/Control/EmissionsLine.add_point((Vector2(point_x_distance * y, emissions_y_values[y] * -1)))
		if y == 0:
			$GrafHistorico/Control/EmissionsValueStart.rect_position = Vector2($GrafHistorico/Control/EmissionsValueStart.rect_position.x, values_text_offset - emissions_y_values[y])
			$GrafHistorico/Control/EmissionsValueStart.bbcode_text = "[right]" + str(stepify(Model.emissoes_totais_do_ano[y + 1] * pow(10, -9), 0.01)) + " Mt CO2[/right]"
		if y == years_passed - 1:
			$GrafHistorico/Control/EmissionsValueCurrent.rect_position = Vector2($GrafHistorico/Control/EmissionsValueCurrent.rect_position.x, values_text_offset - emissions_y_values[y])
			$GrafHistorico/Control/EmissionsValueCurrent.bbcode_text = str(stepify(Model.emissoes_totais_do_ano[y + 1] * pow(10, -9), 0.01)) + " Mt CO2"
	
		$GrafHistorico/Control/UtilityLine.add_point((Vector2(point_x_distance * y, utility_y_values[y] * -1)))
		if y == 0:
			$GrafHistorico/Control/UtilityValueStart.rect_position = Vector2($GrafHistorico/Control/UtilityValueStart.rect_position.x, values_text_offset - utility_y_values[y])
			$GrafHistorico/Control/UtilityValueStart.bbcode_text = "[right]" + str(stepify(Model.utilidade_do_ano[y + 1], 0.01)) + "[/right]"
		if y == years_passed - 1:
			$GrafHistorico/Control/UtilityValueCurrent.rect_position = Vector2($GrafHistorico/Control/UtilityValueCurrent.rect_position.x, values_text_offset - utility_y_values[y])
			$GrafHistorico/Control/UtilityValueCurrent.bbcode_text = str(stepify(Model.utilidade_do_ano[y + 1], 0.01))
		
		current_final_x_emissions = point_x_distance * y
		current_final_y_emissions = emissions_y_values[y] * -1
		
		current_final_x_utility = point_x_distance * y
		current_final_y_utility = utility_y_values[y] * -1
		
	#Draw predictions lines and text
	if years_passed > 1:
		$GrafHistorico/Control/EmissionsLinePrediction.add_point((Vector2(current_final_x_emissions, current_final_y_emissions)))
		$GrafHistorico/Control/EmissionsLinePrediction.add_point((Vector2(MAX_X * 2, (PlayerVariables.final_year_emissions * pow(10, 9) * max_y) / emissions_max * -1)))
		$GrafHistorico/Control/UtilityLinePrediction.add_point((Vector2(current_final_x_utility, current_final_y_utility)))
		$GrafHistorico/Control/UtilityLinePrediction.add_point((Vector2(MAX_X * 2, (PlayerVariables.final_year_utility * max_y) / utility_max * -1)))
		
		$GrafHistorico/Control/EmissionsValueEnd.rect_position = Vector2($GrafHistorico/Control/EmissionsValueEnd.rect_position.x, values_text_offset - (PlayerVariables.final_year_emissions  * pow(10, 9) * max_y) / emissions_max)
		$GrafHistorico/Control/EmissionsValueEnd.bbcode_text = str(stepify(PlayerVariables.final_year_emissions, 0.01)) + " Mt CO2" + "\nMeta: ≤ " + str(PlayerVariables.emission_goals) + " Mt CO2"
		$GrafHistorico/Control/UtilityValueEnd.rect_position = Vector2($GrafHistorico/Control/UtilityValueEnd.rect_position.x, values_text_offset - (PlayerVariables.final_year_utility * max_y) / utility_max)
		$GrafHistorico/Control/UtilityValueEnd.bbcode_text = str(stepify(PlayerVariables.final_year_utility, 0.01)) + "\nMeta: ≥ " + str(PlayerVariables.utility_goals)
		
		var achieved_emissions = PlayerVariables.final_year_emissions <= PlayerVariables.emission_goals
		var achieved_utility = PlayerVariables.final_year_utility >= PlayerVariables.utility_goals
		
		if achieved_emissions:
			$GrafHistorico/Control/EmissionsValueEnd.bbcode_text += " [color=green][b](√)[/b][/color]"
			$GrafHistorico/Control/EmissionsValueEnd.hint_tooltip = "De acordo com as previsões atuais, irás cumprir este objetivo no ano meta!\nTenta que isto não mude!"
		else:
			$GrafHistorico/Control/EmissionsValueEnd.bbcode_text += " [color=red][b](!)[/b][/color]"
			$GrafHistorico/Control/EmissionsValueEnd.hint_tooltip = "De acordo com as previsões atuais, NÃO irás cumprir este objetivo no ano meta!\nTenta mudar isto!"
		if achieved_utility:
			$GrafHistorico/Control/UtilityValueEnd.bbcode_text += " [color=green][b](√)[/b][/color]"
			$GrafHistorico/Control/UtilityValueEnd.hint_tooltip = "De acordo com as previsões atuais, irás cumprir este objetivo no ano meta!\nTenta que isto não mude!"
		else:
			$GrafHistorico/Control/UtilityValueEnd.bbcode_text += " [color=red][b](!)[/b][/color]"
			$GrafHistorico/Control/UtilityValueEnd.hint_tooltip = "De acordo com as previsões atuais, NÃO irás cumprir este objetivo no ano meta!\nTenta mudar isto!"
			
	#####EXPERIMENTAL#####
	#get_node("GrafHistorico/Control/TestLine2D").add_point(Vector2(400, 400))
	#get_node("GrafHistorico/Control/TestLine2D").add_point(Vector2(500, 500))
	######################


func _on_ShowEmissions_toggled(button_pressed):
	if $GrafHistorico/Control/ShowEmissions.is_pressed():
		$GrafHistorico/Control/EmissionsLine.visible = true
		$GrafHistorico/Control/EmissionsLinePrediction.visible = true
		$GrafHistorico/Control/EmissionsValueStart.visible = true
		$GrafHistorico/Control/EmissionsValueCurrent.visible = true
		$GrafHistorico/Control/EmissionsValueEnd.visible = true
	else:
		$GrafHistorico/Control/EmissionsLine.visible = false
		$GrafHistorico/Control/EmissionsLinePrediction.visible = false
		$GrafHistorico/Control/EmissionsValueStart.visible = false
		$GrafHistorico/Control/EmissionsValueCurrent.visible = false
		$GrafHistorico/Control/EmissionsValueEnd.visible = false

func _on_ShowUtility_toggled(button_pressed):
	if $GrafHistorico/Control/ShowUtility.is_pressed():
		$GrafHistorico/Control/UtilityLine.visible = true
		$GrafHistorico/Control/UtilityLinePrediction.visible = true
		$GrafHistorico/Control/UtilityValueStart.visible = true
		$GrafHistorico/Control/UtilityValueCurrent.visible = true
		$GrafHistorico/Control/UtilityValueEnd.visible = true
	else:
		$GrafHistorico/Control/UtilityLine.visible = false
		$GrafHistorico/Control/UtilityLinePrediction.visible = false
		$GrafHistorico/Control/UtilityValueStart.visible = false
		$GrafHistorico/Control/UtilityValueCurrent.visible = false
		$GrafHistorico/Control/UtilityValueEnd.visible = false

#func update_past_data_text():
#	$PastDataPopup/Control/Texto.bbcode_text = ""
#
#	# loop for n = 0 to ano_atual_indice
#	for n in range(1, Model.ano_atual_indice + 1):
#		$PastDataPopup/Control/Texto.bbcode_text += "[b]> Ano: " + str(Model.ano_do_indice(n)) + "[/b]" \
#			+ "[indent]\n[u]Decisões[/u]:" \
#			+ "\n[indent]Adição de Potência Instalada Renovável: " + str(decisions_investment_renewables[n]) + " GW" \
#			+ "\n" \
#			+ "\nTipo de Economia (Transportes): " + number_to_arrow(decisions_shares_transportation[n]) \
#			+ "\nTipo de Economia (Indústria): " + number_to_arrow(decisions_shares_industry[n]) \
#			+ "\nTipo de Economia (Residencial): " + number_to_arrow(decisions_shares_residential[n]) \
#			+ "\nTipo de Economia (Serviços): " + number_to_arrow(decisions_shares_services[n]) \
#			+ "\n" \
#			+ "\nEletrificação por Setor (Transportes): " + number_to_arrow(decisions_eletrification_transportation[n]) \
#			+ "\nEletrificação por Setor (Indústria): " + number_to_arrow(decisions_eletrification_industry[n]) \
#			+ "\nEletrificação por Setor (Residencial): " + number_to_arrow(decisions_eletrification_residential[n]) \
#			+ "\nEletrificação por Setor (Serviços): " + number_to_arrow(decisions_eletrification_services[n]) + "[/indent]" \
#			+ "\n\n[u]Resultados[/u]:" \
#			+ "\n[indent]Potência Instalada (Solar): " + str(Model.potencia_do_ano_solar[n]) + " GW" \
#			+ "\nPotência Instalada (Vento): " + str(Model.potencia_do_ano_vento[n]) + " GW" \
#			+ "\nPotência Instalada (Biomassa): " + str(Model.potencia_do_ano_biomassa[n]) + " GW" \
#			+ "\nCusto Total da Potência Instalada: " + str(stepify(Model.custo_total_do_ano[n], 1)) + " euros" \
#			+ "\n" \
#			+ "\nProduto Interno Bruto (PIB): " + str(stepify(Model.pib_do_ano[n], 0.01)) + " milhares de milhões de euros" \
#			+ "\nConsumo: " + str(stepify(Model.consumo_do_ano[n], 0.01)) + " milhares de milhões de euros"  \
#			+ "\n" \
#			+ "\nShares Exergia Final Transportes: " + str(Model.shares_exergia_final_transportes_do_ano[n]) \
#			+ "\nShares Exergia Final Indústria: " + str(Model.shares_exergia_final_industria_do_ano[n]) \
#			+ "\nShares Exergia Final Residencial: " + str(Model.shares_exergia_final_residencial_do_ano[n]) \
#			+ "\nShares Exergia Final Serviços: " + str(Model.shares_exergia_final_servicos_do_ano[n]) \
#			+ "\n" \
#			+ "\nEletrificação Transportes: " + str(Model.eletrificacao_transportes[n]) \
#			+ "\nEletrificação Industria: " + str(Model.eletrificacao_industria[n]) \
#			+ "\nEletrificação Residencial: " + str(Model.eletrificacao_residencial[n]) \
#			+ "\nEletrificação Serviços: " + str(Model.eletrificacao_servicos[n]) \
#			+ "\n" \
#			+ "\nEficiência Agregada: " + str(stepify(Model.eficiencia_agregada_do_ano[n], 0.01))  \
#			+ "\nEletricidade Renovável: " + str(stepify(Model.eletricidade_renovavel_do_ano[n], 0.01)) + " GWh"  \
#			+ "\nEmissões Totais: " + str(stepify(Model.emissoes_totais_do_ano[n], 0.01)) + " kg CO2"  \
#			+ "\nÍndice de Felicidade dos Cidadãos: " + str(stepify(Model.utilidade_do_ano[n], 0.0001)) + "[/indent]" \
#			+ "\n\n\n[/indent]"
		
func number_to_arrow(number):
	match number:
		1:
			return "[color=blue][b]↓↓↓↓↓[/b][/color]"
		2:
			return "[color=blue][b]↓↓↓↓[/b][/color]"
		3:
			return "[color=blue][b]↓↓↓[/b][/color]"
		4:
			return "[color=blue][b]↓↓[/b][/color]"
		5:
			return "[color=blue][b]↓[/b][/color]"
		6:
			return "[color=gray][b]=[/b][/color]"
		7:
			return "[color=red][b]↑[/b][/color]"
		8:
			return "[color=red][b]↑↑[/b][/color]"
		9:
			return "[color=red][b]↑↑↑[/b][/color]"
		10:
			return "[color=red][b]↑↑↑↑[/b][/color]"
		11:
			return "[color=red][b]↑↑↑↑↑[/b][/color]"



func _on_Button_pressed(): #Submit Decisions Button
	#get_node("AcceptDialog").popup_centered_ratio(0.20)
	disable_all_buttons()
	update_confirmation_popup()
	get_node("ConfirmationPopup").popup()
	#var packed_scene = PackedScene.new()
	#packed_scene.pack(get_tree().get_current_scene())
	#ResourceSaver.save("res://my_scene.tscn", packed_scene)
	#get_tree().change_scene("res://DecisionsScene.tscn")
	

func on_Confirm_Button_pressed():
	get_node("ConfirmationPopup").hide()
	#animation goes here
	next_year_animation()
	yield(get_tree().create_timer(1.0), "timeout") #wait() in GDscript
	enable_all_buttons()
	process_politic()
	process_next_year()
	clear_politics_selection()
	#update_graph()
	update_text()
	update_simulator_text()
	filter_list("Transports")
	
	
	
	if PlayerVariables.current_year < PlayerVariables.final_year:
		pass
	else:
		get_node("ContainerDecisoes/EnviarDecisoes").disabled = true
		var no_of_achieved_goals = 0
		var achieved_emissions = PlayerVariables.final_year_emissions <= PlayerVariables.emission_goals
		var achieved_utility = PlayerVariables.final_year_utility >= PlayerVariables.utility_goals
		var won = achieved_emissions && achieved_utility
		if won:
			get_node("PopupPanel/Control/WonLostText").text = "VENCEU!"
		else:
			var red_style = StyleBoxFlat.new()
			red_style.set_bg_color(Color("#ee827a"))
			red_style.corner_radius_bottom_left = 20
			red_style.corner_radius_bottom_right = 20
			red_style.corner_radius_top_left = 20
			red_style.corner_radius_top_right = 20
			get_node("PopupPanel").set('custom_styles/panel', red_style)
			get_node("ContainerResultados").set('custom_styles/bg', red_style)
			get_node("PopupPanel/Control/WonLostText").text = "PERDEU!"
			get_node("ContainerResultados/WonLostText").hide()
			get_node("ContainerResultados/WonLostText2").show()
			get_node("ContainerResultados/Resultados").hide()
			get_node("ContainerResultados/Resultados2").show()
		get_node("ContainerResultados/Resultados").text = str(PlayerVariables.final_year) + " - Resultados"
		get_node("PopupPanel/Control/Results").text = "Felicidade do Cidadão: " + str(PlayerVariables.final_year_utility) + "\n" + "Objetivo: " + str(PlayerVariables.utility_goals) + "\n\n" + "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " Mt CO2" + "\n" + "Objetivo: " + str(PlayerVariables.emission_goals) + " Mt CO2"
		if achieved_utility:
			no_of_achieved_goals += 1
			get_node("ContainerResultados/Dados").bbcode_text = "Felicidade dos Cidadãos: " + str(PlayerVariables.final_year_utility) + "\n> Objetivo cumprido!"
		else:
			get_node("ContainerResultados/Dados").bbcode_text = "Felicidade dos Cidadãos: " + str(PlayerVariables.final_year_utility) + "\n> Objetivo não cumprido..."
		if achieved_emissions:
			no_of_achieved_goals += 1
			get_node("ContainerResultados/Dados2").bbcode_text = "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " Mt CO2" + "\n> Objetivo cumprido!"
		else:
			get_node("ContainerResultados/Dados2").bbcode_text = "Emissões CO2: " + str(PlayerVariables.final_year_emissions) + " Mt CO2" + "\n> Objetivo não cumprido..."
		#get_node("PopupPanel").popup_centered()
		get_node("ContainerResultados/ObjetivosCumpridos").bbcode_text = "> " + str(no_of_achieved_goals) + "/2 objetivos cumpridos"
		if won:
			get_node("ContainerResultados/ObjetivosCumpridos").bbcode_text += "!"
		else:
			get_node("ContainerResultados/ObjetivosCumpridos").bbcode_text += "..."
		get_node("ContainerResultados").show()
		yield(get_tree().create_timer(1), "timeout") #wait() in GDscript
	
func next_year_animation():
	get_node("EstadoAtual/AnoAtual/Ano/NextYearAnimationPlayer").play("NextYear")
	pass
	
func on_Cancel_Button_pressed():
	get_node("ConfirmationPopup").hide()
	enable_all_buttons()


func process_next_year():
	
	#Store the year's decisions
	store_decision_history()

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
	get_node("ConfirmationPopup/Control/ConfirmarDecisoes").text = "Confirmar e ir para " + str(PlayerVariables.current_year + 4)
	get_node("ConfirmationPopup/Control/ResumoPotenciaInstalada").text = "Instalação: " + str(PlayerVariables.investment_renewables_percentage) + " GW \nCusto: " + str(stepify(PlayerVariables.investment_cost,1)) + " € (" + str(stepify(((PlayerVariables.investment_cost / PlayerVariables.money * pow(10,-9))) * 100, 0.00000001)) + "% do PIB)"

	

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
	simulator_used = true
	
	Model.input_potencia_a_instalar = get_node("ModelPopup/Control/Potencia").value
	Model.input_percentagem_tipo_economia_transportes = get_node("ModelPopup/Control/TipoEconomiaTransportes").value
	Model.input_percentagem_tipo_economia_industria = get_node("ModelPopup/Control/TipoEconomiaIndustria").value
	Model.input_percentagem_tipo_economia_residencial = get_node("ModelPopup/Control/TipoEconomiaResidencial").value
	Model.input_percentagem_tipo_economia_servicos = get_node("ModelPopup/Control/TipoEconomiaServicos").value
	Model.input_percentagem_eletrificacao_transportes = get_node("ModelPopup/Control/EletrificacaoTransportes").value
	Model.input_percentagem_eletrificacao_industria = get_node("ModelPopup/Control/EletrificacaoIndustria").value
	Model.input_percentagem_eletrificacao_residencial = get_node("ModelPopup/Control/EletrificacaoResidencial").value
	Model.input_percentagem_eletrificacao_servicos = get_node("ModelPopup/Control/EletrificacaoServicos").value
	
	decisions_investment_renewables.push_back(get_node("ModelPopup/Control/Potencia").value)
	decisions_shares_transportation.push_back(get_node("ModelPopup/Control/TipoEconomiaTransportes").value)
	decisions_shares_industry.push_back(get_node("ModelPopup/Control/TipoEconomiaIndustria").value)
	decisions_shares_residential.push_back(get_node("ModelPopup/Control/TipoEconomiaResidencial").value)
	decisions_shares_services.push_back(get_node("ModelPopup/Control/TipoEconomiaServicos").value)
	decisions_eletrification_transportation .push_back(get_node("ModelPopup/Control/EletrificacaoTransportes").value)
	decisions_eletrification_industry.push_back(get_node("ModelPopup/Control/EletrificacaoIndustria").value)
	decisions_eletrification_residential.push_back(get_node("ModelPopup/Control/EletrificacaoResidencial").value)
	decisions_eletrification_services.push_back(get_node("ModelPopup/Control/EletrificacaoServicos").value)

	
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
	update_past_data_text_simulator()
	

func _on_EscreverFicheiro_pressed():
	get_node("FileWritePopup").popup()

	
func update_simulator_text():
	$ModelPopup/Control/Texto.text = ""
	
	# loop for n = 0 to ano_atual_indice
	for n in range(Model.ano_atual_indice + 1):
		$ModelPopup/Control/Texto.text += "Ano: " + str(Model.ano_do_indice(n)) \
			+ "\nPotência Instalada Solar: " + str(Model.potencia_do_ano_solar[n]) + " GW" \
			+ "\nPotência Instalada Vento: " + str(Model.potencia_do_ano_vento[n]) + " GW" \
			+ "\nPotência Instalada Biomassa: " + str(Model.potencia_do_ano_biomassa[n]) + " GW" \
			+ "\nCusto solar: " + str(Model.custo_do_ano_solar[n]) + " euros" \
			+ "\nCusto vento: " + str(Model.custo_do_ano_vento[n]) + " euros" \
			+ "\nCusto biomassa: " + str(Model.custo_do_ano_biomassa[n]) + " euros" \
			+ "\nCusto total: " + str(Model.custo_total_do_ano[n]) + " euros" \
			+ "\nPIB: " + str(Model.pib_do_ano[n]) + " milhares de milhões euros" \
			+ "\nInvestimento para capital: " + str(Model.investimento_para_capital_do_ano[n]) + " milhares de milhões de euros" \
			+ "\nCapital: " + str(Model.capital_do_ano[n]) + " milhares de milhões de euros" \
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
			+ "\nShares Exergia Final Transportes Comb. Renováveis: " + str(Model.shares_exergia_final_transportes_comb_renovaveis_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Comb. Renováveis: " + str(Model.shares_exergia_final_industria_comb_renovaveis_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Comb. Renováveis: " + str(Model.shares_exergia_final_residencial_comb_renovaveis_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Comb. Renováveis: " + str(Model.shares_exergia_final_servicos_comb_renovaveis_do_ano[n]) \
			+ "\nShares Exergia Final Transportes Heat: " + str(Model.shares_exergia_final_transportes_heat_do_ano[n]) \
			+ "\nShares Exergia Final Indústria Heat: " + str(Model.shares_exergia_final_industria_heat_do_ano[n]) \
			+ "\nShares Exergia Final Residencial Heat: " + str(Model.shares_exergia_final_residencial_heat_do_ano[n]) \
			+ "\nShares Exergia Final Serviços Heat: " + str(Model.shares_exergia_final_servicos_heat_do_ano[n]) \
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
			+ "\nEficiência Serviços: " + str(Model.eficiencia_servicos_do_ano[n])  \
			+ "\n..." \
			+ "\nEficiência Agregada: " + str(Model.eficiencia_agregada_do_ano[n])  \
			+ "\n..." \
			+ "\nExergia Final Gás Natural: " + str(Model.exergia_final_gas_natural_do_ano[n]) + "TJ" \
			+ "\nExergia Final Comb. Renováveis: " + str(Model.exergia_final_comb_renovaveis_do_ano[n]) + "TJ" \
			+ "\n..." \
			+ "\nEmissões Carvão: " + str(Model.emissoes_CO2_carvao_do_ano[n])  + " kg CO2" \
			+ "\nEmissões Petróleo: " + str(Model.emissoes_CO2_petroleo_do_ano[n])  + " kg CO2" \
			+ "\nEmissões Gás Natural: " + str(Model.emissoes_CO2_gas_natural_do_ano[n])  + " kg CO2" \
			+ "\nEmissões Totais Sem Eletricidade: " + str(Model.emissoes_totais_sem_eletricidade[n])  + " kg CO2" \
			+ "\nEletricidade Renovável: " + str(Model.eletricidade_renovavel_do_ano[n]) + " GWh"  \
			+ "\nEletricidade Não Renovável: " + str(Model.eletricidade_nao_renovavel_do_ano[n]) + " GWh"  \
			+ "\nEmissões Não Renováveis: " + str(Model.emissoes_nao_renovaveis_do_ano[n]) + " kg CO2"  \
			+ "\nEMISSÕES TOTAIS DO ANO: " + str(Model.emissoes_totais_do_ano[n]) + " kg CO2"  \
			+ "\nConsumo: " + str(Model.consumo_do_ano[n]) + " milhares de milhões de euros"  \
			+ "\nUTILIDADE (felicidade dos cidadãos): " + str(Model.utilidade_do_ano[n])  \
			+ "\n\n"
		
func update_past_data_text_simulator():
	$PastDataPopup/Control/Texto.bbcode_text = ""
	
	# loop for n = 0 to ano_atual_indice
	for n in range(1, Model.ano_atual_indice + 1):
		$PastDataPopup/Control/Texto.bbcode_text += "[b]> Ano: " + str(Model.ano_do_indice(n)) + "[/b]" \
			+ "[indent]\n[u]Decisões[/u]:" \
			+ "\n[indent]Simulador usado. Decisões não disponíveis.[/indent]" \
			+ "\n\n[u]Resultados[/u]:" \
			+ "\n[indent]Potência Instalada (Solar): " + str(Model.potencia_do_ano_solar[n]) + " GW" \
			+ "\nPotência Instalada (Vento): " + str(Model.potencia_do_ano_vento[n]) + " GW" \
			+ "\nPotência Instalada (Biomassa): " + str(Model.potencia_do_ano_biomassa[n]) + " GW" \
			+ "\nCusto Total da Potência Instalada: " + str(stepify(Model.custo_total_do_ano[n], 1)) + " euros" \
			+ "\n" \
			+ "\nProduto Interno Bruto (PIB): " + str(stepify(Model.pib_do_ano[n], 0.01)) + " milhares de milhões de euros" \
			+ "\nConsumo: " + str(stepify(Model.consumo_do_ano[n], 0.01)) + " milhares de milhões de euros"  \
			+ "\n" \
			+ "\nShares Exergia Final Transportes: " + str(Model.shares_exergia_final_transportes_do_ano[n]) \
			+ "\nShares Exergia Final Indústria: " + str(Model.shares_exergia_final_industria_do_ano[n]) \
			+ "\nShares Exergia Final Residencial: " + str(Model.shares_exergia_final_residencial_do_ano[n]) \
			+ "\nShares Exergia Final Serviços: " + str(Model.shares_exergia_final_servicos_do_ano[n]) \
			+ "\n" \
			+ "\nEletrificação Transportes: " + str(Model.eletrificacao_transportes[n]) \
			+ "\nEletrificação Industria: " + str(Model.eletrificacao_industria[n]) \
			+ "\nEletrificação Residencial: " + str(Model.eletrificacao_residencial[n]) \
			+ "\nEletrificação Serviços: " + str(Model.eletrificacao_servicos[n]) \
			+ "\n" \
			+ "\nEficiência Agregada: " + str(stepify(Model.eficiencia_agregada_do_ano[n], 0.01))  \
			+ "\nEletricidade Renovável: " + str(stepify(Model.eletricidade_renovavel_do_ano[n], 0.01)) + " GWh"  \
			+ "\nEmissões Totais: " + str(stepify(Model.emissoes_totais_do_ano[n], 0.01)) + " kg CO2"  \
			+ "\nÍndice de Felicidade dos Cidadãos: " + str(stepify(Model.utilidade_do_ano[n], 0.0001)) + "[/indent]" \
			+ "\n\n\n[/indent]"

func _on_FecharEscreverFicheiro_pressed():
	get_node("FileWritePopup").hide()


func _on_MaisDetalhes_pressed():
	get_node("PastDataPopup").popup()


func _on_FecharPast_pressed():
	get_node("PastDataPopup").hide()
	

func create_politics():
	var politica_class = load("res://Politica.gd")
	var p1 = politica_class.new()
	var p2 = politica_class.new()
	var p3 = politica_class.new()
	var p4 = politica_class.new()
	var p5 = politica_class.new()
	var p6 = politica_class.new()
	var p7 = politica_class.new()
	var p8 = politica_class.new()
	var p9 = politica_class.new()
	

	p1.init_this("Eletrificação dos Transportes", 400, 0.7, ["Transport", "Service"], "Transports", [3,5])
	politics.push_back(p1)
	
	p2.init_this("Eletrificação da Indústria", 100, 0.9, ["Industry"], "Industry", [1,3])
	politics.push_back(p2)
	
	p3.init_this("Eletrificação dos Serviços", 250, 0.6, ["Service"], "Services", [2,3])
	politics.push_back(p3)
	
	p4.init_this("Carros Eletricos", 600, 0.4, ["Transport"], "Transports", [4,6])
	politics.push_back(p4)
	
	p5.init_this("Fabricas ecologicas", 350, 0.6, ["Industry"], "Industry", [2,4])
	politics.push_back(p5)
	
	p6.init_this("Casas eficientes", 280, 0.5, ["Service"],"Residential", [2,2])
	politics.push_back(p6)
	
	p7.init_this("Aumento Transportes", 1000, 0.8, ["Transport", "Service"], "Transports", [5,8])
	politics.push_back(p7)
	
	p8.init_this("Fabricas ecologicas II", 299, 0.7, ["Industry"], "Industry", [2,5])
	politics.push_back(p8)
	
	p9.init_this("Eletrificação cidades", 900, 0.8, ["Service", "Residential"], "Services", [4,4])
	politics.push_back(p9)
	politics.shuffle()
	filter_list("Transport")
	
func create_buttons_by_sector(politics_array):
	for i in range (politics_array.size()):
		if (politics_array[i].getType() == "Transports"):
			#Create Button
			var button = Button.new()
			button.set_size(Vector2(490,150))
			button.rect_min_size = Vector2(490,150)
			button.toggle_mode = true
			
			#Create fields
			var titleTxt = politics_array[i].getTitle()
			var priceTxt = politics_array[i].getPrice()
			var descArray = politics_array[i].getDesc()

			var titleField = RichTextLabel.new()
			titleField.set_size(Vector2(480,40))
			titleField.margin_left = 5
			titleField.margin_right = 487
			titleField.margin_top = 5
			titleField.margin_bottom = 50
			titleField.bbcode_enabled = true
			titleField.bbcode_text = "[center][b]" + titleTxt + "[/b][/center]"
			titleField.add_font_override("font", load("res://your_dynamic_font.tres"))
			titleField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(titleField)
			
			var priceField = RichTextLabel.new()
			priceField.set_size(Vector2(150,50))
			priceField.margin_left = 10
			priceField.margin_right = 165
			priceField.margin_top = 75
			priceField.margin_bottom = 130
			priceField.text = str(priceTxt) + "M"
			priceField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(priceField)
			
			var descField = RichTextLabel.new()
			descField.set_size(Vector2(215,100))
			descField.margin_left = 270
			descField.margin_right = 490
			descField.margin_top = 60
			descField.margin_bottom = 160
			
			for j in range(descArray.size()):
				descField.text += descArray[j] + "\n"
				
			descField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(descField)
			
			button.connect("pressed", self, "on_Politic_Button_pressed", [button])
			politics_dictionary[button] = politics_array[i]
			transports_politics.push_back(button)
		
		elif(politics_array[i].getType() == "Industry"):
			#Create Button
			var button = Button.new()
			button.set_size(Vector2(490,150))
			button.rect_min_size = Vector2(490,150)
			button.toggle_mode = true
			
			#Create fields
			var titleTxt = politics_array[i].getTitle()
			var priceTxt = politics_array[i].getPrice()
			var descArray = politics_array[i].getDesc()

			var titleField = RichTextLabel.new()
			titleField.set_size(Vector2(480,40))
			titleField.margin_left = 5
			titleField.margin_right = 487
			titleField.margin_top = 5
			titleField.margin_bottom = 50
			titleField.bbcode_enabled = true
			titleField.bbcode_text = "[center][b]" + titleTxt + "[/b][/center]"
			titleField.add_font_override("font", load("res://your_dynamic_font.tres"))
			titleField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(titleField)
			
			var priceField = RichTextLabel.new()
			priceField.set_size(Vector2(150,50))
			priceField.margin_left = 10
			priceField.margin_right = 165
			priceField.margin_top = 75
			priceField.margin_bottom = 130
			priceField.text = str(priceTxt) + "M"
			priceField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(priceField)
			
			var descField = RichTextLabel.new()
			descField.set_size(Vector2(215,100))
			descField.margin_left = 270
			descField.margin_right = 490
			descField.margin_top = 60
			descField.margin_bottom = 160
			
			for j in range(descArray.size()):
				descField.text += descArray[j] + "\n"
				
			descField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(descField)
			
			button.connect("pressed", self, "on_Politic_Button_pressed", [button])
			politics_dictionary[button] = politics_array[i]
			industry_politics.push_back(button)
			
		elif(politics_array[i].getType() == "Services"):
			#Create Button
			var button = Button.new()
			button.set_size(Vector2(490,150))
			button.rect_min_size = Vector2(490,150)
			button.toggle_mode = true
			
			#Create fields
			var titleTxt = politics_array[i].getTitle()
			var priceTxt = politics_array[i].getPrice()
			var descArray = politics_array[i].getDesc()

			var titleField = RichTextLabel.new()
			titleField.set_size(Vector2(480,40))
			titleField.margin_left = 5
			titleField.margin_right = 487
			titleField.margin_top = 5
			titleField.margin_bottom = 50
			titleField.bbcode_enabled = true
			titleField.bbcode_text = "[center][b]" + titleTxt + "[/b][/center]"
			titleField.add_font_override("font", load("res://your_dynamic_font.tres"))
			titleField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(titleField)
			
			var priceField = RichTextLabel.new()
			priceField.set_size(Vector2(150,50))
			priceField.margin_left = 10
			priceField.margin_right = 165
			priceField.margin_top = 75
			priceField.margin_bottom = 130
			priceField.text = str(priceTxt) + "M"
			priceField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(priceField)
			
			var descField = RichTextLabel.new()
			descField.set_size(Vector2(215,100))
			descField.margin_left = 270
			descField.margin_right = 490
			descField.margin_top = 60
			descField.margin_bottom = 160
			
			for j in range(descArray.size()):
				descField.text += descArray[j] + "\n"
				
			descField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(descField)
			
			button.connect("pressed", self, "on_Politic_Button_pressed", [button])
			politics_dictionary[button] = politics_array[i]
			services_politics.push_back(button)
			
		elif(politics_array[i].getType() == "Residential"):
			#Create Button
			var button = Button.new()
			button.set_size(Vector2(490,150))
			button.rect_min_size = Vector2(490,150)
			button.toggle_mode = true
			
			#Create fields
			var titleTxt = politics_array[i].getTitle()
			var priceTxt = politics_array[i].getPrice()
			var descArray = politics_array[i].getDesc()

			var titleField = RichTextLabel.new()
			titleField.set_size(Vector2(480,40))
			titleField.margin_left = 5
			titleField.margin_right = 487
			titleField.margin_top = 5
			titleField.margin_bottom = 50
			titleField.bbcode_enabled = true
			titleField.bbcode_text = "[center][b]" + titleTxt + "[/b][/center]"
			titleField.add_font_override("font", load("res://your_dynamic_font.tres"))
			titleField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(titleField)
			
			var priceField = RichTextLabel.new()
			priceField.set_size(Vector2(150,50))
			priceField.margin_left = 10
			priceField.margin_right = 165
			priceField.margin_top = 75
			priceField.margin_bottom = 130
			priceField.text = str(priceTxt) + "M"
			priceField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(priceField)
			
			var descField = RichTextLabel.new()
			descField.set_size(Vector2(215,100))
			descField.margin_left = 270
			descField.margin_right = 490
			descField.margin_top = 60
			descField.margin_bottom = 160
			
			for j in range(descArray.size()):
				descField.text += descArray[j] + "\n"
				
			descField.mouse_filter = MOUSE_FILTER_IGNORE
			button.add_child(descField)
			
			button.connect("pressed", self, "on_Politic_Button_pressed", [button])
			politics_dictionary[button] = politics_array[i]
			residential_politics.push_back(button)


func process_politic():
	
	for i in selected_politics:
		var temp_pol = politics_dictionary.get(i)
		var impactDictionary = temp_pol.getImpact()
		var politicType = temp_pol.getType()
		
		if(PlayerVariables.investment_renewables_percentage < 20.00):
			PlayerVariables.investment_renewables_percentage += impactDictionary.get("Ren")
		if(PlayerVariables.investment_renewables_percentage > 19.99):
			PlayerVariables.investment_renewables_percentage = 20.00
		
		if(politicType == "Transports"):
			if(PlayerVariables.electrification_by_sector_level_transportation < 11):
				PlayerVariables.electrification_by_sector_level_transportation = PlayerVariables.electrification_by_sector_level_transportation + impactDictionary.get("Ele")
		elif(politicType == "Industry"):
			if(PlayerVariables.electrification_by_sector_level_industry < 11):
				PlayerVariables.electrification_by_sector_level_industry = PlayerVariables.electrification_by_sector_level_industry + impactDictionary.get("Ele")
		elif(politicType == "Services"):
			if(PlayerVariables.electrification_by_sector_level_services < 11):
				PlayerVariables.electrification_by_sector_level_services = PlayerVariables.electrification_by_sector_level_services + impactDictionary.get("Ele")		
		elif(politicType == "Residential"):
			if(PlayerVariables.electrification_by_sector_level_residential < 11):
				PlayerVariables.electrification_by_sector_level_residential = PlayerVariables.electrification_by_sector_level_residential + impactDictionary.get("Ele")
		else:
			print("ERROR: @process_politics")
	


func clear_politics_selection():
	print(selected_politics)
	for i in range (selected_politics.size()):
		selected_politics[i].pressed = false
	selected_politics.clear()

func reduce_budget(cost):
	var new_budget = calculated_budget - cost
	if(new_budget > 0):
		calculated_budget = new_budget
		update_budget_text()
		return true
	else:
		print("NO Money")
		return false
		
func refund_to_budget(cost):
	var new_budget = calculated_budget + cost
	calculated_budget = new_budget
	update_budget_text()

func update_budget_text():
	get_node("ContainerDecisoes/Budget").text = "Orçamento: " + str(stepify(calculated_budget, 0.01)) + "M€"

func on_EconomyOptions_pressed(id):
	var txtType = get_node("ContainerDecisoes/economyOptions").get_item_text(id)
	filter_list(txtType)

func filter_list(txtType):
	var listNode = get_node("ContainerDecisoes/sc/ListBox")
	var listNode_items = listNode.get_children()
	for subNode in listNode_items:
		listNode.remove_child(subNode)
		
	if(txtType=="Transports"):
		show_politics_list(transports_politics)
	elif(txtType=="Industry"):
		show_politics_list(industry_politics)
	elif(txtType=="Services"):
		show_politics_list(services_politics)
	elif(txtType=="Residential"):
		show_politics_list(residential_politics)
	
		
#	var filteredArray = []
#	for item in politics:
#		if(item.getType() == txtType):
#			filteredArray.push_back(item)
#	update_decisions(filteredArray) 

func on_Politic_Button_pressed(button):
	var elements = button.get_children()
	var cost = elements[1].text
	
	if(button.pressed):
		var is_accepted = reduce_budget(float(cost))
		button.pressed = is_accepted
		if(is_accepted):
			selected_politics.push_back(button)
			print(button)
	else:
		refund_to_budget(float(cost))
		var indexToRemove = selected_politics.find(button)
		if (indexToRemove > -1):
			selected_politics.remove(indexToRemove)


func show_politics_list(elem):
	var listNode = get_node("ContainerDecisoes/sc/ListBox")	
	for item in elem:
		listNode.add_child(item)
