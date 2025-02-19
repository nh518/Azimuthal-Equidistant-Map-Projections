function check_thickness(fixedVolumeInfo, movingVolumeInfo)
% Checking if the PixelSpacing and SliceThickness are the same for all dcms
if ~all(all([fixedVolumeInfo.PixelSpacing])) 
    warning("PixelSpacing isn't the same for every dicom in fixedVolume")
elseif ~all(all([movingVolumeInfo.PixelSpacing]))
    warning("PixelSpacing isn't the same for every dicom in movingVolume")
end

if ~all([fixedVolumeInfo.SliceThickness])
    warning("SliceThickness isn't the same for every dicom in fixedVolume")
elseif ~all([movingVolumeInfo.SliceThickness])
    warning("SliceThickness isn't the same for every dicom in movingVolume")
end
end

