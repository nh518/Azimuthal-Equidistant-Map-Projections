% Create and save the rsa_transform C500 after running registration.m
% script.
close all; clear; clc
addpath("functions");

patient_numbers =  [13, 107, 205, 247];
len_patients = length(patient_numbers);

base_folder = "data/CQ500"; 

dcm_folder_fixed = fullfile(base_folder, "CQ500CT105 CQ500CT105/Unknown Study/CT PRE CONTRAST THIN");
fixedVolumeInfo = get_dicoms(dcm_folder_fixed);
fixedVolume = get_volume(fixedVolumeInfo);
fixedVolume = fixedVolume .* (fixedVolume > 1400);
Rfixed = imref3d(size(fixedVolume),fixedVolumeInfo(1).PixelSpacing(2), ...
    fixedVolumeInfo(1).PixelSpacing(1),fixedVolumeInfo(1).SliceThickness);

for j=1:len_patients
%     fprintf("\tmy print %d %d \n", j, len_patients)
    patient_n = patient_numbers(j);

    % LOAD THE MOVING PATIENT DICOM
    head_folder = sprintf("CQ500CT%d CQ500CT%d", patient_n, patient_n);
    folder = fullfile(base_folder, head_folder); 

    % FIND THE FOLDER THAT CONTAIS THE WORD THIN. IF NOT FIND 0.625
    dicom_folder = dir(fullfile(folder, '*', '*')); 
    success = 0;
    folder_name = [];
    for k=1:length(dicom_folder)
        if contains(lower(dicom_folder(k).name), 'thin')
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
    
    Rmoving = imref3d(size(movingVolume),movingVolumeInfo(1).PixelSpacing(2), ...
        movingVolumeInfo(1).PixelSpacing(1),movingVolumeInfo(1).SliceThickness);
    triple_trans_path = fullfile(folder, "triple_transformation.mat");
    load(triple_trans_path);
    
    tform = applyTripleTransformation(tform_aff, tform_sim, tform_rig);
    
    movingVolume = imwarp(movingVolume, Rmoving, tform, ...
        "linear", "OutputView", Rfixed);
    
    save(fullfile(folder, "rsa_transform.mat"), 'movingVolume');
    fprintf("\t Finished patient: %d \n", patient_n)
end
