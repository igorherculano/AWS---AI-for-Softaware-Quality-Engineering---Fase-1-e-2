class ClasseCalculadora:
    ## Classes da operações
    @staticmethod
    def soma(parcela1, parcela2):
        ClasseCalculadora._validar_input(parcela1, parcela2)
        return parcela1 + parcela2
    @staticmethod
    def subtracao(minuendo, subtraendo):
        ClasseCalculadora._validar_input(minuendo, subtraendo)
        return minuendo - subtraendo
    @staticmethod
    def multiplicacao(multiplicando, multiplicador):
        ClasseCalculadora._validar_input(multiplicando, multiplicador)
        return multiplicando * multiplicador
    @staticmethod
    def divisao(dividendo, divisor):
        ClasseCalculadora._validar_input(dividendo, divisor)
        if divisor == 0:
            raise ZeroDivisionError("Divisão por zero não permitida")
        return dividendo / divisor
    @staticmethod
    def potencia(base, expoente):
        ClasseCalculadora._validar_input(base, expoente)
        return base ** expoente
    @staticmethod
    def porcentagem(percentual, base_calculo):
        ClasseCalculadora._validar_input(percentual, base_calculo)
        return (percentual / 100) * base_calculo

    ## Tratamento de erro
    @staticmethod
    def _validar_input(*args):
        for arg in args:
            if not isinstance(arg, (int, float)):
                raise TypeError(f"Entrada inválida: {arg}. Apenas números são aceitos.")