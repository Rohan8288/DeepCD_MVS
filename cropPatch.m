function [] = cropPatch(path, resolution)
    IM_dir = path.IM_dir;
    IP_dir = path.IP_dir;
    GT_path = path.GT_path;
    image_name = path.image_name;
    
    load(GT_path);
    image_number = size(gt_x, 1);
    point_number = size(gt_x, 2);
    shift = floor(resolution / 2 - 1);
    
    for in = 1:image_number
        fprintf('  crop %s patch\n', image_name(in, :));
        
        image_path = [IM_dir, image_name(in, :)];
        image = imread(image_path);
        image_gray = rgb2gray(image);
        patch_32 = zeros(32, 32, 1, point_number);
        local_norm_patch_32 = zeros(32, 32, 1, point_number);
        patch_64 = zeros(64, 64, 1, point_number);
        local_norm_patch_64 = zeros(64, 64, 1, point_number);
        frame = zeros(2, point_number);
        frame(1, :) = gt_x(in, :);
        frame(2, :) = gt_y(in, :);
        
        for spn = 1:point_number
            x = gt_x(in, spn);
            y = gt_y(in, spn);
            crop_patch = double(image_gray(y - shift:y + shift, x - shift:x + shift));
            resize_patch_32 = imresize(crop_patch, [32, 32]);
            patch_32(:, :, :, spn) = resize_patch_32;
            local_norm_patch_32(:, :, :, spn) = (resize_patch_32 - mean2(resize_patch_32)) / std2(resize_patch_32);
            resize_patch_64 = imresize(crop_patch, [64, 64]);
            patch_64(:, :, :, spn) = resize_patch_64;
            local_norm_patch_64(:, :, :, spn) = (resize_patch_64 - mean2(resize_patch_64)) / std2(resize_patch_64);
        end
        
        global_norm_patch_32 = (patch_32 - repmat(mean(patch_32, 4), 1, 1, 1, point_number)) ...
                               ./ repmat(std(patch_32, 1, 4), 1, 1, 1, point_number);
        global_norm_patch_64 = (patch_64 - repmat(mean(patch_64, 4), 1, 1, 1, point_number)) ...
                               ./ repmat(std(patch_64, 1, 4), 1, 1, 1, point_number);
        
        IPF_dir = [IP_dir, num2str(in), '/'];
        if ~exist(IPF_dir, 'dir')    
			mkdir(IPF_dir);
		end
        IPF_path = [IPF_dir, 'R_', num2str(resolution), '_patch.mat'];
        save(IPF_path, 'patch_32', 'patch_64',  ...
             'global_norm_patch_32', 'global_norm_patch_64', ...
             'local_norm_patch_32', 'local_norm_patch_64', 'frame');
    end
end
