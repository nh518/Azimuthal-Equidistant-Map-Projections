% THIS SCRIPT IS TO RUN THE REGISTRATION TO CREATE THE TFORM AND TO SAVE 
% IT TO EACH PATIENT'S FOLDER. THE RIGID, SIMILARITY AND AFFINE 
% TRANSFORMATION IS IMPLEMENTED AND THE RESIDUAL IS SAVED AS results.mat.
% EDITED FOR PARALLEL COMPUTING ON HPC

% Excluded patient numbers for the following reasons:
% 43 (oral), 
% {61, 75, 133, 240, 334} (3mm), 
% 120 (corrupted), 
% {125, 136, 147, 173, 326, 376, 382, 415} (2.55mm)

clear; clc; close all; 
addpath("functions");
tic

patient_numbers =  [13, 107, 205, 247];
len_patients = length(patient_numbers);

base_folder = "data/CQ500"; 

% LOAD THE FIXED PATIENT
dcm_folder_fixed = fullfile(base_folder, "CQ500CT105 CQ500CT105/Unknown Study/CT PRE CONTRAST THIN");
fixedVolumeInfo = get_dicoms(dcm_folder_fixed);
fixedVolume = get_volume(fixedVolumeInfo);
fixedVolume = fixedVolume .* (fixedVolume > 1400);
Rfixed = imref3d(size(fixedVolume),fixedVolumeInfo(1).PixelSpacing(2), ...
    fixedVolumeInfo(1).PixelSpacing(1),fixedVolumeInfo(1).SliceThickness);

fprintf("Starting: RSA transformation \n\n")
parfor j=1:len_patients
    patient_n = patient_numbers(j);

    % LOAD THE MOVING PATIENT DICOM
    head_folder = sprintf("CQ500CT%d CQ500CT%d", patient_n, patient_n);
    folder = fullfile(base_folder, head_folder); 
    
    % Exception, if the triple_transformation exists continue
    if isfile(fullfile(folder, "triple_transformation.mat"))
        fprintf("\t Already there patient: %d \n", patient_n)
        continue
    end

    % FIND THE FOLDER THAT CONTAIS THE WORD THIN. IF NOT FIND 0.625
    dicom_folder = dir(fullfile(folder, '*', '*')); 
    success = 0;
    folder_name = [];
    for k=1:length(dicom_folder)
        if contains(lower(dicom_folder(k).name), 'thin') || contains(lower(dicom_folder(k).name), 'helical')
            folder_name = dicom_folder(k);
            success = success + 1;
        end
    end
    if isempty(folder_name)
        for k=1:length(dicom_folder)
            if contains(lower(dicom_folder(k).name), '0.625')
                folder_name = dicom_folder(k);
                success = success + 1;
            end
        end
    end
    
    if 1 < success
        disp("More than 1 folder found. Last one was used")
    end

    dicom_folder_full = fullfile(folder_name(1).folder, folder_name(1).name);
    movingVolumeInfo = get_dicoms(dicom_folder_full); 
    movingVolume = get_volume(movingVolumeInfo);
    movingVolume = movingVolume .* (movingVolume > 1400); % threshold
    
    check_thickness(fixedVolumeInfo, movingVolumeInfo); 

    Rmoving = imref3d(size(movingVolume),movingVolumeInfo(1).PixelSpacing(2), ...
        movingVolumeInfo(1).PixelSpacing(1),movingVolumeInfo(1).SliceThickness);

    movingRegisteredVolume = triple_transformation(movingVolume, Rmoving, fixedVolume, Rfixed, folder);
    
    fprintf("\t Finished patient: %d \n", patient_n)
end
toc

function movingRegisteredVolume = triple_transformation(movingVolume, Rmoving, fixedVolume, Rfixed, save_path)
[optimizer,metric] = imregconfig("monomodal");

% 1. Rigid transformation
tform_rig = imregtform(movingVolume,Rmoving,fixedVolume,Rfixed, ...
    "rigid",optimizer,metric);
movingRegisteredVolume_rig = imwarp(movingVolume, Rmoving, tform_rig, ...
    "linear", "OutputView", Rfixed);

% 2. Similarity transformation
optimizer.MaximumStepLength = 0.0625/10;
tform_sim = imregtform(movingRegisteredVolume_rig,Rfixed,fixedVolume,Rfixed, ...
    "similarity",optimizer,metric);
movingRegisteredVolume_sim = imwarp(movingRegisteredVolume_rig, Rfixed, tform_sim, ...
    "linear", "OutputView", Rfixed);

% 3. Affine transformation
tform_aff = imregtform(movingRegisteredVolume_sim,Rfixed,fixedVolume,Rfixed, ...
    "affine",optimizer,metric);
% tform = patient_rec.Registration_tform;
movingRegisteredVolume = imwarp(movingRegisteredVolume_sim, Rfixed, tform_aff, ...
    "linear", "OutputView", Rfixed);

if nargin>4
    save(fullfile(save_path, 'triple_transformation.mat'), 'tform_rig', 'tform_sim', 'tform_aff')
end
end
