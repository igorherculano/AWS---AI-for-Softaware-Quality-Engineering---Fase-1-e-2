import pytest
from Calculadora import ClasseCalculadora

## Soma
@pytest.mark.parametrize("parcela1,parcela2,resultado", [
    (1, 2, 3),
    (0, 0, 0),             ## apenas com 0
    (10.48, 10.51, 20.99), ## Numeros quebrados
    (-10, 5, -5),          ## Soma negativo
    (1e10, 1e10, 2e10),    ## Numero grande
])
def test_soma(parcela1, parcela2, resultado):
    assert ClasseCalculadora.soma(parcela1, parcela2) == pytest.approx(resultado)

## Subtração
@pytest.mark.parametrize("minuendo,subtraendo,diferenca", [
    (1, 2, -1),
    (-1, -1, 0),           ## Subtração dois negativos
    (20, 10, 10),
    (0, 15, -15),
    (10.5, 0.2, 10.3),     ## Subtração numeros quebrados
])
def test_subtracao(minuendo, subtraendo, diferenca):
    assert ClasseCalculadora.subtracao(minuendo, subtraendo) == pytest.approx(diferenca)

## Multiplicação
@pytest.mark.parametrize("multiplicando,multiplicador,produto", [
    (2, 2, 4),
    (2, 0, 0),             ## multiplicando por 0
    (-2, 4, -8),
    (-5, -5, 25),          ## - + - = +
    (0.1, 0.1, 0.01),      ## numeros quebrados na multiplicação
])
def test_multiplicacao(multiplicando, multiplicador, produto):
    assert ClasseCalculadora.multiplicacao(multiplicando, multiplicador) == pytest.approx(produto)

## Divisão
@pytest.mark.parametrize("dividendo,divisor,quociente", [
    (10, 1, 10),
    (10, 10, 1),
    (10, -2, -5),
    (1, 3, 0.3333333333),  ## dizima periódica
    (0, 10, 0),            ## Zero dividido por algo
])
def test_divisao(dividendo, divisor, quociente):
    assert ClasseCalculadora.divisao(dividendo, divisor) == pytest.approx(quociente)

## Edge Case, para corrigir divisao por zero
def test_divisao_por_zero():
    with pytest.raises(ZeroDivisionError):
        ClasseCalculadora.divisao(10, 0)


## Potenciação
@pytest.mark.parametrize("base,expoente,potencia_esperada", [
    (2, 5, 32),
    (5, 0, 1),             ## qualquer número^0 = 1
    (2, -1, 0.5),          ## expoente negativo
    (-2, 3, -8),           ## base negativa, expoente impar
    (9, 0.5, 3),           ## raiz via expoente fracionário
])
def test_potencia(base, expoente, potencia_esperada):
    assert ClasseCalculadora.potencia(base, expoente) == pytest.approx(potencia_esperada)


## Porcentagem
@pytest.mark.parametrize("percentual,base_calculo,valor_percentual", [
    (30, 80, 24),
    (100, 50, 50),
    (0, 999, 0),
    (-10, 200, -20),       ## percentual negativo
    (12.5, 200, 25),       ## percentual quebrado
])
def test_porcentagem(percentual, base_calculo, valor_percentual):
    assert ClasseCalculadora.porcentagem(percentual, base_calculo) == pytest.approx(valor_percentual)
## Edge Case Porcentagem
def test_porcentagem_tipo_invalido():
    with pytest.raises(TypeError):
        ClasseCalculadora.porcentagem("30", 80)