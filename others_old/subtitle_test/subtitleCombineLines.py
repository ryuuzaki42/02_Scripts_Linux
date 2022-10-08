#!/usr/bin/python3
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Test to combine to subtitle <aux python script>
# Última atualização: 13/07/2022
#

import sys

fileAName = sys.argv[1] # Get parameters
fileBName = sys.argv[2]
fileResult = sys.argv[3]

print("fileAName:", fileAName)
print("fileBName:", fileBName)

fileA = open(fileAName, 'r')
fileB = open(fileBName, 'r')

f = open(fileResult, "w") # File to save the result

continueOrNot = True
while continueOrNot:
    lineA = fileA.readline()
    lineB = fileB.readline()

    while lineA != "\n": # "Empty Line"
        # The strip() method removes any leading (spaces at the beginning) and trailing
        # (spaces at the end) characters (space is the default leading character to remove)

        #print(lineA.strip())
        f.write(lineA.strip() + "\n")
        lineA = fileA.readline()

        if not lineA:
            print("End Of File - ", fileAName)
            continueOrNot = False
            break

    while lineB != "\n":
        #print(lineB.strip())
        f.write(lineB.strip() + "\n")
        lineB = fileB.readline()

        if not lineB:
            print("End Of File - ", fileAName)
            continueOrNot = False
            break

    #print() # Empty line to separate
    f.write("\n")

f.close()
