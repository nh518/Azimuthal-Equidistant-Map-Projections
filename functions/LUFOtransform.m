function [LUFO] = LUFOtransform(volume)
r_vol = imrotate3(volume, 90, [1 0 0]);
d = size(volume,1)-size(r_vol, 1);

if mod(d,2) == 1
    r_vol = padarray(r_vol, floor(d/2)+1, 0, 'both');
    r_vol = r_vol(1:size(volume,1),:,:);
else
    r_vol = padarray(r_vol, floor(d/2), 0, 'both');
end

if all(size(r_vol) == [size(volume,1) size(volume,1) size(volume,1)])
    warning("Dimensions should be %d \n", size(volume,1));
end

stereo = stereotransform(volume);
Upper = stereo(:,:,:,1);
Lower = stereo(:,:,:,2);

stereo = stereotransform(r_vol);
Frontal = stereo(:,:,:,1);
Occipital = stereo(:,:,:,2);

LUFO = cat(4,Lower, Upper, Frontal, Occipital);
end
