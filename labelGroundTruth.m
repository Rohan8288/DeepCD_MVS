function [] = labelGroundTruth(path, sample_number, patch_resolution)
    fprintf('labeling ground truth.\n');

    BB_dir = path.BB_dir;
    image_name = path.image_name;
    PM_dir = path.PM_dir;
    ply_path = path.ply_path;
    GT_path = path.GT_path;
    
    image_number = size(image_name, 1);

    point_cloud = pcread(ply_path);
    point_number = size(point_cloud.Location, 1);
    point = [point_cloud.Location, ones(point_number, 1), (1:point_number)']';
    
    point_pixel_x = -ones(image_number, point_number);
    point_pixel_y = -ones(image_number, point_number);

    for img = 1:image_number
        PMF_id = fopen([PM_dir, '/', image_name(img, :), '.P'], 'r');
        projection_matrix = fscanf(PMF_id, '%g %g %g', [4, inf])';
        BBF_id = fopen([BB_dir, '/', image_name(img, :), '.bounding'], 'r');
        bounding_box = fscanf(BBF_id, '%g %g %g', [3, inf])';

        point_IBB = point; % point in bounding box
        point_IBB(:, point_IBB(1, :) < bounding_box(1, 1) | point_IBB(1, :) > bounding_box(2, 1)) = [];
        point_IBB(:, point_IBB(2, :) < bounding_box(1, 2) | point_IBB(2, :) > bounding_box(2, 2)) = [];
        point_IBB(:, point_IBB(3, :) < bounding_box(1, 3) | point_IBB(3, :) > bounding_box(2, 3)) = [];

        point_camera = projection_matrix * point_IBB(1:4, :);
        point_pixel = [point_camera(1, :) ./ point_camera(3, :);  point_camera(2, :) ./ point_camera(3, :); point_IBB(5, :)];
        
        point_pixel(:, point_pixel(1, :) < 0 + patch_resolution / 2 | point_pixel(1, :) > 3072 - patch_resolution / 2) = [];
        point_pixel(:, point_pixel(2, :) < 0 + patch_resolution / 2 | point_pixel(2, :) > 2048 - patch_resolution / 2) = [];
        point_pixel = round(point_pixel);
        
        point_pixel_x(img, point_pixel(3, :)) = point_pixel(1, :); % 3072
        point_pixel_y(img, point_pixel(3, :)) = point_pixel(2, :); % 2048
        
        fclose(PMF_id);
        fclose(BBF_id);
    end

    for img = 1:image_number
        point_pixel_x(:, point_pixel_x(img, :) == -1) = [];
        point_pixel_y(:, point_pixel_y(img, :) == -1) = [];
    end

    effective_point_number = size(point_pixel_x, 2);

    random_index = randperm(effective_point_number);
    sample_index = random_index(1:sample_number);

    gt_x = point_pixel_x(:, sample_index);
    gt_y = point_pixel_y(:, sample_index);

    save(GT_path, 'gt_x', 'gt_y');
end
