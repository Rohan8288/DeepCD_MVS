DATANAME=herzjesu
IMAGENUMBER=8

NETWORKTYPE=(TFeat_M TFeat_R PNNet DeepDesc_a DeepDesc_ly)
NETWORKTYPE2=(DeepCD_2S DeepCD_2S_noSTN DeepCD_Sp DeepCD_2S_new)

for ((i=0; i<${#NETWORKTYPE[@]}; i=i+1))
do
	th extractOther.lua -dataName $DATANAME -imageNum $IMAGENUMBER -networkType ${NETWORKTYPE[$i]}
done
for ((i=0; i<${#NETWORKTYPE2[@]}; i=i+1))
do
	th extractDeepCD.lua -dataName $DATANAME -imageNum $IMAGENUMBER -networkType ${NETWORKTYPE2[$i]}
done

