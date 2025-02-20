from check import main
#funcao que retorna uma lista com os dois ultimos precos no robot
def GetDescription():
    listPrices = main()
    listCleanReturn = []

    for i in range(0, len(listPrices)):
        listCleanReturn.append(listPrices[i].replace("*", "").replace("R$", "").replace(" ", "").replace(",", ".")[1:])

    return listCleanReturn or str("Sem Produtos")

def CleanStringPrice(string):
    return string.replace("R$", "").replace(" ", "").replace(",", ".").replace("🎊PROMOÇÃO!!!🛍️🔥\n\n💸", "")
