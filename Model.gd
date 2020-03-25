extends Node

# DOCUMENTO DE REFERÊNCIA:
# https://docs.google.com/document/d/1WcJScN2PTWMC52P5wOid80MY-UaYjiQW/edit

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 

# CONSTANTES (podem ser alteradas, resultando num jogo diferente)
var ANO_INICIAL = 2017

var POTENCIA_DO_ANO_ZERO_SOLAR = 100000 #???? #GW
var POTENCIA_DO_ANO_ZERO_VENTO= 100000 #????
var POTENCIA_DO_ANO_ZERO_BIOMASSA = 100000 #????

var POTENCIA_MAXIMA_SOLAR = 1000000 #????
var POTENCIA_MAXIMA_VENTO = 1000000 #????
var POTENCIA_MAXIMA_BIOMASSA= 1000000 #????

var CUSTO_POR_GIGAWATT_INSTALADO = 5000 #???? #euro/GW

var PERCENTAGEM_A_RETIRAR_DO_PIB = 0.02 #???? #valor decimal

var POPULACAO = 10000000 #????
var ALFA = 0.60 #???? #percentagem de população

var PERCENTAGEM_INPUT_SETAS = 1.0 #????

var EFICIENCIA_TRANSPORTES = 0.80 #???? #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA = 0.80 #????
var EFICIENCIA_RESIDENCIAL = 0.80 #????
var EFICIENCIA_SERVICOS = 0.80 #????

var FATOR_DE_EMISSAO_CARVAO = 0.70 #???? #Tons/TJ
var FATOR_DE_EMISSAO_PETROLEO = 0.70 #????
var FATOR_DE_EMISSAO_GAS_NATURAL = 0.70 #????

var FATOR_DE_PRODUCAO_SOLAR = 0.50 #????
var FATOR_DE_PRODUCAO_VENTO = 0.50 #????
var FATOR_DE_PRODUCAO_BIOMASSA = 0.50 #????
var FATOR_DE_PRODUCAO_HIDRO = 0.50 #????

var POTENCIA_ANUAL_HIDRO = 100000 #???? #GW

var INEFICIENCIA_PRIMARIO_PARA_FINAL = 1.1

var MAXIMO_PRODUZIDO_POR_GAS_NATURAL = 50000 #???? #Tons/TJ????????????????

var EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL = 0.55
var EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_CARVAO = 0.40


# VARIÁVEIS
var ano_atual_indice = 0
var ano_atual = ano_atual_indice + ANO_INICIAL

## VARS DECISOES 
var input_potencia_a_instalar = 0.0 #(Atenção à divisão de inteiros em GDScript)

var input_percentagem_tipo_economia_transportes = 0.0
var input_percentagem_tipo_economia_industria = 0.0
var input_percentagem_tipo_economia_residencial = 0.0
var input_percentagem_tipo_economia_servicos = 0.0

var input_percentagem_eletrificacao_transportes = 0.0
var input_percentagem_eletrificacao_industria = 0.0
var input_percentagem_eletrificacao_residencial = 0.0
var input_percentagem_eletrificacao_servicos = 0.0

## VARS 1)
var potencia_solar_instantanea = 0.0
var potencia_vento_instantanea = 0.0
var potencia_biomassa_instantanea = 0.0

var potencia_do_ano_solar = [POTENCIA_DO_ANO_ZERO_SOLAR]
var potencia_do_ano_vento = [POTENCIA_DO_ANO_ZERO_VENTO]
var potencia_do_ano_biomassa = [POTENCIA_DO_ANO_ZERO_BIOMASSA]

## VARS 2)
var custo_total_do_ano = [0.0] #valor 2017????
var custo_do_ano_solar = [0.0]
var custo_do_ano_vento = [0.0]
var custo_do_ano_biomassa = [0.0]

## VARS 3)
var pib_do_ano = [900000000.0] #valor 2017????
var investimento_total_do_ano = [0.0]
var investimento_para_capital_do_ano = [0.0]

## VARS 4)
var capital_do_ano = [5000000.0] #valor 2017 necessario! ????

## VARS 5)
var labour_do_ano = [0] 

## VARS 6) e 15)
var tfp_do_ano = [0.00]
var eficiencia_agregada_do_ano = [0.7] #valor 2017 necessario! ???? percentagem decimal #USADA NO PASSO 15)

## VARS 8)
var exergia_util_do_ano = [0.0] #TJ

## VARS 9)
var exergia_final_do_ano = [0.0] #TJ

## VARS 10)
var shares_exergia_final_transportes_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_industria_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_residencial_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_servicos_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal

## VARS 11)
var shares_exergia_final_transportes_carvao_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_industria_carvao_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_residencial_carvao_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_servicos_carvao_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal

var shares_exergia_final_transportes_petroleo_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_industria_petroleo_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_residencial_petroleo_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_servicos_petroleo_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal

var shares_exergia_final_transportes_eletricidade_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_industria_eletricidade_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_residencial_eletricidade_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_servicos_eletricidade_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal

var shares_exergia_final_transportes_gas_natural_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_industria_gas_natural_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_residencial_gas_natural_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal
var shares_exergia_final_servicos_gas_natural_do_ano = [0.25] #valor 2017 necessario! ???? percentagem decimal

# VARS 12)
var exergia_final_transportes_do_ano = [0.00] #TJ
var exergia_final_industria_do_ano = [0.00]
var exergia_final_residencial_do_ano = [0.00]
var exergia_final_servicos_do_ano = [0.00]

# VARS 13)
var exergia_final_transportes_carvao_do_ano = [0.00] #TJ
var exergia_final_industria_carvao_do_ano = [0.00]
var exergia_final_residencial_carvao_do_ano = [0.00]
var exergia_final_servicos_carvao_do_ano = [0.00]

var exergia_final_transportes_petroleo_do_ano = [0.00]
var exergia_final_industria_petroleo_do_ano = [0.00]
var exergia_final_residencial_petroleo_do_ano = [0.00]
var exergia_final_servicos_petroleo_do_ano = [0.00]

var exergia_final_transportes_eletricidade_do_ano = [0.00]
var exergia_final_industria_eletricidade_do_ano = [0.00]
var exergia_final_residencial_eletricidade_do_ano = [0.00]
var exergia_final_servicos_eletricidade_do_ano = [0.00]

var exergia_final_transportes_gas_natural_do_ano = [0.00]
var exergia_final_industria_gas_natural_do_ano = [0.00]
var exergia_final_residencial_gas_natural_do_ano = [0.00]
var exergia_final_servicos_gas_natural_do_ano = [0.00]

# VARS 14
var exergia_util_transportes_carvao_do_ano = [0.00] #TJ
var exergia_util_industria_carvao_do_ano = [0.00]
var exergia_util_residencial_carvao_do_ano = [0.00]
var exergia_util_servicos_carvao_do_ano = [0.00]

var exergia_util_transportes_petroleo_do_ano = [0.00]
var exergia_util_industria_petroleo_do_ano = [0.00]
var exergia_util_residencial_petroleo_do_ano = [0.00]
var exergia_util_servicos_petroleo_do_ano = [0.00]

var exergia_util_transportes_eletricidade_do_ano = [0.00]
var exergia_util_industria_eletricidade_do_ano = [0.00]
var exergia_util_residencial_eletricidade_do_ano = [0.00]
var exergia_util_servicos_eletricidade_do_ano = [0.00]

var exergia_util_transportes_gas_natural_do_ano = [0.00]
var exergia_util_industria_gas_natural_do_ano = [0.00]
var exergia_util_residencial_gas_natural_do_ano = [0.00]
var exergia_util_servicos_gas_natural_do_ano = [0.00]


var exergia_util_transportes_do_ano = [0.00] #TJ
var exergia_util_industria_do_ano = [0.00]
var exergia_util_residencial_do_ano = [0.00]
var exergia_util_servicos_do_ano = [0.00]


var eficiencia_transportes_do_ano = [0.00] #percentagem decimal
var eficiencia_industria_do_ano = [0.00]
var eficiencia_residencial_do_ano = [0.00]
var eficiencia_servicos_do_ano = [0.00]

# VARS 16
var exergia_final_carvao_do_ano = [0.00] #TJ
var exergia_final_petroleo_do_ano = [0.00]
var exergia_final_eletricidade_do_ano = [0.00]
var exergia_final_gas_natural_do_ano = [0.00]

# VARS 17
var emissoes_CO2_carvao_do_ano = [0.0] #Tons
var emissoes_CO2_petroleo_do_ano = [0.0]
var emissoes_CO2_gas_natural_do_ano = [0.0]

var emissoes_totais_sem_eletricidade = [0.0]

# VARS 19
var eletricidade_renovavel_do_ano = [0.0] #GW

# VARS 20
var eletricidade_nao_renovavel_do_ano = [0.0] #GW

# VARS 21 e 22)
var emissoes_nao_renovaveis_do_ano = [0.0]

# VARS 23)
var emissoes_totais_do_ano = [0.0]

# VARS 24)
var consumo_do_ano = [0.0]

# VARS 25)
var utilidade_do_ano = [0.0]

# FUNÇÕES
func indice_do_ano(ano):
	return ano - ANO_INICIAL
	
# FUNCS 0) - PREPARAÇÃO
func mudar_de_ano():
	ano_atual += 1
	ano_atual_indice += 1

	#após execução desta função, acede-se aos valores do ano anterior presentes em vetores com um .back(),
	#desde que não tenha sido já colocado o valor do ano ano atual
	

# FUNCS 1) - POTENCIA ELETRICA ACUMULADA POR FONTE RENOVÁVEL (gigawatts)
# TODO: Evitar
func calcular_distribuicao_por_fonte():
	
	var potencia_maxima_solar_alcancada = (potencia_do_ano_solar.back() >= POTENCIA_MAXIMA_SOLAR)
	var potencia_maxima_vento_alcancada = (potencia_do_ano_vento.back() >= POTENCIA_MAXIMA_VENTO)
	var potencia_maxima_biomassa_alcancada = (potencia_do_ano_biomassa.back() >= POTENCIA_MAXIMA_BIOMASSA)
	
	#111
	potencia_solar_instantanea = 0.0
	potencia_vento_instantanea = 0.0
	potencia_biomassa_instantanea = 0.0
	
	if(!potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada && !potencia_maxima_biomassa_alcancada): #000
		potencia_solar_instantanea = input_potencia_a_instalar / 3
		potencia_vento_instantanea = input_potencia_a_instalar / 3
		potencia_biomassa_instantanea = input_potencia_a_instalar / 3
	elif(!potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada && potencia_maxima_biomassa_alcancada): #001
		potencia_solar_instantanea = input_potencia_a_instalar / 2
		potencia_vento_instantanea = input_potencia_a_instalar / 2
	elif(!potencia_maxima_solar_alcancada && potencia_maxima_vento_alcancada && potencia_maxima_biomassa_alcancada): #011
		potencia_solar_instantanea = input_potencia_a_instalar
	elif(potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada && !potencia_maxima_biomassa_alcancada): #100
		potencia_vento_instantanea = input_potencia_a_instalar / 2
		potencia_biomassa_instantanea = input_potencia_a_instalar / 2
	elif(potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada && potencia_maxima_biomassa_alcancada): #101
		potencia_vento_instantanea = input_potencia_a_instalar
	elif(!potencia_maxima_solar_alcancada && potencia_maxima_vento_alcancada && !potencia_maxima_biomassa_alcancada): #010
		potencia_solar_instantanea = input_potencia_a_instalar / 2
		potencia_biomassa_instantanea = input_potencia_a_instalar / 2
	elif(potencia_maxima_solar_alcancada && potencia_maxima_vento_alcancada && !potencia_maxima_biomassa_alcancada): #110
		potencia_biomassa_instantanea = input_potencia_a_instalar
	
# Prevenção da quebra dos limites máximos
	if((potencia_do_ano_solar.back() + potencia_solar_instantanea) > POTENCIA_MAXIMA_SOLAR):
		potencia_solar_instantanea = POTENCIA_MAXIMA_SOLAR - potencia_do_ano_solar.back()
	if((potencia_do_ano_vento.back() + potencia_vento_instantanea) > POTENCIA_MAXIMA_VENTO):
		potencia_vento_instantanea = POTENCIA_MAXIMA_VENTO - potencia_do_ano_vento.back()
	if((potencia_do_ano_biomassa.back() + potencia_biomassa_instantanea) > POTENCIA_MAXIMA_BIOMASSA):
		potencia_biomassa_instantanea = POTENCIA_MAXIMA_BIOMASSA - potencia_do_ano_biomassa.back()
	
# Soma dos valores instantâneos aos do ano anterior e adição ao vetor respetivo
	potencia_do_ano_solar.push_back(potencia_do_ano_solar.back() + potencia_solar_instantanea)
	potencia_do_ano_vento.push_back(potencia_do_ano_vento.back() + potencia_vento_instantanea)
	potencia_do_ano_biomassa.push_back(potencia_do_ano_biomassa.back() + potencia_biomassa_instantanea)
	
	
# FUNCS 2) - CUSTO DA POTÊNCIA (euros)
func calcular_custo():
	
	var custo_solar_instantaneo = potencia_solar_instantanea * CUSTO_POR_GIGAWATT_INSTALADO
	var custo_vento_instantaneo = potencia_vento_instantanea * CUSTO_POR_GIGAWATT_INSTALADO
	var custo_biomassa_instantaneo = potencia_biomassa_instantanea * CUSTO_POR_GIGAWATT_INSTALADO
	
	custo_do_ano_solar.push_back(custo_solar_instantaneo)
	custo_do_ano_vento.push_back(custo_vento_instantaneo)
	custo_do_ano_biomassa.push_back(custo_biomassa_instantaneo)
	
	custo_total_do_ano.push_back(custo_solar_instantaneo + custo_vento_instantaneo + custo_biomassa_instantaneo)
	

# FUNCS 3) - INVESTIMENTO (euros)
func calcular_investimento():
	
	var investimento_total_instantaneo = PERCENTAGEM_A_RETIRAR_DO_PIB * pib_do_ano.back()
	
	investimento_total_do_ano.push_back(investimento_total_instantaneo)
	investimento_para_capital_do_ano.push_back(investimento_total_instantaneo - custo_total_do_ano[ano_atual_indice])
	
# FUNCS 4) - CAPITAL (euros?)
func calcular_capital():
	capital_do_ano.push_back(capital_do_ano.back() + investimento_para_capital_do_ano[ano_atual_indice])

# FUNCS 5) - LABOUR (nº de pessoas)
func calcular_labour():	
	labour_do_ano.push_back(ALFA * POPULACAO)
	
# FUNCS 6) - TOTAL FACTOR PRODUTIVITY (TFP)
func calcular_tfp():	
	tfp_do_ano.push_back(1.87 * eficiencia_agregada_do_ano.back())
	
# FUNCS 7) - PIB (euros?)
func calcular_pib(): #????
	#TODO: "função que utiliza os valores de labour(t), capital(t), e tfp(t)"
	pib_do_ano.push_back(pib_do_ano.back() + 1000000) #FUNÇAO DUMMY
	
# FUNCS 8) - EXERGIA ÚTIL ANUAL (1 terajoule = 1 euro)
func calcular_exergia_util():
	exergia_util_do_ano.push_back(pib_do_ano[ano_atual_indice])
	
# FUNCS 9) - EXERGIA FINAL ANUAL (terajoule)
func calcular_exergia_final():
	exergia_final_do_ano.push_back(exergia_util_do_ano[ano_atual_indice] / eficiencia_agregada_do_ano.back())

# FUNCS 10) - SHARES DE EXERGIA FINAL POR SETOR (percentagem decimal)
func calcular_shares_de_exergia_final_por_setor():
	var shares_transportes = shares_exergia_final_transportes_do_ano.back() + input_percentagem_tipo_economia_transportes
	var shares_industria = shares_exergia_final_industria_do_ano.back() + input_percentagem_tipo_economia_industria
	var shares_residencial = shares_exergia_final_residencial_do_ano.back() + input_percentagem_tipo_economia_residencial
	var shares_servicos = shares_exergia_final_servicos_do_ano.back() + input_percentagem_tipo_economia_servicos
	
	if(shares_transportes < 0.00):
		shares_transportes = 0.00
	if(shares_industria < 0.00):
		shares_industria = 0.00
	if(shares_residencial < 0.00):
		shares_residencial = 0.00
	if(shares_servicos < 0.00):
		shares_servicos = 0.00
	
	var soma = shares_transportes + shares_industria + shares_residencial + shares_servicos
	
	#normalização a 1.00 das percentagens
	if(soma != 1.00):
		stepify((shares_transportes / float(soma)), 0.01)
		stepify((shares_industria / float(soma)), 0.01)
		stepify((shares_residencial / float(soma)), 0.01)
		stepify((shares_servicos / float(soma)), 0.01)
		
	
	soma = shares_transportes + shares_industria + shares_residencial + shares_servicos
	
	#acerto de possível excedente ou défice
	if(soma != 1.00):
		var diferenca = 1.00 - soma
		var rand = randi()%5 + 1 # calcula um número inteiro aleatório entre 1 e 4
		match rand:
			1: 
				shares_transportes += diferenca
			2: 
				shares_industria += diferenca
			3: 
				shares_residencial += diferenca
			4: 
				shares_servicos += diferenca
	
	shares_exergia_final_transportes_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_do_ano.push_back(shares_servicos)		
		

# FUNCS 11) - SHARES DE EXERGIA FINAL POR SETOR POR CARRIER (percentagem decimal)
func calcular_shares_de_exergia_final_por_setor_por_carrier():
	#ELETRICIDADE
	var shares_transportes = shares_exergia_final_transportes_eletricidade_do_ano.back() + input_percentagem_eletrificacao_transportes
	var shares_industria = shares_exergia_final_industria_eletricidade_do_ano.back() + input_percentagem_eletrificacao_industria
	var shares_residencial = shares_exergia_final_residencial_eletricidade_do_ano.back() + input_percentagem_eletrificacao_residencial
	var shares_servicos = shares_exergia_final_servicos_eletricidade_do_ano.back() + input_percentagem_eletrificacao_servicos

	if(shares_transportes < 0.00):
		shares_transportes = 0.00
	if(shares_industria < 0.00):
		shares_industria = 0.00
	if(shares_residencial < 0.00):
		shares_residencial = 0.00
	if(shares_servicos < 0.00):
		shares_servicos = 0.00

	var soma = shares_transportes + shares_industria + shares_residencial + shares_servicos
	
	#normalização a 1.00 das percentagens
	if(soma != 1.00):
		stepify((shares_transportes / float(soma)), 0.01)
		stepify((shares_industria / float(soma)), 0.01)
		stepify((shares_residencial / float(soma)), 0.01)
		stepify((shares_servicos / float(soma)), 0.01)
		
	
	soma = shares_transportes + shares_industria + shares_residencial + shares_servicos
	
	#acerto de possível excedente ou défice
	if(soma != 1.00):
		var diferenca = 1.00 - soma
		var rand = randi()%5 + 1 # calcula um número inteiro aleatório entre 1 e 4
		match rand:
			1: 
				shares_transportes += diferenca
			2: 
				shares_industria += diferenca
			3: 
				shares_residencial += diferenca
			4: 
				shares_servicos += diferenca
	
	
	shares_exergia_final_transportes_eletricidade_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_eletricidade_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_eletricidade_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_eletricidade_do_ano.push_back(shares_servicos)

	#CARVAO
	#% Ex. F. (por setor) (carvão) (t) =
	# = [ % Ex. F. (por setor) (carvão) (t-1) * % Ex. F. (por setor) (eletricidade) (t) )  ]  /   [ 1 - % Ex. F. (por setor) (eletricidade) (t-1) ]

	shares_transportes = ( shares_exergia_final_transportes_carvao_do_ano.back() * shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_industria = ( shares_exergia_final_industria_carvao_do_ano.back() * shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_residencial = ( shares_exergia_final_residencial_carvao_do_ano.back() * shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_servicos = ( shares_exergia_final_servicos_carvao_do_ano.back() * shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice - 1] )

	shares_exergia_final_transportes_carvao_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_carvao_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_carvao_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_carvao_do_ano.push_back(shares_servicos)

	#PETROLEO
	shares_transportes = ( shares_exergia_final_transportes_petroleo_do_ano.back() * shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_industria = ( shares_exergia_final_industria_petroleo_do_ano.back() * shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_residencial = ( shares_exergia_final_residencial_petroleo_do_ano.back() * shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_servicos = ( shares_exergia_final_servicos_petroleo_do_ano.back() * shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice - 1] )

	shares_exergia_final_transportes_petroleo_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_petroleo_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_petroleo_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_petroleo_do_ano.push_back(shares_servicos)	

	#GÁS NATURAL
	shares_transportes = ( shares_exergia_final_transportes_gas_natural_do_ano.back() * shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_transportes_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_industria = ( shares_exergia_final_industria_gas_natural_do_ano.back() * shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_industria_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_residencial = ( shares_exergia_final_residencial_gas_natural_do_ano.back() * shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_residencial_eletricidade_do_ano[ano_atual_indice - 1] )
	shares_servicos = ( shares_exergia_final_servicos_gas_natural_do_ano.back() * shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice] ) / ( 1 - shares_exergia_final_servicos_eletricidade_do_ano[ano_atual_indice - 1] )

	shares_exergia_final_transportes_gas_natural_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_gas_natural_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_gas_natural_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_gas_natural_do_ano.push_back(shares_servicos)	


# FUNCS 12) - EXERGIA FINAL POR SETOR (terajoules)
func calcular_valores_absolutos_de_exergia_final_por_setor():
	exergia_final_transportes_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_do_ano)
	exergia_final_industria_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_do_ano)
	exergia_final_residencial_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_do_ano)
	exergia_final_servicos_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_do_ano)

# FUNCS 13) - EXERGIA FINAL POR SETOR POR CARRIER (terajoules)
func calcular_valores_absolutos_de_exergia_final_por_setor_por_carrier():
	exergia_final_transportes_eletricidade_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_eletricidade_do_ano)
	exergia_final_industria_eletricidade_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_eletricidade_do_ano)
	exergia_final_residencial_eletricidade_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_eletricidade_do_ano)
	exergia_final_servicos_eletricidade_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_eletricidade_do_ano)

	exergia_final_transportes_carvao_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_carvao_do_ano)
	exergia_final_industria_carvao_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_carvao_do_ano)
	exergia_final_residencial_carvao_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_carvao_do_ano)
	exergia_final_servicos_carvao_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_carvao_do_ano)

	exergia_final_transportes_petroleo_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_petroleo_do_ano)
	exergia_final_industria_petroleo_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_petroleo_do_ano)
	exergia_final_residencial_petroleo_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_petroleo_do_ano)
	exergia_final_servicos_petroleo_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_petroleo_do_ano)	

	exergia_final_transportes_gas_natural_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_gas_natural_do_ano)
	exergia_final_industria_gas_natural_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_gas_natural_do_ano)
	exergia_final_residencial_gas_natural_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_gas_natural_do_ano)
	exergia_final_servicos_gas_natural_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_gas_natural_do_ano)
	
# FUNCS 14) - EFICIÊNCIA POR SETOR (percentagem decimal)
func calcular_eficiencia_por_setor(): 
	exergia_util_transportes_eletricidade_do_ano.push_back(exergia_util_transportes_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES)
	exergia_util_industria_eletricidade_do_ano.push_back(exergia_util_industria_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA)
	exergia_util_residencial_eletricidade_do_ano.push_back(exergia_util_residencial_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL)
	exergia_util_servicos_eletricidade_do_ano.push_back(exergia_util_servicos_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS)

	exergia_util_transportes_carvao_do_ano.push_back(exergia_util_transportes_carvao_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES)
	exergia_util_industria_carvao_do_ano.push_back(exergia_util_industria_carvao_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA)
	exergia_util_residencial_carvao_do_ano.push_back(exergia_util_residencial_carvao_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL)
	exergia_util_servicos_carvao_do_ano.push_back(exergia_util_servicos_carvao_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS)	

	exergia_util_transportes_petroleo_do_ano.push_back(exergia_util_transportes_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES)
	exergia_util_industria_petroleo_do_ano.push_back(exergia_util_industria_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA)
	exergia_util_residencial_petroleo_do_ano.push_back(exergia_util_residencial_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL)
	exergia_util_servicos_petroleo_do_ano.push_back(exergia_util_servicos_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS)
	
	exergia_util_transportes_gas_natural_do_ano.push_back(exergia_util_transportes_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES)
	exergia_util_industria_gas_natural_do_ano.push_back(exergia_util_industria_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA)
	exergia_util_residencial_gas_natural_do_ano.push_back(exergia_util_residencial_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL)
	exergia_util_servicos_gas_natural_do_ano.push_back(exergia_util_servicos_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS)


	exergia_util_transportes_do_ano.push_back(exergia_util_transportes_eletricidade_do_ano[ano_atual_indice] + exergia_util_transportes_carvao_do_ano[ano_atual_indice] + exergia_util_transportes_petroleo_do_ano[ano_atual_indice] + exergia_util_transportes_gas_natural_do_ano[ano_atual_indice])
	exergia_util_industria_do_ano.push_back(exergia_util_industria_eletricidade_do_ano[ano_atual_indice] + exergia_util_industria_carvao_do_ano[ano_atual_indice] + exergia_util_industria_petroleo_do_ano[ano_atual_indice] + exergia_util_transportes_gas_natural_do_ano[ano_atual_indice])
	exergia_util_residencial_do_ano.push_back(exergia_util_residencial_eletricidade_do_ano[ano_atual_indice] + exergia_util_residencial_carvao_do_ano[ano_atual_indice] + exergia_util_residencial_petroleo_do_ano[ano_atual_indice] + exergia_util_residencial_gas_natural_do_ano[ano_atual_indice])
	exergia_util_servicos_do_ano.push_back(exergia_util_servicos_eletricidade_do_ano[ano_atual_indice] + exergia_util_servicos_carvao_do_ano[ano_atual_indice] + exergia_util_servicos_petroleo_do_ano[ano_atual_indice] + exergia_util_servicos_gas_natural_do_ano[ano_atual_indice])


	eficiencia_transportes_do_ano.push_back(exergia_util_transportes_do_ano[ano_atual_indice] / exergia_final_transportes_do_ano[ano_atual_indice])
	eficiencia_industria_do_ano.push_back(exergia_util_industria_do_ano[ano_atual_indice] / exergia_final_industria_do_ano[ano_atual_indice])
	eficiencia_residencial_do_ano.push_back(exergia_util_residencial_do_ano[ano_atual_indice] / exergia_final_residencial_do_ano[ano_atual_indice])
	eficiencia_servicos_do_ano.push_back(exergia_util_servicos_do_ano[ano_atual_indice] / exergia_final_servicos_do_ano[ano_atual_indice])
	
# FUNCS 15) - EFICIÊNCIA AGREGADA (para cálculos em anos futuros)
func calcular_eficiencia_agregada():
	#atualização dos valores anteriormente calculados, usando os somatórios das partes
	exergia_util_do_ano[ano_atual_indice] = exergia_util_transportes_do_ano[ano_atual_indice] + exergia_util_industria_do_ano[ano_atual_indice] + exergia_util_residencial_do_ano[ano_atual_indice] + exergia_util_servicos_do_ano[ano_atual_indice]
	exergia_final_do_ano[ano_atual_indice] = exergia_final_transportes_do_ano[ano_atual_indice] + exergia_final_industria_do_ano[ano_atual_indice] + exergia_final_residencial_do_ano[ano_atual_indice] + exergia_final_servicos_do_ano[ano_atual_indice]
	 
	#calculo da eficiencia agregada usando valores atualizados puishback
	eficiencia_agregada_do_ano.push_back(exergia_util_do_ano[ano_atual_indice] / exergia_final_do_ano[ano_atual_indice])

# FUNCS 16) - EXERGIA FINAL POR CARRIER
func calcular_valores_absolutos_de_exergia_final_por_carrier():
	exergia_final_eletricidade_do_ano.push_back(exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] + exergia_final_industria_eletricidade_do_ano[ano_atual_indice] + exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] + exergia_final_servicos_eletricidade_do_ano[ano_atual_indice])
	exergia_final_carvao_do_ano.push_back(exergia_final_transportes_carvao_do_ano[ano_atual_indice] + exergia_final_industria_carvao_do_ano[ano_atual_indice] + exergia_final_residencial_carvao_do_ano[ano_atual_indice] + exergia_final_servicos_carvao_do_ano[ano_atual_indice])
	exergia_final_petroleo_do_ano.push_back(exergia_final_transportes_petroleo_do_ano[ano_atual_indice] + exergia_final_industria_petroleo_do_ano[ano_atual_indice] + exergia_final_residencial_petroleo_do_ano[ano_atual_indice] + exergia_final_servicos_petroleo_do_ano[ano_atual_indice])
	exergia_final_gas_natural_do_ano.push_back(exergia_final_transportes_gas_natural_do_ano[ano_atual_indice] + exergia_final_industria_gas_natural_do_ano[ano_atual_indice] + exergia_final_residencial_gas_natural_do_ano[ano_atual_indice] + exergia_final_servicos_gas_natural_do_ano[ano_atual_indice])

# FUNCS 17) - EMISSÕES DE CO2 POR CARRIER (exceto eletricidade) (não há passo 18)
func calcular_emissoes_CO2_carvao_petroleo_gas_natural():
	emissoes_CO2_carvao_do_ano.push_back(exergia_final_carvao_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_CARVAO)
	emissoes_CO2_petroleo_do_ano.push_back(exergia_final_petroleo_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_PETROLEO)
	emissoes_CO2_gas_natural_do_ano.push_back(exergia_final_gas_natural_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_GAS_NATURAL)
	
	emissoes_totais_sem_eletricidade.push_back(emissoes_CO2_carvao_do_ano.back() + emissoes_CO2_petroleo_do_ano.back() + emissoes_CO2_gas_natural_do_ano.back())

# FUNCS 19) - ELETRICIDADE VINDA DE FONTES RENOVÁVEIS (i.e. emissões zero) (gigawatts)
func calcular_eletricidade_de_fontes_renovaveis():
	var eletricidade_solar = potencia_do_ano_solar[ano_atual_indice] * FATOR_DE_PRODUCAO_SOLAR
	var eletricidade_vento = potencia_do_ano_vento[ano_atual_indice] * FATOR_DE_PRODUCAO_VENTO
	var eletricidade_biomassa = potencia_do_ano_biomassa[ano_atual_indice] * FATOR_DE_PRODUCAO_BIOMASSA
	var eletricidade_hidro = POTENCIA_ANUAL_HIDRO * FATOR_DE_PRODUCAO_HIDRO

	eletricidade_renovavel_do_ano.push_back(eletricidade_solar + eletricidade_vento + eletricidade_biomassa + eletricidade_hidro)

# FUNCS 20) - ELETRICIDADE NÃO RENOVÁVEL (gigawatts)
#TODO: Confirmar se é necessário conversão de unidades (eletricidade)
func calcular_eletricidade_nao_renovavel():
	eletricidade_nao_renovavel_do_ano.push_front((exergia_final_eletricidade_do_ano[ano_atual_indice] * INEFICIENCIA_PRIMARIO_PARA_FINAL) - eletricidade_renovavel_do_ano[ano_atual_indice])


# FUNCS 21) e 22) - EMISSÕES NÃO RENOVÁVEIS (Tons)
func calcular_emissoes_nao_renovaveis():
	if(eletricidade_nao_renovavel_do_ano[ano_atual_indice] <= 0.00):
		print("Eletricidade 100% renovável!")
		emissoes_nao_renovaveis_do_ano.push_back(0)
	elif(eletricidade_nao_renovavel_do_ano[ano_atual_indice] <= MAXIMO_PRODUZIDO_POR_GAS_NATURAL):
		emissoes_nao_renovaveis_do_ano.push_back((eletricidade_nao_renovavel_do_ano[ano_atual_indice] / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL) * FATOR_DE_EMISSAO_GAS_NATURAL)
	else:
		emissoes_nao_renovaveis_do_ano.push_back(( (MAXIMO_PRODUZIDO_POR_GAS_NATURAL / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL) * FATOR_DE_EMISSAO_GAS_NATURAL ) + ( ( (eletricidade_nao_renovavel_do_ano[ano_atual_indice] - MAXIMO_PRODUZIDO_POR_GAS_NATURAL) / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_CARVAO ) * FATOR_DE_EMISSAO_CARVAO)) 


# FUNCS 23) - EMISSÕES TOTAIS (um dos objetivos do jogo) (Toneladas)
func calcular_emissoes_totais():
	emissoes_totais_do_ano.push_back(emissoes_totais_sem_eletricidade[ano_atual_indice] + emissoes_nao_renovaveis_do_ano[ano_atual_indice])

# FUNCS 24) - CONSUMO (euros?)
func calcular_consumo():
	consumo_do_ano.push_back(pib_do_ano[ano_atual_indice] - investimento_total_do_ano[ano_atual_indice])

# FUNCS 25) - UTILIDADE (Felicidade dos cidadãos; um dos objetivos do jogo)
func calcular_utilidade():
	#TODO: "função que utiliza os valores de consumo(t) e emissoes totais(t)
	utilidade_do_ano.push_back((consumo_do_ano[ano_atual_indice] + emissoes_totais_do_ano[ano_atual_indice]) * 0.01) #FUNÇAO DUMMY