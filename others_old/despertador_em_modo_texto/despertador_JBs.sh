#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Script: despertador em modo texto
# Última atualização: 05/01/2016
#
unset MPP
Th=`date +%H`
Tm=`date +%M`
TS=`date +%S`
horainicial=`date +%k` #Pegando hora atual 0-23
minutoinicial=`date +%M` #Pegando minutos atual 0-59

#kdialog --passivepopup "A Hora agora `echo $horainicial`:`echo $minutoinicial`:`echo $TS`" 6
#horalevantar=`kdialog --inputbox "Em qual hora quer levantar?"`
#minutolevantar=`kdialog --inputbox "Em qual minuto quer levantar?"`

#mpp=`kdialog --title "selecione o diretorio" --getexistingdirectory  ~/`
#export MPP=`echo $mpp`
#TH=$((th - Th))
#TM=$((tm - Tm))

horafinal=0 #Inicializando valor da horafinal

####
#para teste
#horainicial=23
#minutoinicial=37
###

echo "Em qual hora quer levantar?"
read horalevantar
echo "Em qual minuto quer levantar?"
read minutolevantar

if [ $horainicial -gt $horalevantar ]; then #hora inicial maior que hora de levantar
  horafinal=$((24 - $horainicial + $horalevantar))
else
 horafinal=$(($horalevantar - $horainicial))
fi

if [ $minutoinicial -gt $minutolevantar ]; then #minuto inicial maior que o final
  minutofinal=$((60 - $minutoinicial + $minutolevantar))
  horafinal=$(($horafinal-1))
else
   minutofinal=$(($minutolevantar - $minutoinicial))
fi

if [ $horafinal -eq -1 ]; then
    horafinal=23
fi
clear
echo "#Inicial== $horainicial:$minutoinicial"
echo "#Levantar= $horalevantar:$minutolevantar"
echo -e "#Final==== $horafinal:$minutofinal\n"

if [ $horafinal != 0 ]; then
   echo -e "Podera dormir $horafinal:$minutofinal, bom descanso :)\n"
   #sleep "$horafinal"h "$minutofinal"m
else
   echo -e "Podera dormir só $minutofinal minutos, :\ \n"
   #sleep "$minutofinal"m
fi

horainicial=`date +%k` #Pegando hora atual 0-23
minutoinicial=`date +%M` #Pegando minutos atual 0-59
echo -e "Hora atual $horainicial:$minutoinicial\n"

#aumix -v 100 #aumentar volume do canal master
#aumix -p 100 #aumentar volume do canal pcm
#vlc -Z /media/files/videos/* # reproduzir aletóriamente o conteudo da pasta /media/files/videos

TH=$horafinal
TM=$minutofinal
TS=00

##Para teste
#echo $TH
#echo $TM
#echo "$TH:$TM:$TS"
#read enter

if [ $TH -gt 9 ]; then # horafinal maior que 9
    if [ $TM -gt 9 ]; then # minutofinal maior que 9
        ./crono.sh -r `echo $TH`:`echo $TM`:`echo $TS`
    else
        ./crono.sh -r `echo $TH`:`echo 0$TM`:`echo $TS`
  fi
else
    if [ $TM -gt 9 ]; then
        ./crono.sh -r `echo 0$TH`:`echo $TM`:`echo $TS`
  else
        ./crono.sh -r `echo 0$TH`:`echo 0$TM`:`echo $TS`
  fi
fi
