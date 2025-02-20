from check import main
#funcao que retorna uma lista com os dois ultimos precos no robot
def GetDescription():
    listPrices = main()
    listCleanReturn = []

    for i in range(0, len(listPrices)):
        listCleanReturn.append(listPrices[i].replace("*", "")[1:])

    return listCleanReturn