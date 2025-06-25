% 04/02/2025
clc; clear; close all; tic;
addpath('functions')

% CQ500CT107 CQ500CT107
patient_code = 'globe'; % Change the patient code to 'globe' for the example.
root_dir = "../data/CQ500"; 

if strcmp(patient_code, 'globe')
    bone_thresh = 0;
    vol = load("globe.mat").CT;
    parent_dir = "./";
    slice_end = 100;
else
    bone_thresh = 1200;
    % Set parent directory to the CQ500
    patient_code = string(['CQ500CT' patient_code ' CQ500CT' patient_code]);
    parent_dir = fullfile(root_dir, patient_code);
    load(fullfile(parent_dir, 'rsa_transform.mat'));
    vol = movingVolume;
    slice_end = 300;
end

figure
fig = volshow(vol .* (vol>bone_thresh));
fig.BackgroundColor = [1 1 1];
fig.CameraPosition = [2.2680 -2.7220 0.5068];
fig.CameraUpVector = [0.1899 -0.1941 0.9624];
%%

lufofile = fullfile(parent_dir, 'LUFO.mat');
if exist(lufofile, 'file') == 2
    LUFO = load(lufofile);
    
    Lower = LUFO.Lower;
    Upper = LUFO.Upper;
    Frontal = LUFO.Frontal;
    Occipital = LUFO.Occipital;
else
    % Step 1: Transform the volume or load
    LUFO = LUFOtransform(vol);

    % Step 2: Divide the volume
    Lower = squeeze(LUFO(:,:,:,1));
    Upper = squeeze(LUFO(:,:,:,2));
    Frontal = squeeze(LUFO(:,:,:,3));
    Occipital = squeeze(LUFO(:,:,:,4));
    
    save(lufofile, 'Lower', 'Upper', 'Frontal', 'Occipital');
end
toc
%%
output_dir = '../output';

if ~exist(output_dir, 'dir')  % Check if folder exists
    mkdir(output_dir);        % Create the folder
    fprintf('Folder created: %s\n', output_dir);
else
    fprintf('Folder already exists: %s\n', output_dir);
end

% Step 3: Visualize the mapped volumes
figure;
lufo=Lower .* (Lower > bone_thresh); 
m = volshow(lufo(:,:,1:slice_end)); 
m.BackgroundColor = 'white'; 
m.CameraPosition = [3 3 3.5];
saveas(gcf, fullfile(output_dir, 'Vol_lower.png'));

figure;
lufo=Upper .* (Upper > bone_thresh); 
m = volshow(lufo(:,:,1:slice_end)); 
m.BackgroundColor = 'white';
m.CameraPosition = [-3 3 2.5];
saveas(gcf, fullfile(output_dir, 'Vol_upper.png'));


figure;
lufo=Frontal .* (Frontal > bone_thresh); 
m = volshow(lufo(:,:,1:slice_end)); 
m.BackgroundColor = 'white'; 
m.CameraPosition = [3 -3 3.5];
saveas(gcf, fullfile(output_dir, 'Vol_frontal.png'));

figure;
lufo=Occipital .* (Occipital > bone_thresh); 
m = volshow(lufo(:,:,1:slice_end)); 
m.BackgroundColor = 'white'; 
m.CameraPosition = [3 -3 3.5];
saveas(gcf, fullfile(output_dir, 'Vol_occipital.png'));

%%
% Step 4: Visualize the MIP
figure;
imshow(max(Lower, [], 3), []);
saveas(gcf, fullfile(output_dir, 'MIP_lower.png'));

figure;
imshow(max(Upper, [], 3), []);
saveas(gcf, fullfile(output_dir, 'MIP_upper.png'));

figure;
imshow(max(Frontal, [], 3), []);
saveas(gcf, fullfile(output_dir, 'MIP_frontal.png'));

figure;
imshow(max(Occipital, [], 3), []);
saveas(gcf, fullfile(output_dir, 'MIP_occipital.png'));
