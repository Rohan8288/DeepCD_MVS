option.samplePoint = 5000;
option.isLRC = 1; % Left Right Consistancy
option.isRT = 1; % Ratio Test
option.dataPath = './data/fountain/patch/';
option.dataNumber = 11;

networkType = {'DeepDesc_ly', 'DeepDesc_a', 'PNNet', 'TFeat_R', 'TFeat_M', 'DeepCD_2S', 'DeepCD_2S_noSTN', 'DeepCD_2S_new'};
networkNum = size(networkType, 2);
apArray = zeros(networkNum, option.dataNumber - 1);
correctArray = zeros(networkNum, option.dataNumber - 1);

for i = 1:networkNum
	option.networkType = networkType{i};

	[ap, correct] = evaluation(option);
	apArray(i, :) = ap;
	correctArray(i, :) = correct;
end

map = mean(apArray');

for i = 1:networkNum
	fprintf('%s: %f\n', networkType{i}, map(i));
end
