print("1 - Soma")
print("2 - Subtração")
print("3 - Multiplicação")
print("4 - Divisão")
operacao = int(input("Digite o número da operação que deseja realizar: "))

if operacao == 1:
    num1 = int(input("Digite o primeiro numero da soma: "))
    num2 = int(input("Digite o segundo numero da soma: "))
    soma = num1 + num2
    print("A soma entre {} e {} é {}".format(num1, num2, soma))