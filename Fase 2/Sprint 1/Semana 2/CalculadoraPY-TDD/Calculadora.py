##Classes da operações
def soma (parcela1, parcela2):
    _validar_input(parcela1, parcela2)
    return parcela1 + parcela2

def subtracao (minuendo, subtraendo):
    _validar_input(minuendo, subtraendo)
    return minuendo - subtraendo

def multiplicacao (multiplicando, multiplicador):
    _validar_input(multiplicando, multiplicador)
    return multiplicando * multiplicador

def divisao (dividendo, divisor):
    _validar_input(dividendo, divisor)
    if divisor == 0:
        raise ZeroDivisionError("Divisão por zero não permitida")
    return dividendo / divisor

def potencia(base, expoente):
    _validar_input(base, expoente)
    return base ** expoente

def porcentagem(percentual, base_calculo):
    _validar_input(percentual, base_calculo)
    return (percentual / 100) * base_calculo


## Tratamento de erro
def _validar_input(*args):
    for arg in args:
        if not isinstance(arg, (int, float)):
            raise TypeError(f"Entrada inválida: {arg}")
