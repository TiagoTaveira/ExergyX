# Scientific model, the mathematical functions needed by the game
# Developed by:
# - Prof. Tânia Sousa
# - João Santos
# - Laura Felício
# - André Fidalgo Silva

extends Node

# DOCUMENTO DE REFERÊNCIA:
# https://docs.google.com/document/d/1WcJScN2PTWMC52P5wOid80MY-UaYjiQW/edit


# Chamado quando o node é colocado na scene tree pela primeira vez.
func _ready():
	randomize()

# Chamado a cada frame. 'delta' é o tempo que passou desde a última frame
#func _process(delta):
#	pass

# 

# CONSTANTES (podem ser alteradas, resultando num jogo diferente sem necessidade de o reprogramar)
var ANO_INICIAL = 2011

var POTENCIA_MAXIMA_SOLAR = 18.6 #GW
var POTENCIA_MAXIMA_VENTO = 15.0
var POTENCIA_MAXIMA_VENTO_OFFSHORE = 10

var CUSTO_POR_GIGAWATT_INSTALADO_SOLAR = 995000000 #euro/GW
var CUSTO_POR_GIGAWATT_INSTALADO_VENTO = 1231000000
var CUSTO_POR_GIGAWATT_INSTALADO_VENTO_OFFSHORE = 3581000000

var CUSTO_POR_GIGAWATT_INSTALADO = 1936 #euro/GW #esta é uma média dos valores acima, para apresentação estatística. Os valores a usar são os acima.

var PERCENTAGEM_A_RETIRAR_DO_PIB = 0.16 #cenário pessimista

var POPULACAO =  6800505 #2014
var ALFA = 1270 #cenário pessimista
var HORAS_POR_ANO = 8760 #24 * 365

var PERCENTAGEM_INPUT_SETAS = 0.005 #0.5% (A CONFIRMAR)

var EFICIENCIA_TRANSPORTES = 0.1329 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA = 0.3799
var EFICIENCIA_RESIDENCIAL = 0.1209
var EFICIENCIA_SERVICOS = 0.1529

var EFICIENCIA_TRANSPORTES_ELETRICIDADE = 0.88 #na passagem de exergia final para útil
var EFICIENCIA_TRANSPORTES_CARVAO = 0.00 #na passagem de exergia final para útil #Nota tese: ASSUMIMOS QUE HÁ SETORES QUE NAO VOLTARÃO A UTILIZAR CARVÃO
var EFICIENCIA_TRANSPORTES_PETROLEO = 0.13 #na passagem de exergia final para útil
var EFICIENCIA_TRANSPORTES_GAS_NATURAL = 0.08 #na passagem de exergia final para útil
var EFICIENCIA_TRANSPORTES_COMB_RENOVAVEIS = 0.13 #na passagem de exergia final para útil
var EFICIENCIA_TRANSPORTES_HEAT = 0.00 #na passagem de exergia final para útil

var EFICIENCIA_INDUSTRIA_ELETRICIDADE = 0.75 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA_CARVAO = 0.39 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA_PETROLEO = 0.24 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA_GAS_NATURAL = 0.30 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA_COMB_RENOVAVEIS = 0.20 #na passagem de exergia final para útil
var EFICIENCIA_INDUSTRIA_HEAT = 0.27 #na passagem de exergia final para útil

var EFICIENCIA_RESIDENCIAL_ELETRICIDADE = 0.17 #na passagem de exergia final para útil
var EFICIENCIA_RESIDENCIAL_CARVAO = 0.00 #na passagem de exergia final para útil
var EFICIENCIA_RESIDENCIAL_PETROLEO = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_RESIDENCIAL_GAS_NATURAL = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_RESIDENCIAL_COMB_RENOVAVEIS = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_RESIDENCIAL_HEAT = 0.09 #na passagem de exergia final para útil

var EFICIENCIA_SERVICOS_ELETRICIDADE = 0.17 #na passagem de exergia final para útil
var EFICIENCIA_SERVICOS_CARVAO = 0.00 #na passagem de exergia final para útil
var EFICIENCIA_SERVICOS_PETROLEO = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_SERVICOS_GAS_NATURAL = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_SERVICOS_COMB_RENOVAVEIS = 0.09 #na passagem de exergia final para útil
var EFICIENCIA_SERVICOS_HEAT = 0.09 #na passagem de exergia final para útil


var FATOR_DE_EMISSAO_CARVAO = 94.6 * 1000 #kg CO2 / TJ
var FATOR_DE_EMISSAO_PETROLEO = 73.3 * 1000
var FATOR_DE_EMISSAO_GAS_NATURAL = 56.1 * 1000
var FATOR_DE_EMISSAO_COMB_RENOVAVEIS = 0.00 * 1000



var FATOR_DE_PRODUCAO_SOLAR = 0.1960
var FATOR_DE_PRODUCAO_VENTO = 0.2690
var FATOR_DE_PRODUCAO_VENTO_OFFSHORE = 0.2200
var FATOR_DE_PRODUCAO_HIDRO = 0.1180

var POTENCIA_ANUAL_HIDRO = 5.57 #GW

var INEFICIENCIA_PRIMARIO_PARA_FINAL = 1.1

var MAXIMO_PRODUZIDO_POR_GAS_NATURAL = 13550 #GWh

var EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL = 0.55
var EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_CARVAO = 0.40



# VALORES DO ANO ZERO (e.g. 2014)
var POTENCIA_DO_ANO_ZERO_SOLAR = 0.493 #GW
var POTENCIA_DO_ANO_ZERO_VENTO= 5.099
var POTENCIA_DO_ANO_ZERO_BIOMASSA = 0.653
var POTENCIA_DO_ANO_ZERO_VENTO_OFFSHORE = 0.5

var CUSTO_TOTAL_DO_ANO_ZERO = 0.00 #i.e. custo da potência de todas as fontes renováveis consideradas. Preencher se houver necessidade de mostrar ao jogador.
var CUSTO_DO_ANO_ZERO_SOLAR = 0.00
var CUSTO_DO_ANO_ZERO_VENTO = 0.00
var CUSTO_DO_ANO_ZERO_VENTO_OFFSHORE = 0.00

var PIB_DO_ANO_ZERO = 169.11 #milhares de milhões de euros
var ORCAMENTO_ANO_ZERO = PIB_DO_ANO_ZERO * 0.01
var CAPITAL_DO_ANO_ZERO = 532.63 #milhares de milhões de euros

var EFF1960 = 0.14 #Eficiência Agregada de 1960 (0.142140933352638) (João)
#var EFF1960 = 0.12 #Eficiência Agregada de 1960 (Laura)
#var EFICIENCIA_AGREGADA_DO_ANO_ZERO = 0.227 #(João)
var EFICIENCIA_AGREGADA_DO_ANO_ZERO = 0.2252 #22.52% (Laura)

var EXERGIA_FINAL_DO_ANO_ZERO = 688470.92 #TJ

var EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO = 241842.02 #TJ
var EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO = 256121.43 #TJ
var EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO = 111174.31 #TJ
var EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO = 79333.15 #TJ

var SHARES_EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO = 0.3513 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO = 0.3720 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO = 0.1615 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO = 0.1152 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_CARVAO_DO_ANO_ZERO = 0.00 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_CARVAO_DO_ANO_ZERO = 0.0005713 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_CARVAO_DO_ANO_ZERO = 0.00 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_CARVAO_DO_ANO_ZERO = 0.00 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_PETROLEO_DO_ANO_ZERO = 0.9431958 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_PETROLEO_DO_ANO_ZERO = 0.2899247 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_PETROLEO_DO_ANO_ZERO = 0.0844385 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_PETROLEO_DO_ANO_ZERO =  0.1867464 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_ELETRICIDADE_DO_ANO_ZERO = 0.0044963 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_ELETRICIDADE_DO_ANO_ZERO = 0.2626102 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_ELETRICIDADE_DO_ANO_ZERO = 0.7604949 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_ELETRICIDADE_DO_ANO_ZERO =  0.385896 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_GAS_NATURAL_DO_ANO_ZERO = 0.0021784 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_GAS_NATURAL_DO_ANO_ZERO = 0.2041305 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_GAS_NATURAL_DO_ANO_ZERO = 0.118457 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_GAS_NATURAL_DO_ANO_ZERO = 0.1010773 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_COMB_RENOVAVEIS_DO_ANO_ZERO = 0.0501295 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_COMB_RENOVAVEIS_DO_ANO_ZERO = 0.1953363 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_COMB_RENOVAVEIS_DO_ANO_ZERO = 0.3507302 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_COMB_RENOVAVEIS_DO_ANO_ZERO = 0.0253863 #percentagem decimal

var SHARES_EXERGIA_FINAL_TRANSPORTES_HEAT_DO_ANO_ZERO = 0.00 #percentagem decimal
var SHARES_EXERGIA_FINAL_INDUSTRIA_HEAT_DO_ANO_ZERO = 0.0474271 #percentagem decimal
var SHARES_EXERGIA_FINAL_RESIDENCIAL_HEAT_DO_ANO_ZERO = 0.0055501 #percentagem decimal
var SHARES_EXERGIA_FINAL_SERVICOS_HEAT_DO_ANO_ZERO = 0.0112233 #percentagem decimal

var EXERGIA_FINAL_CARVAO_DO_ANO_ZERO = 146.32 #TJ
var EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO = 329820.48 #TJ
var EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO = 171581.67 #TJ
var EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO = 73443.77 #TJ

var UTILIDADE_DO_ANO_UM = 6606903717100.8291


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
var potencia_vento_offshore_instantanea = 0.0

var potencia_do_ano_solar = [POTENCIA_DO_ANO_ZERO_SOLAR]
var potencia_do_ano_vento = [POTENCIA_DO_ANO_ZERO_VENTO]
var potencia_do_ano_vento_offshore = [POTENCIA_DO_ANO_ZERO_VENTO_OFFSHORE]

## VARS 2)
var custo_total_do_ano = [CUSTO_TOTAL_DO_ANO_ZERO]
var custo_do_ano_solar = [CUSTO_DO_ANO_ZERO_SOLAR]
var custo_do_ano_vento = [CUSTO_DO_ANO_ZERO_VENTO]
var custo_do_ano_vento_offshore = [CUSTO_DO_ANO_ZERO_VENTO_OFFSHORE]

## VARS 3)
var pib_do_ano = [PIB_DO_ANO_ZERO]
var investimento_total_do_ano = [0.0]
var investimento_para_capital_do_ano = [0.0]
var orcamento_ano = [ORCAMENTO_ANO_ZERO]

## VARS 4)
var capital_do_ano = [CAPITAL_DO_ANO_ZERO]

## VARS 5)
var labour_do_ano = [0] 

## VARS 6) e 15)
var tfp_do_ano = [0.00]
var eficiencia_agregada_do_ano = [EFICIENCIA_AGREGADA_DO_ANO_ZERO] #percentagem decimal #USADA NO PASSO 15)

## VARS 8)
var exergia_util_do_ano = [0.0] #TJ

## VARS 9)
var exergia_final_do_ano = [EXERGIA_FINAL_DO_ANO_ZERO] #TJ

## VARS 10)
var shares_exergia_final_transportes_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO] #percentagem decimal

## VARS 11)
var shares_exergia_final_transportes_carvao_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_CARVAO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_carvao_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_CARVAO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_carvao_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_CARVAO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_carvao_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_CARVAO_DO_ANO_ZERO] #percentagem decimal

var shares_exergia_final_transportes_petroleo_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_PETROLEO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_petroleo_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_PETROLEO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_petroleo_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_PETROLEO_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_petroleo_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_PETROLEO_DO_ANO_ZERO] #percentagem decimal

var shares_exergia_final_transportes_eletricidade_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_ELETRICIDADE_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_eletricidade_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_ELETRICIDADE_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_eletricidade_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_ELETRICIDADE_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_eletricidade_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_ELETRICIDADE_DO_ANO_ZERO] #percentagem decimal

var shares_exergia_final_transportes_gas_natural_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_GAS_NATURAL_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_gas_natural_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_GAS_NATURAL_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_gas_natural_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_GAS_NATURAL_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_gas_natural_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_GAS_NATURAL_DO_ANO_ZERO] #percentagem decimal

var shares_exergia_final_transportes_comb_renovaveis_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_COMB_RENOVAVEIS_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_comb_renovaveis_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_COMB_RENOVAVEIS_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_comb_renovaveis_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_COMB_RENOVAVEIS_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_comb_renovaveis_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_COMB_RENOVAVEIS_DO_ANO_ZERO] #percentagem decimal

var shares_exergia_final_transportes_heat_do_ano = [SHARES_EXERGIA_FINAL_TRANSPORTES_HEAT_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_industria_heat_do_ano = [SHARES_EXERGIA_FINAL_INDUSTRIA_HEAT_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_residencial_heat_do_ano = [SHARES_EXERGIA_FINAL_RESIDENCIAL_HEAT_DO_ANO_ZERO] #percentagem decimal
var shares_exergia_final_servicos_heat_do_ano = [SHARES_EXERGIA_FINAL_SERVICOS_HEAT_DO_ANO_ZERO] #percentagem decimal

# VARS 12)
var exergia_final_transportes_do_ano = [EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO] #TJ
var exergia_final_industria_do_ano = [EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO]
var exergia_final_residencial_do_ano = [EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO]
var exergia_final_servicos_do_ano = [EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO]

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

var exergia_final_transportes_comb_renovaveis_do_ano = [0.00]
var exergia_final_industria_comb_renovaveis_do_ano = [0.00]
var exergia_final_residencial_comb_renovaveis_do_ano = [0.00]
var exergia_final_servicos_comb_renovaveis_do_ano = [0.00]

var exergia_final_transportes_heat_do_ano = [0.00]
var exergia_final_industria_heat_do_ano = [0.00]
var exergia_final_residencial_heat_do_ano = [0.00]
var exergia_final_servicos_heat_do_ano = [0.00]

##############
#var eletrificacao_transportes = [(SHARES_EXERGIA_FINAL_TRANSPORTES_ELETRICIDADE_DO_ANO_ZERO * EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO) / EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO]
#var eletrificacao_industria = [(SHARES_EXERGIA_FINAL_INDUSTRIA_ELETRICIDADE_DO_ANO_ZERO * EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO) / EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO]
#var eletrificacao_residencial = [(SHARES_EXERGIA_FINAL_RESIDENCIAL_ELETRICIDADE_DO_ANO_ZERO * EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO) / EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO]
#var eletrificacao_servicos = [(SHARES_EXERGIA_FINAL_SERVICOS_ELETRICIDADE_DO_ANO_ZERO * EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO) / EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO]

var eletrificacao_transportes = [SHARES_EXERGIA_FINAL_TRANSPORTES_ELETRICIDADE_DO_ANO_ZERO] #Laura
var eletrificacao_industria = [SHARES_EXERGIA_FINAL_INDUSTRIA_ELETRICIDADE_DO_ANO_ZERO]
var eletrificacao_residencial = [SHARES_EXERGIA_FINAL_RESIDENCIAL_ELETRICIDADE_DO_ANO_ZERO]
var eletrificacao_servicos = [SHARES_EXERGIA_FINAL_SERVICOS_ELETRICIDADE_DO_ANO_ZERO]

var carvao_transportes = [(SHARES_EXERGIA_FINAL_TRANSPORTES_CARVAO_DO_ANO_ZERO * EXERGIA_FINAL_CARVAO_DO_ANO_ZERO) / EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO]
var carvao_industria = [(SHARES_EXERGIA_FINAL_INDUSTRIA_CARVAO_DO_ANO_ZERO * EXERGIA_FINAL_CARVAO_DO_ANO_ZERO) / EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO]
var carvao_residencial = [(SHARES_EXERGIA_FINAL_RESIDENCIAL_CARVAO_DO_ANO_ZERO * EXERGIA_FINAL_CARVAO_DO_ANO_ZERO) / EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO]
var carvao_servicos = [(SHARES_EXERGIA_FINAL_SERVICOS_CARVAO_DO_ANO_ZERO * EXERGIA_FINAL_CARVAO_DO_ANO_ZERO) / EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO]

var petroleo_transportes = [(SHARES_EXERGIA_FINAL_TRANSPORTES_PETROLEO_DO_ANO_ZERO * EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO) / EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO]
var petroleo_industria = [(SHARES_EXERGIA_FINAL_INDUSTRIA_PETROLEO_DO_ANO_ZERO * EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO) / EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO]
var petroleo_residencial = [(SHARES_EXERGIA_FINAL_RESIDENCIAL_PETROLEO_DO_ANO_ZERO * EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO) / EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO]
var petroleo_servicos = [(SHARES_EXERGIA_FINAL_SERVICOS_PETROLEO_DO_ANO_ZERO * EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO) / EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO]

var gas_natural_transportes = [(SHARES_EXERGIA_FINAL_TRANSPORTES_GAS_NATURAL_DO_ANO_ZERO * EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO) / EXERGIA_FINAL_TRANSPORTES_DO_ANO_ZERO]
var gas_natural_industria = [(SHARES_EXERGIA_FINAL_INDUSTRIA_GAS_NATURAL_DO_ANO_ZERO * EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO) / EXERGIA_FINAL_INDUSTRIA_DO_ANO_ZERO]
var gas_natural_residencial = [(SHARES_EXERGIA_FINAL_RESIDENCIAL_GAS_NATURAL_DO_ANO_ZERO * EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO) / EXERGIA_FINAL_RESIDENCIAL_DO_ANO_ZERO]
var gas_natural_servicos = [(SHARES_EXERGIA_FINAL_SERVICOS_GAS_NATURAL_DO_ANO_ZERO * EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO) / EXERGIA_FINAL_SERVICOS_DO_ANO_ZERO]

#############
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

var exergia_util_transportes_comb_renovaveis_do_ano = [0.00]
var exergia_util_industria_comb_renovaveis_do_ano = [0.00]
var exergia_util_residencial_comb_renovaveis_do_ano = [0.00]
var exergia_util_servicos_comb_renovaveis_do_ano = [0.00]

var exergia_util_transportes_heat_do_ano = [0.00]
var exergia_util_industria_heat_do_ano = [0.00]
var exergia_util_residencial_heat_do_ano = [0.00]
var exergia_util_servicos_heat_do_ano = [0.00]


var exergia_util_transportes_do_ano = [0.00] #TJ
var exergia_util_industria_do_ano = [0.00]
var exergia_util_residencial_do_ano = [0.00]
var exergia_util_servicos_do_ano = [0.00]


var eficiencia_transportes_do_ano = [0.00] #percentagem decimal
var eficiencia_industria_do_ano = [0.00]
var eficiencia_residencial_do_ano = [0.00]
var eficiencia_servicos_do_ano = [0.00]

# VARS 16
var exergia_final_carvao_do_ano = [EXERGIA_FINAL_CARVAO_DO_ANO_ZERO] #TJ
var exergia_final_petroleo_do_ano = [EXERGIA_FINAL_PETROLEO_DO_ANO_ZERO]
var exergia_final_eletricidade_do_ano = [EXERGIA_FINAL_ELETRICIDADE_DO_ANO_ZERO]
var exergia_final_gas_natural_do_ano = [EXERGIA_FINAL_GAS_NATURAL_DO_ANO_ZERO]
var exergia_final_comb_renovaveis_do_ano = [0.00]
var exergia_final_heat_do_ano = [0.00]

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
	return ((ano - ANO_INICIAL -4)/4)
	
func ano_do_indice(indice):
	return indice + ANO_INICIAL
	
# FUNCS 0) - PREPARAÇÃO
func mudar_de_ano():
	ano_atual += 4
	ano_atual_indice += 1

	# Após execução desta função, acede-se aos valores do ano anterior presentes
	# em vetores procurando pelo índice [ano_atual_indice - 1]
	# Em algumas funções em que se pretende aceder a um valor recém adicionado,
	# usa-se um .back()


# FUNCS 1) - POTÊNCIA ELETRICA ACUMULADA POR FONTE RENOVÁVEL (gigawatts)
func calcular_distribuicao_por_fonte():
	
	var potencia_maxima_solar_alcancada = (potencia_do_ano_solar[ano_atual_indice - 1] >= POTENCIA_MAXIMA_SOLAR)
	var potencia_maxima_vento_alcancada = (potencia_do_ano_vento[ano_atual_indice - 1] >= POTENCIA_MAXIMA_VENTO)
	
	#111
	potencia_solar_instantanea = 0.0
	potencia_vento_instantanea = 0.0
	potencia_vento_offshore_instantanea = 0.0
	
	if(!potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada): #000
		potencia_solar_instantanea = input_potencia_a_instalar / 2
		potencia_vento_instantanea = input_potencia_a_instalar / 2
	elif(!potencia_maxima_solar_alcancada && potencia_maxima_vento_alcancada): #011
		potencia_solar_instantanea = input_potencia_a_instalar / 2
		potencia_vento_offshore_instantanea = input_potencia_a_instalar / 2
	elif(potencia_maxima_solar_alcancada && !potencia_maxima_vento_alcancada): #100
		potencia_vento_instantanea = input_potencia_a_instalar
	elif(potencia_maxima_solar_alcancada && potencia_maxima_vento_alcancada ): #110
		potencia_vento_offshore_instantanea = input_potencia_a_instalar
	
# Prevenção da quebra dos limites máximos
	if((potencia_do_ano_solar[ano_atual_indice - 1] + potencia_solar_instantanea) > POTENCIA_MAXIMA_SOLAR):
		potencia_solar_instantanea = POTENCIA_MAXIMA_SOLAR - potencia_do_ano_solar[ano_atual_indice - 1]
	if((potencia_do_ano_vento[ano_atual_indice - 1] + potencia_vento_instantanea) > POTENCIA_MAXIMA_VENTO):
		potencia_vento_instantanea = POTENCIA_MAXIMA_VENTO - potencia_do_ano_vento[ano_atual_indice - 1]
	if((potencia_do_ano_vento_offshore[ano_atual_indice - 1] + potencia_vento_offshore_instantanea) > POTENCIA_MAXIMA_VENTO_OFFSHORE):
		potencia_vento_offshore_instantanea = POTENCIA_MAXIMA_VENTO_OFFSHORE - potencia_do_ano_vento_offshore[ano_atual_indice - 1]
	
# Soma dos valores instantâneos aos do ano anterior e adição ao vetor respetivo
	potencia_do_ano_solar.push_back(potencia_do_ano_solar[ano_atual_indice - 1] + potencia_solar_instantanea)
	potencia_do_ano_vento.push_back(potencia_do_ano_vento[ano_atual_indice - 1] + potencia_vento_instantanea)
	potencia_do_ano_vento_offshore.push_back(potencia_do_ano_vento_offshore[ano_atual_indice - 1] + potencia_vento_offshore_instantanea)
	
	
# FUNCS 2) - CUSTO DA POTÊNCIA (euros)
func calcular_custo():
	
	var custo_solar_instantaneo = potencia_do_ano_solar[ano_atual_indice] * CUSTO_POR_GIGAWATT_INSTALADO_SOLAR
	var custo_vento_instantaneo = potencia_do_ano_vento[ano_atual_indice] * CUSTO_POR_GIGAWATT_INSTALADO_VENTO
	var custo_vento_offshore_instantaneo = potencia_do_ano_vento_offshore[ano_atual_indice] * CUSTO_POR_GIGAWATT_INSTALADO_VENTO_OFFSHORE
	
	custo_do_ano_solar.push_back(custo_solar_instantaneo)
	custo_do_ano_vento.push_back(custo_vento_instantaneo)
	custo_do_ano_vento_offshore.push_back(custo_vento_offshore_instantaneo)
	
	custo_total_do_ano.push_back(custo_solar_instantaneo + custo_vento_instantaneo + custo_vento_offshore_instantaneo)
	

# FUNCS 3) - INVESTIMENTO (milhares de milhões de euros)
func calcular_investimento():
	
	var investimento_total_instantaneo = PERCENTAGEM_A_RETIRAR_DO_PIB * pib_do_ano[ano_atual_indice - 1]
	
	investimento_total_do_ano.push_back(investimento_total_instantaneo)
	investimento_para_capital_do_ano.push_back(investimento_total_instantaneo - (custo_total_do_ano[ano_atual_indice] * pow(10,-9)))
	
# FUNCS 4) - CAPITAL (milhares de milhões de euros)
func calcular_capital():
	capital_do_ano.push_back(capital_do_ano[ano_atual_indice - 1] + investimento_para_capital_do_ano[ano_atual_indice])

# FUNCS 5) - LABOUR (horas de trabalho realizadas por trabalhadores ativos)
func calcular_labour():
	labour_do_ano.push_back(ALFA * POPULACAO)
	
# FUNCS 6) - TOTAL FACTOR PRODUTIVITY (TFP)
func calcular_tfp():
	#tfp_do_ano.push_back(pow((eficiencia_agregada_do_ano.back() / EFF1960),1.87) * 0.00000105 + 0.00000025)
	#tfp_do_ano.push_back(pow((eficiencia_agregada_do_ano.back() / EFF1960),1.87))
	tfp_do_ano.push_back(pow((eficiencia_agregada_do_ano[ano_atual_indice - 1] / EFF1960), 1.93) * 0.00000102 + 0.00000039)
	
	
# FUNCS 7) - PIB (milhares de milhões de euros)
func calcular_pib():
	pib_do_ano.push_back(tfp_do_ano[ano_atual_indice]* pow(capital_do_ano[ano_atual_indice], 0.3) *pow(labour_do_ano[ano_atual_indice], 0.7))
	
# FUNCS 8) - EXERGIA ÚTIL ANUAL (terajoule) (1 megajoule = 1 euro)
func calcular_exergia_util():
	exergia_util_do_ano.push_back(pib_do_ano[ano_atual_indice] * pow(10,3))
	
# FUNCS 9) - EXERGIA FINAL ANUAL (terajoule)
func calcular_exergia_final():
	exergia_final_do_ano.push_back(exergia_util_do_ano[ano_atual_indice] / eficiencia_agregada_do_ano[ano_atual_indice - 1])

# FUNCS 10) - SHARES DE EXERGIA FINAL POR SETOR (percentagem decimal)
func calcular_shares_de_exergia_final_por_setor():
	var shares_transportes = shares_exergia_final_transportes_do_ano[ano_atual_indice - 1] + input_percentagem_tipo_economia_transportes * PERCENTAGEM_INPUT_SETAS
	var shares_industria = shares_exergia_final_industria_do_ano[ano_atual_indice - 1] + input_percentagem_tipo_economia_industria * PERCENTAGEM_INPUT_SETAS
	var shares_residencial = shares_exergia_final_residencial_do_ano[ano_atual_indice - 1] + input_percentagem_tipo_economia_residencial * PERCENTAGEM_INPUT_SETAS
	var shares_servicos = shares_exergia_final_servicos_do_ano[ano_atual_indice - 1] + input_percentagem_tipo_economia_servicos * PERCENTAGEM_INPUT_SETAS
	
	if (input_percentagem_tipo_economia_industria == input_percentagem_tipo_economia_residencial && input_percentagem_tipo_economia_residencial == input_percentagem_tipo_economia_servicos && input_percentagem_tipo_economia_servicos == input_percentagem_tipo_economia_transportes && input_percentagem_tipo_economia_industria):
		shares_exergia_final_transportes_do_ano.push_back(shares_exergia_final_transportes_do_ano[ano_atual_indice - 1])
		shares_exergia_final_industria_do_ano.push_back(shares_exergia_final_industria_do_ano[ano_atual_indice - 1])
		shares_exergia_final_residencial_do_ano.push_back(shares_exergia_final_residencial_do_ano[ano_atual_indice - 1])
		shares_exergia_final_servicos_do_ano.push_back(shares_exergia_final_servicos_do_ano[ano_atual_indice - 1])
		return
		
	if(shares_transportes < 0.01):
		shares_transportes = 0.01
	if(shares_industria < 0.01):
		shares_industria = 0.01
	if(shares_residencial < 0.01):
		shares_residencial = 0.01
	if(shares_servicos < 0.01):
		shares_servicos = 0.01
			
	var soma = shares_transportes + shares_industria + shares_residencial + shares_servicos
	
	#normalização a 1.00 das percentagens
	if(soma != 1.00):
		shares_transportes = shares_transportes / float(soma)
		shares_industria = shares_industria / float(soma)
		shares_residencial = shares_residencial / float(soma)
		shares_servicos = shares_servicos / float(soma)
		
	shares_exergia_final_transportes_do_ano.push_back(shares_transportes)
	shares_exergia_final_industria_do_ano.push_back(shares_industria)
	shares_exergia_final_residencial_do_ano.push_back(shares_residencial)
	shares_exergia_final_servicos_do_ano.push_back(shares_servicos)

# FUNCS 11) - EXERGIA FINAL POR SETOR (terajoules)
func calcular_valores_absolutos_de_exergia_final_por_setor():
	exergia_final_transportes_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_transportes_do_ano[ano_atual_indice])
	exergia_final_industria_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_industria_do_ano[ano_atual_indice])
	exergia_final_residencial_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_residencial_do_ano[ano_atual_indice])
	exergia_final_servicos_do_ano.push_back(exergia_final_do_ano[ano_atual_indice] * shares_exergia_final_servicos_do_ano[ano_atual_indice])
	
# FUNCS 12) - ELETRIFICAÇÃO (e afins) DE SETORES
func calcular_eletrificacao_etc_de_setores():
	#(SHARES_EXERGIA_FINAL_TRANSPORTES_ELETRICIDADE_DO_ANO_ZERO * exergia_final_do_ano) / exergia_final_transportes_do_ano
	var eletrificacao_transportes_temp = eletrificacao_transportes[ano_atual_indice - 1] + input_percentagem_eletrificacao_transportes * PERCENTAGEM_INPUT_SETAS
	var eletrificacao_industria_temp = eletrificacao_industria[ano_atual_indice - 1] + input_percentagem_eletrificacao_industria * PERCENTAGEM_INPUT_SETAS
	var eletrificacao_residencial_temp = eletrificacao_residencial[ano_atual_indice - 1] + input_percentagem_eletrificacao_residencial * PERCENTAGEM_INPUT_SETAS
	var eletrificacao_servicos_temp = eletrificacao_servicos[ano_atual_indice - 1] + input_percentagem_eletrificacao_servicos * PERCENTAGEM_INPUT_SETAS
	
	if(eletrificacao_transportes_temp <= 0.01):
		eletrificacao_transportes_temp = 0.01
	if(eletrificacao_industria_temp <= 0.01):
		eletrificacao_industria_temp = 0.01
	if(eletrificacao_residencial_temp <= 0.01):
		eletrificacao_residencial_temp = 0.01
	if(eletrificacao_servicos_temp <= 0.01):
		eletrificacao_servicos_temp = 0.01
		
	if(eletrificacao_transportes_temp >= 0.90): # ALterado!!!
		eletrificacao_transportes_temp = 0.90	#
	if(eletrificacao_industria_temp >= 0.70):	#
		eletrificacao_industria_temp = 0.70		#
	if(eletrificacao_residencial_temp >= 0.99):
		eletrificacao_residencial_temp = 0.99
	if(eletrificacao_servicos_temp >= 0.99):
		eletrificacao_servicos_temp = 0.99
	
	eletrificacao_transportes.push_back(eletrificacao_transportes_temp)
	eletrificacao_industria.push_back(eletrificacao_industria_temp)
	eletrificacao_residencial.push_back(eletrificacao_residencial_temp)
	eletrificacao_servicos.push_back(eletrificacao_servicos_temp)
	
	shares_exergia_final_transportes_eletricidade_do_ano.push_back(eletrificacao_transportes_temp)
	shares_exergia_final_industria_eletricidade_do_ano.push_back(eletrificacao_industria_temp)
	shares_exergia_final_residencial_eletricidade_do_ano.push_back(eletrificacao_residencial_temp)
	shares_exergia_final_servicos_eletricidade_do_ano.push_back(eletrificacao_servicos_temp)

# FUNCS 13) - SHARES DE EXERGIA FINAL POR SETOR POR CARRIER (percentagem decimal)
func calcular_shares_de_exergia_final_por_setor_por_carrier():

	#TRANSPORTES
	shares_exergia_final_transportes_carvao_do_ano.push_back(shares_exergia_final_transportes_carvao_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_transportes[ano_atual_indice]) / (1 - eletrificacao_transportes[ano_atual_indice - 1]))
	shares_exergia_final_transportes_petroleo_do_ano.push_back(shares_exergia_final_transportes_petroleo_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_transportes[ano_atual_indice]) / (1 - eletrificacao_transportes[ano_atual_indice - 1]))
	shares_exergia_final_transportes_gas_natural_do_ano.push_back(shares_exergia_final_transportes_gas_natural_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_transportes[ano_atual_indice]) / (1 - eletrificacao_transportes[ano_atual_indice - 1]))
	shares_exergia_final_transportes_comb_renovaveis_do_ano.push_back(shares_exergia_final_transportes_comb_renovaveis_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_transportes[ano_atual_indice]) / (1 - eletrificacao_transportes[ano_atual_indice - 1]))
	shares_exergia_final_transportes_heat_do_ano.push_back(shares_exergia_final_transportes_heat_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_transportes[ano_atual_indice]) / (1 - eletrificacao_transportes[ano_atual_indice - 1]))
	
	
	#INDUSTRIA
	shares_exergia_final_industria_carvao_do_ano.push_back(shares_exergia_final_industria_carvao_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_industria[ano_atual_indice]) / (1 - eletrificacao_industria[ano_atual_indice - 1]))
	shares_exergia_final_industria_petroleo_do_ano.push_back(shares_exergia_final_industria_petroleo_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_industria[ano_atual_indice]) / (1 - eletrificacao_industria[ano_atual_indice - 1]))
	shares_exergia_final_industria_gas_natural_do_ano.push_back(shares_exergia_final_industria_gas_natural_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_industria[ano_atual_indice]) / (1 - eletrificacao_industria[ano_atual_indice - 1]))
	shares_exergia_final_industria_comb_renovaveis_do_ano.push_back(shares_exergia_final_industria_comb_renovaveis_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_industria[ano_atual_indice]) / (1 - eletrificacao_industria[ano_atual_indice - 1]))
	shares_exergia_final_industria_heat_do_ano.push_back(shares_exergia_final_industria_heat_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_industria[ano_atual_indice]) / (1 - eletrificacao_industria[ano_atual_indice - 1]))
	
	#RESIDENCIAL
	shares_exergia_final_residencial_carvao_do_ano.push_back(shares_exergia_final_residencial_carvao_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_residencial[ano_atual_indice]) / (1 - eletrificacao_residencial[ano_atual_indice - 1]))
	shares_exergia_final_residencial_petroleo_do_ano.push_back(shares_exergia_final_residencial_petroleo_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_residencial[ano_atual_indice]) / (1 - eletrificacao_residencial[ano_atual_indice - 1]))
	shares_exergia_final_residencial_gas_natural_do_ano.push_back(shares_exergia_final_residencial_gas_natural_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_residencial[ano_atual_indice]) / (1 - eletrificacao_residencial[ano_atual_indice - 1]))
	shares_exergia_final_residencial_comb_renovaveis_do_ano.push_back(shares_exergia_final_residencial_comb_renovaveis_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_residencial[ano_atual_indice]) / (1 - eletrificacao_residencial[ano_atual_indice - 1]))
	shares_exergia_final_residencial_heat_do_ano.push_back(shares_exergia_final_residencial_heat_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_residencial[ano_atual_indice]) / (1 - eletrificacao_residencial[ano_atual_indice - 1]))
		
	#SERVICOS
	shares_exergia_final_servicos_carvao_do_ano.push_back(shares_exergia_final_servicos_carvao_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_servicos[ano_atual_indice]) / (1 - eletrificacao_servicos[ano_atual_indice - 1]))
	shares_exergia_final_servicos_petroleo_do_ano.push_back(shares_exergia_final_servicos_petroleo_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_servicos[ano_atual_indice]) / (1 - eletrificacao_servicos[ano_atual_indice - 1]))
	shares_exergia_final_servicos_gas_natural_do_ano.push_back(shares_exergia_final_servicos_gas_natural_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_servicos[ano_atual_indice]) / (1 - eletrificacao_servicos[ano_atual_indice - 1]))
	shares_exergia_final_servicos_comb_renovaveis_do_ano.push_back(shares_exergia_final_servicos_comb_renovaveis_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_servicos[ano_atual_indice]) / (1 - eletrificacao_servicos[ano_atual_indice - 1]))
	shares_exergia_final_servicos_heat_do_ano.push_back(shares_exergia_final_servicos_heat_do_ano[ano_atual_indice - 1] * (1 - eletrificacao_servicos[ano_atual_indice]) / (1 - eletrificacao_servicos[ano_atual_indice - 1]))
	

# FUNCS 14) - EXERGIA FINAL POR SETOR POR CARRIER (terajoules)
func calcular_valores_absolutos_de_exergia_final_por_setor_por_carrier():
	exergia_final_transportes_eletricidade_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * eletrificacao_transportes[ano_atual_indice])
	exergia_final_transportes_carvao_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * shares_exergia_final_transportes_carvao_do_ano[ano_atual_indice])
	exergia_final_transportes_petroleo_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * shares_exergia_final_transportes_petroleo_do_ano[ano_atual_indice])
	exergia_final_transportes_gas_natural_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * shares_exergia_final_transportes_gas_natural_do_ano[ano_atual_indice])
	exergia_final_transportes_comb_renovaveis_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * shares_exergia_final_transportes_comb_renovaveis_do_ano[ano_atual_indice])
	exergia_final_transportes_heat_do_ano.push_back(exergia_final_transportes_do_ano[ano_atual_indice] * shares_exergia_final_transportes_heat_do_ano[ano_atual_indice])
	
	exergia_final_industria_eletricidade_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * eletrificacao_industria[ano_atual_indice])
	exergia_final_industria_carvao_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * shares_exergia_final_industria_carvao_do_ano[ano_atual_indice])
	exergia_final_industria_petroleo_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * shares_exergia_final_industria_petroleo_do_ano[ano_atual_indice])
	exergia_final_industria_gas_natural_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * shares_exergia_final_industria_gas_natural_do_ano[ano_atual_indice])
	exergia_final_industria_comb_renovaveis_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * shares_exergia_final_industria_comb_renovaveis_do_ano[ano_atual_indice])
	exergia_final_industria_heat_do_ano.push_back(exergia_final_industria_do_ano[ano_atual_indice] * shares_exergia_final_industria_heat_do_ano[ano_atual_indice])
	
	exergia_final_residencial_eletricidade_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * eletrificacao_residencial[ano_atual_indice])
	exergia_final_residencial_carvao_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * shares_exergia_final_residencial_carvao_do_ano[ano_atual_indice])
	exergia_final_residencial_petroleo_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * shares_exergia_final_residencial_petroleo_do_ano[ano_atual_indice])
	exergia_final_residencial_gas_natural_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * shares_exergia_final_residencial_gas_natural_do_ano[ano_atual_indice])
	exergia_final_residencial_comb_renovaveis_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * shares_exergia_final_residencial_comb_renovaveis_do_ano[ano_atual_indice])
	exergia_final_residencial_heat_do_ano.push_back(exergia_final_residencial_do_ano[ano_atual_indice] * shares_exergia_final_residencial_heat_do_ano[ano_atual_indice])
	
	exergia_final_servicos_eletricidade_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * eletrificacao_servicos[ano_atual_indice])
	exergia_final_servicos_carvao_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * shares_exergia_final_servicos_carvao_do_ano[ano_atual_indice])
	exergia_final_servicos_petroleo_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * shares_exergia_final_servicos_petroleo_do_ano[ano_atual_indice])
	exergia_final_servicos_gas_natural_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * shares_exergia_final_servicos_gas_natural_do_ano[ano_atual_indice])
	exergia_final_servicos_comb_renovaveis_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * shares_exergia_final_servicos_comb_renovaveis_do_ano[ano_atual_indice])
	exergia_final_servicos_heat_do_ano.push_back(exergia_final_servicos_do_ano[ano_atual_indice] * shares_exergia_final_servicos_heat_do_ano[ano_atual_indice])
	
# FUNCS 15) - EFICIÊNCIA POR SETOR (percentagem decimal)
func calcular_eficiencia_por_setor(): 
	exergia_util_transportes_eletricidade_do_ano.push_back(exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_ELETRICIDADE)
	exergia_util_industria_eletricidade_do_ano.push_back(exergia_final_industria_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_ELETRICIDADE)
	exergia_util_residencial_eletricidade_do_ano.push_back(exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_ELETRICIDADE)
	exergia_util_servicos_eletricidade_do_ano.push_back(exergia_final_servicos_eletricidade_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_ELETRICIDADE)

	exergia_util_transportes_carvao_do_ano.push_back(exergia_final_transportes_carvao_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_CARVAO)
	exergia_util_industria_carvao_do_ano.push_back(exergia_final_industria_carvao_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_CARVAO)
	exergia_util_residencial_carvao_do_ano.push_back(exergia_final_residencial_carvao_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_CARVAO)
	exergia_util_servicos_carvao_do_ano.push_back(exergia_final_servicos_carvao_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_CARVAO)

	exergia_util_transportes_petroleo_do_ano.push_back(exergia_final_transportes_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_PETROLEO)
	exergia_util_industria_petroleo_do_ano.push_back(exergia_final_industria_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_PETROLEO)
	exergia_util_residencial_petroleo_do_ano.push_back(exergia_final_residencial_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_PETROLEO)
	exergia_util_servicos_petroleo_do_ano.push_back(exergia_final_servicos_petroleo_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_PETROLEO)
	
	exergia_util_transportes_gas_natural_do_ano.push_back(exergia_final_transportes_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_GAS_NATURAL)
	exergia_util_industria_gas_natural_do_ano.push_back(exergia_final_industria_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_GAS_NATURAL)
	exergia_util_residencial_gas_natural_do_ano.push_back(exergia_final_residencial_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_GAS_NATURAL)
	exergia_util_servicos_gas_natural_do_ano.push_back(exergia_final_servicos_gas_natural_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_GAS_NATURAL)
	
	exergia_util_transportes_comb_renovaveis_do_ano.push_back(exergia_final_transportes_comb_renovaveis_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_COMB_RENOVAVEIS)
	exergia_util_industria_comb_renovaveis_do_ano.push_back(exergia_final_industria_comb_renovaveis_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_COMB_RENOVAVEIS)
	exergia_util_residencial_comb_renovaveis_do_ano.push_back(exergia_final_residencial_comb_renovaveis_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_COMB_RENOVAVEIS)
	exergia_util_servicos_comb_renovaveis_do_ano.push_back(exergia_final_servicos_comb_renovaveis_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_COMB_RENOVAVEIS)
	
	exergia_util_transportes_heat_do_ano.push_back(exergia_final_transportes_heat_do_ano[ano_atual_indice] * EFICIENCIA_TRANSPORTES_HEAT)
	exergia_util_industria_heat_do_ano.push_back(exergia_final_industria_heat_do_ano[ano_atual_indice] * EFICIENCIA_INDUSTRIA_HEAT)
	exergia_util_residencial_heat_do_ano.push_back(exergia_final_residencial_heat_do_ano[ano_atual_indice] * EFICIENCIA_RESIDENCIAL_HEAT)
	exergia_util_servicos_heat_do_ano.push_back(exergia_final_servicos_heat_do_ano[ano_atual_indice] * EFICIENCIA_SERVICOS_HEAT)


	exergia_util_transportes_do_ano.push_back(exergia_util_transportes_eletricidade_do_ano[ano_atual_indice] + exergia_util_transportes_carvao_do_ano[ano_atual_indice] + exergia_util_transportes_petroleo_do_ano[ano_atual_indice] + exergia_util_transportes_gas_natural_do_ano[ano_atual_indice] + exergia_util_transportes_comb_renovaveis_do_ano[ano_atual_indice] + exergia_util_transportes_heat_do_ano[ano_atual_indice])
	exergia_util_industria_do_ano.push_back(exergia_util_industria_eletricidade_do_ano[ano_atual_indice] + exergia_util_industria_carvao_do_ano[ano_atual_indice] + exergia_util_industria_petroleo_do_ano[ano_atual_indice] + exergia_util_industria_gas_natural_do_ano[ano_atual_indice] + exergia_util_industria_comb_renovaveis_do_ano[ano_atual_indice] + exergia_util_industria_heat_do_ano[ano_atual_indice])
	exergia_util_residencial_do_ano.push_back(exergia_util_residencial_eletricidade_do_ano[ano_atual_indice] + exergia_util_residencial_carvao_do_ano[ano_atual_indice] + exergia_util_residencial_petroleo_do_ano[ano_atual_indice] + exergia_util_residencial_gas_natural_do_ano[ano_atual_indice] + exergia_util_residencial_comb_renovaveis_do_ano[ano_atual_indice] + exergia_util_residencial_heat_do_ano[ano_atual_indice])
	exergia_util_servicos_do_ano.push_back(exergia_util_servicos_eletricidade_do_ano[ano_atual_indice] + exergia_util_servicos_carvao_do_ano[ano_atual_indice] + exergia_util_servicos_petroleo_do_ano[ano_atual_indice] + exergia_util_servicos_gas_natural_do_ano[ano_atual_indice] + exergia_util_servicos_comb_renovaveis_do_ano[ano_atual_indice] + exergia_util_servicos_heat_do_ano[ano_atual_indice])


	eficiencia_transportes_do_ano.push_back(exergia_util_transportes_do_ano[ano_atual_indice] / exergia_final_transportes_do_ano[ano_atual_indice])
	eficiencia_industria_do_ano.push_back(exergia_util_industria_do_ano[ano_atual_indice] / exergia_final_industria_do_ano[ano_atual_indice])
	eficiencia_residencial_do_ano.push_back(exergia_util_residencial_do_ano[ano_atual_indice] / exergia_final_residencial_do_ano[ano_atual_indice])
	eficiencia_servicos_do_ano.push_back(exergia_util_servicos_do_ano[ano_atual_indice] / exergia_final_servicos_do_ano[ano_atual_indice])
	
# FUNCS 16) - EFICIÊNCIA AGREGADA (para cálculos em anos futuros)
func calcular_eficiencia_agregada():
	#atualização dos valores anteriormente calculados, usando os somatórios das partes
	#exergia_util_do_ano[ano_atual_indice] = exergia_util_transportes_do_ano[ano_atual_indice] + exergia_util_industria_do_ano[ano_atual_indice] + exergia_util_residencial_do_ano[ano_atual_indice] + exergia_util_servicos_do_ano[ano_atual_indice]
	#exergia_final_do_ano[ano_atual_indice] = exergia_final_transportes_do_ano[ano_atual_indice] + exergia_final_industria_do_ano[ano_atual_indice] + exergia_final_residencial_do_ano[ano_atual_indice] + exergia_final_servicos_do_ano[ano_atual_indice]
	print("Exergia util do ano (antes da atualização): " + str(exergia_util_do_ano))
	print("Exergia final do ano (antes da atualização): " + str(exergia_final_do_ano))
	
	exergia_util_do_ano[ano_atual_indice] = exergia_util_transportes_do_ano[ano_atual_indice] + exergia_util_industria_do_ano[ano_atual_indice] + exergia_util_residencial_do_ano[ano_atual_indice] + exergia_util_servicos_do_ano[ano_atual_indice]
	exergia_final_do_ano[ano_atual_indice] = exergia_final_transportes_do_ano[ano_atual_indice] + exergia_final_industria_do_ano[ano_atual_indice] + exergia_final_residencial_do_ano[ano_atual_indice] + exergia_final_servicos_do_ano[ano_atual_indice]
	
	#calculo da eficiencia agregada usando valores atualizados
	eficiencia_agregada_do_ano.push_back(exergia_util_do_ano[ano_atual_indice] / exergia_final_do_ano[ano_atual_indice])

# FUNCS 17) - EXERGIA FINAL POR CARRIER (terajoules)
func calcular_valores_absolutos_de_exergia_final_por_carrier():
	exergia_final_eletricidade_do_ano.push_back(exergia_final_transportes_eletricidade_do_ano[ano_atual_indice] + exergia_final_industria_eletricidade_do_ano[ano_atual_indice] + exergia_final_residencial_eletricidade_do_ano[ano_atual_indice] + exergia_final_servicos_eletricidade_do_ano[ano_atual_indice])
	exergia_final_carvao_do_ano.push_back(exergia_final_transportes_carvao_do_ano[ano_atual_indice] + exergia_final_industria_carvao_do_ano[ano_atual_indice] + exergia_final_residencial_carvao_do_ano[ano_atual_indice] + exergia_final_servicos_carvao_do_ano[ano_atual_indice])
	exergia_final_petroleo_do_ano.push_back(exergia_final_transportes_petroleo_do_ano[ano_atual_indice] + exergia_final_industria_petroleo_do_ano[ano_atual_indice] + exergia_final_residencial_petroleo_do_ano[ano_atual_indice] + exergia_final_servicos_petroleo_do_ano[ano_atual_indice])
	exergia_final_gas_natural_do_ano.push_back(exergia_final_transportes_gas_natural_do_ano[ano_atual_indice] + exergia_final_industria_gas_natural_do_ano[ano_atual_indice] + exergia_final_residencial_gas_natural_do_ano[ano_atual_indice] + exergia_final_servicos_gas_natural_do_ano[ano_atual_indice])
	exergia_final_comb_renovaveis_do_ano.push_back(exergia_final_transportes_comb_renovaveis_do_ano[ano_atual_indice] + exergia_final_industria_comb_renovaveis_do_ano[ano_atual_indice] + exergia_final_residencial_comb_renovaveis_do_ano[ano_atual_indice] + exergia_final_servicos_comb_renovaveis_do_ano[ano_atual_indice])
	exergia_final_heat_do_ano.push_back(exergia_final_transportes_heat_do_ano[ano_atual_indice] + exergia_final_industria_heat_do_ano[ano_atual_indice] + exergia_final_residencial_heat_do_ano[ano_atual_indice] + exergia_final_servicos_heat_do_ano[ano_atual_indice])

# FUNCS 18) - EMISSÕES DE CO2 POR CARRIER (exceto eletricidade) (kg CO2)
func calcular_emissoes_CO2_carvao_petroleo_gas_natural():
	emissoes_CO2_carvao_do_ano.push_back(exergia_final_carvao_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_CARVAO)
	emissoes_CO2_petroleo_do_ano.push_back(exergia_final_petroleo_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_PETROLEO)
	emissoes_CO2_gas_natural_do_ano.push_back(exergia_final_gas_natural_do_ano[ano_atual_indice] * FATOR_DE_EMISSAO_GAS_NATURAL)
	
	emissoes_totais_sem_eletricidade.push_back(emissoes_CO2_carvao_do_ano.back() + emissoes_CO2_petroleo_do_ano.back() + emissoes_CO2_gas_natural_do_ano.back())

# FUNCS 19) - ELETRICIDADE VINDA DE FONTES RENOVÁVEIS (i.e. emissões zero) (gigawatts * hora) (GWh)
func calcular_eletricidade_de_fontes_renovaveis():
	var eletricidade_solar = potencia_do_ano_solar[ano_atual_indice] * FATOR_DE_PRODUCAO_SOLAR * HORAS_POR_ANO
	var eletricidade_vento = potencia_do_ano_vento[ano_atual_indice] * FATOR_DE_PRODUCAO_VENTO * HORAS_POR_ANO
	var eletricidade_vento_offshore = potencia_do_ano_vento_offshore[ano_atual_indice] * FATOR_DE_PRODUCAO_VENTO_OFFSHORE * HORAS_POR_ANO
	var eletricidade_hidro = POTENCIA_ANUAL_HIDRO * FATOR_DE_PRODUCAO_HIDRO * HORAS_POR_ANO

	eletricidade_renovavel_do_ano.push_back(eletricidade_solar + eletricidade_vento + eletricidade_vento_offshore + eletricidade_hidro)

# FUNCS 20) - ELETRICIDADE NÃO RENOVÁVEL (GWh)
func calcular_eletricidade_nao_renovavel():
	#1 GWh = 3.6 TJ
	eletricidade_nao_renovavel_do_ano.push_back(((exergia_final_eletricidade_do_ano[ano_atual_indice]/3.6) * INEFICIENCIA_PRIMARIO_PARA_FINAL) - eletricidade_renovavel_do_ano[ano_atual_indice])

# FUNCS 21) e 22) - EMISSÕES NÃO RENOVÁVEIS (kg CO2)
func calcular_emissoes_nao_renovaveis():
	var eletricidade_nao_renovavel_TJ
	var maximo_produzido_por_gas_natural_TJ
	
	if(eletricidade_nao_renovavel_do_ano[ano_atual_indice] <= 0.00):
		print("Eletricidade 100% renovável!")
		emissoes_nao_renovaveis_do_ano.push_back(0)
	elif(eletricidade_nao_renovavel_do_ano[ano_atual_indice] <= MAXIMO_PRODUZIDO_POR_GAS_NATURAL):
		eletricidade_nao_renovavel_TJ = eletricidade_nao_renovavel_do_ano[ano_atual_indice] * 3.6
		emissoes_nao_renovaveis_do_ano.push_back((eletricidade_nao_renovavel_TJ / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL) * FATOR_DE_EMISSAO_GAS_NATURAL)
	else:
		eletricidade_nao_renovavel_TJ = eletricidade_nao_renovavel_do_ano[ano_atual_indice] * 3.6
		maximo_produzido_por_gas_natural_TJ = MAXIMO_PRODUZIDO_POR_GAS_NATURAL * 3.6
		emissoes_nao_renovaveis_do_ano.push_back(( (maximo_produzido_por_gas_natural_TJ / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_GAS_NATURAL) * FATOR_DE_EMISSAO_GAS_NATURAL ) + ( ( (eletricidade_nao_renovavel_TJ - maximo_produzido_por_gas_natural_TJ) / EFICIENCIA_DE_PRODUCAO_DE_ELETRICIDADE_COM_CARVAO ) * FATOR_DE_EMISSAO_CARVAO)) 

# FUNCS 23) - EMISSÕES TOTAIS (um dos objetivos do jogo) (tons C02 = kg/1000 CO2) (i.e. para estar em toneladas é necessário dividir por 1000)
func calcular_emissoes_totais():
	emissoes_totais_do_ano.push_back(emissoes_totais_sem_eletricidade[ano_atual_indice] + emissoes_nao_renovaveis_do_ano[ano_atual_indice])

# FUNCS 24) - CONSUMO (milhares de milhões de euros)
func calcular_consumo():
	consumo_do_ano.push_back(pib_do_ano[-1] - investimento_total_do_ano[ano_atual_indice])
	
# FUNCS 25) - UTILIDADE (Felicidade dos cidadãos; um dos objetivos do jogo) (Atenção: para efeitos de apresentação no jogo, estamos a dividir os resultados pelo resultado do ano 1)
func calcular_utilidade():
	#UTILIDADE = ((CONSUMO^b)*(EXP(CO2 / a))) / POPULAÇÃO, a = 10000000000 e b = 2
	var utilidade_absoluta = ((pow(consumo_do_ano[ano_atual_indice] * pow(10, 9), 2)) * exp((-1 * emissoes_totais_do_ano[ano_atual_indice])/10000000000))/POPULACAO
	var utilidade_relativa = utilidade_absoluta / UTILIDADE_DO_ANO_UM
	utilidade_do_ano.push_back(utilidade_relativa)
	
