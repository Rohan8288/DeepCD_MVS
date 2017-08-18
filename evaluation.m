function [ap, correctMatch] = evaluation(option)
    samplePoint = option.samplePoint;
    networkType = option.networkType;
    isLRC = option.isLRC; % Left Right Consistancy
    isRT = option.isRT;
    dataPath = option.dataPath;
    dataNum = option.dataNumber;
    
    answer = (1:samplePoint)';
    content = load([dataPath, '1/R_64_', networkType, '.mat']);

    if strcmp(networkType, 'DeepCD_2S') || strcmp(networkType, 'DeepCD_Sp') || strcmp(networkType, 'DeepCD_2S_noSTN') || strcmp(networkType, 'DeepCD_2S_new')
        targetDesLead = content.descriptor_lead;
        targetDesComplete = content.descriptor_complete;
    else
        targetDes = content.descriptor;
    end

    ap = zeros(dataNum - 1, 1);
	correctMatch = zeros(dataNum - 1, 1);

    for in = 2:dataNum
        content = load([dataPath, num2str(in), '/R_64_', networkType, '.mat']);
        if strcmp(networkType, 'DeepCD_2S') || strcmp(networkType, 'DeepCD_Sp') || strcmp(networkType, 'DeepCD_2S_noSTN') || strcmp(networkType, 'DeepCD_2S_new')
            sourceDesLead = content.descriptor_lead;
            sourceDesComplete = content.descriptor_complete;

            distanceMatLead = L2D(targetDesLead, sourceDesLead);
            distanceMatComplete = L2D(targetDesComplete, sourceDesComplete);
            distanceMat = distanceMatLead .* distanceMatComplete;
        else
            sourceDes = content.descriptor;
            distanceMat = L2D(targetDes, sourceDes);
        end

        [~, matchIndBackward] = min(distanceMat);
        [sortScore, sortInd] = sort(distanceMat, 2);
		matchIndForward = sortInd(:, 1);

		if isRT
            matchScoreForward = sortScore(:, 1) ./ sortScore(:, 2);
        else
            matchScoreForward = sortScore(:, 1);
        end
        
        correctMatchForward = (matchIndForward == answer);

        if isLRC
            score = [];
            correct = [];

            for i = 1:samplePoint
               if matchIndBackward(matchIndForward(i)) == i
                   score = [score, matchScoreForward(i)];
                   correct = [correct, correctMatchForward(i)];
               end
            end
        else
            score = matchScoreForward;
            correct = correctMatchForward;
        end

        [~, sortInd] = sort(score);
        sortCorrect = correct(sortInd);
        effectivePointNum = length(correct);
        precision = zeros(1, effectivePointNum);
        recall = zeros(1, effectivePointNum);

        for i = 1:effectivePointNum
            precision(i) = sum(sortCorrect(1:i)) / i;
            recall(i) = sum(sortCorrect(1:i)) / effectivePointNum;
        end

        for i = 1:effectivePointNum - 1
            ap(in - 1) = ap(in - 1) + (precision(i + 1) + precision(i)) * (recall(i + 1) - recall(i)) / 2;
        end
        correctMatch(in - 1) = sum(correct);
    end
end
