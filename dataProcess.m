clear all;
clc;

sample_number = 5000;
patch_resolution = 64;

data_name = 'herzjesu';
data_dir = ['./data/', data_name, '/'];

path.BB_dir = [data_dir, 'bounding/']; % bounding box directory
path.IM_dir = [data_dir, 'image/']; % image directory
path.image_name = ['0000.png'; '0001.png'; '0002.png'; '0003.png'; '0004.png'; '0005.png'; '0006.png'; '0007.png'];
%path.image_name = ['0000.png'; '0001.png'; '0002.png'; '0003.png'; '0004.png'; '0005.png'; '0006.png'; '0007.png'; '0008.png'; '0009.png'; '0010.png'];
path.PM_dir = [data_dir, 'P/']; % project matrix directory
path.ply_path = [data_dir, 'ply/', data_name, '.ply']; % ply file path
path.GT_path = [data_dir, 'patch/GT.mat']; % ground truth file path

path.IP_dir = [data_dir, 'patch/']; % image descriptor directory
if exist(path.IP_dir, 'dir')
    rmdir(path.IP_dir, 's');
end
mkdir(path.IP_dir);

labelGroundTruth(path, sample_number, patch_resolution);
%cropPatch(path, 32);
%cropPatch(path, 48);
cropPatch(path, 64);
