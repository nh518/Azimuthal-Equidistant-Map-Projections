function infos = get_dicoms(dcm_folder)
% https://stackoverflow.com/questions/36729820/sorting-dicom-images-in-matlab
%// Get all of the files
directory = dcm_folder;
files = dir(fullfile(directory, '*.dcm'));
files = files(~[files.isdir]);
filenames = cellfun(@(x)fullfile(directory, x), {files.name}, 'uni', 0);

%// Ensure that they are actually DICOM files and remove the ones that aren't
notdicom = ~cellfun(@isdicom, filenames);
files(notdicom) = [];

%// Now load all the DICOM headers into an array of structs
infos = cellfun(@dicominfo, filenames);
%// Now sort these by the instance number
[~, inds] = sort([infos.InstanceNumber]);
infos = infos(inds);

%// Now you can loop through and display them
% dcm = dicomread(infos(1));
% him = imshow(dcm, []);
% for k = 1:numel(infos)
%     set(him, 'CData', dicomread(infos(k)));
%     pause(0.1)
% end
end

