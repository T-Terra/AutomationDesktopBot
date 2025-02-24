def OpenFiles(filePath: str, mode: str, encode: str) -> list:
    with open(filePath, mode, encoding=encode) as file:
        lines = file.readlines()
    
    newList = []

    for line in lines:
        if '\n' in line:
            cleanLine = line.replace('\n', '')
            newList.append(cleanLine)
        else:
            newList.append(line)
        
    return newList