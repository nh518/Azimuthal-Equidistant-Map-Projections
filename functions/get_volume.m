function vol = get_volume(dcm_info)
% Load Volumes from Dicom
dcm = dicomread(dcm_info(1));
vol = zeros(size(dcm,1), size(dcm,2), numel(dcm_info));
for i=1:size(vol,3)
    vol(:,:,i) = dicomread(dcm_info(i));
end
end

