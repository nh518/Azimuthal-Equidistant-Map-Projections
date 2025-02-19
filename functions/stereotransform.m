function transformedVolume = stereotransform(volume)
% Transformation of a 3D volume from r,θ,φ grid to θ,φ,r (not that simple) 
[dim1, dim2, dim3] = size(volume); % Get the dimensions of the image volume
dimProj = max(size(volume));

% Define parameters for projection Th0 is important 
Th0=pi/2; % pi/2 for upper hemishpere, -pi/2 for lower hemisphere
Th1=-pi/2; % pi/2 for upper hemishpere, -pi/2 for lower hemisphere

% Center and maximum radius definition
xo = round(dim1/2); yo = round(dim2/2); zo = round(dim3/2); % center
maxr=sqrt((dim1-xo)^2+(dim2-yo)^2+(dim3-zo)^2);

% Define ranges for each coordinate (spherical coordinates)
Zrange=linspace(0, maxr, dimProj);
Xrange=linspace(-pi, pi, dimProj);
Yrange=linspace(-pi, pi, dimProj);

[a,b,c] = meshgrid(Xrange, Yrange, Zrange);
a = reshape(a,[],1);
b = reshape(b,[],1);
c = reshape(c,[],1);

% Convert to spherical coordinates
[theta_cyl,r_cyl] = cart2pol(a,b);
Theta_sph0=Th0-abs(r_cyl)/2;
Theta_sph1=Th1-abs(r_cyl)/2;
% Theta_sph0=abs(r_cyl)/2;
% Theta_sph1=-abs(r_cyl)/2;
Phi_sph=theta_cyl;
R_sph=c;

% Convert back to cartesian coordinates with respect to the center point
% Theta_sph0 -> upper hemisphere || Theta_sph1-> lower hemisphere
[x0,y0,z0] = sph2cart(Phi_sph,Theta_sph0,R_sph);
[x1,y1,z1] = sph2cart(Phi_sph,Theta_sph1,R_sph);

% Interpolate and reshape to original dimensions
Vq0 = interp3(volume, x0+xo,y0+yo,z0+zo, 'linear');
Vq1 = interp3(volume, x1+xo,y1+yo,z1+zo, 'linear');
Projection_upper = reshape(Vq0, dimProj,dimProj,dimProj);
Projection_lower = reshape(Vq1, dimProj,dimProj,dimProj);

transformedVolume = cat(4,Projection_upper, Projection_lower);
end

