DATANAME=herzjesu
DATANUMBER=8
NORMALIZETYPE=1

RESOLUTION=(64)
NETWORKTYPE=(TFeat_M)
NETWORKTYPE2=(DeepCD_Sp)


for ((j=0; j<${#RESOLUTION[@]}; j=j+1))
do
	for ((i=0; i<${#NETWORKTYPE[@]}; i=i+1))
	do
		th extractOther.lua -dataName $DATANAME -dataNumber $DATANUMBER -resolution ${RESOLUTION[$j]} -networkType ${NETWORKTYPE[$i]} -normalizeType $NORMALIZETYPE
	done
	for ((i=0; i<${#NETWORKTYPE2[@]}; i=i+1))
	do
		th extractDeepCD.lua -dataName $DATANAME -dataNumber $DATANUMBER -resolution ${RESOLUTION[$j]} -networkType ${NETWORKTYPE2[$i]} -normalizeType $NORMALIZETYPE
	done
done
