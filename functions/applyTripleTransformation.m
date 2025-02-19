function [outputArg1] = applyTripleTransformation(tform1,tform2, tform3)
%APPLYTRIPLETRANSFORMATION Provide the RSA transformations and the
% function returns the new transfomration object. Remember to provide the 
% transformation in reverse.
if isa(tform1, "affine3d")
    outputArg1 = affine3d(tform1.T * tform2.T * tform3.T);
else
    outputArg1 = affine3d(tform1 * tform2 * tform3);
end