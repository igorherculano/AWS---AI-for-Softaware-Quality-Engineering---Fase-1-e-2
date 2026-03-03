print("1 - Soma")
print("2 - Subtração")
print("3 - Multiplicação")
print("4 - Divisão")
operacao = int(input("Digite o número da operação que deseja realizar: "))

if operacao == 1:
    num1 = float(input("Digite a primeira parcela da soma: "))
    num2 = float(input("Digite a segunda parcela da soma: "))
    soma = num1 + num2
    print("A soma entre {} e {} é {}".format(num1, num2, soma))

elif operacao == 2:
    num1 = float(input("Digite o minuendo  da diferença: "))
    num2 = float(input("Digite o subtraendo da diferença: "))
    diferenca = num1 - num2
    print(f"A diferença entre {num1} e {num2} é {diferenca}")