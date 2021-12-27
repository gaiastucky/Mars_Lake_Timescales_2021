%% VN_dens_plot.m
% plot VN drainage density vs. LMDG GCM model output
% Robin Wordsworth

close all
clear all

cMAX = 1;
cMIN = cMAX - 10;
clevs = linspace(cMIN,cMAX,14);
clevs = [0 clevs];

load valley_matlab.mat
load ice_snow_data.mat 

%% plot VN data

nlatD = 251;
nlonD = 718;
temp = reshape(X,[nlonD nlatD]); lonD = temp(:,1);
temp = reshape(Y,[nlonD nlatD]); latD = temp(1,:);

subplot(2,1,1)
logVNd = log10(VNd);
logVNd = log10(VNd/mean(mean(VNd)));
contourf(lonD,latD,logVNd',clevs, 'LineStyle', 'none' );
xlabel('longitude [deg]')
ylabel('latitude [deg]')
title('VN drainage density log_{10}[km/km^2]')
colorbar vert
caxis([cMIN cMAX])
axis([-180 180 -90 90])

%% plot model data
subplot(2,1,2)
contourf(lon,lat,logicesrf_avg',clevs, 'LineStyle', 'none' );
xlabel('longitude [deg]')
ylabel('latitude [deg]')
title('log_{10} ice / snow buildup [kg/m^2]')
colorbar vert
caxis([cMIN cMAX])
axis([-180 180 -90 90])

h = colormap(jet);
h = [0.5 0.5 0.5; h];
colormap(h)

%% load epoch data
load epoch_data

X2d     = reshape(X,[500 250]); X1d = X2d(:,1);
Y2d     = reshape(Y,[500 250]); Y1d = Y2d(1,:);
[X2,Y2] = meshgrid(X1d,Y1d);
ep2d    = reshape(epochraste,[500 250]);

% interpolate ice/snow to VN grid
[lon2,lat2]   = meshgrid(lon,lat);
[lon2D,lat2D] = meshgrid(lonD,latD);
logsnow_D     = interp2(lon2,lat2,logicesrf_avg',lon2D,lat2D);
area_D        = interp2(lon2,lat2,area',lon2D,lat2D);

% interpolate epoch data to VN grid
ep_D = interp2(X2,Y2,ep2d',lon2D,lat2D);
age_mask = ep_D*0 + 1;
age_mask(ep_D==0)=NaN; % remove Amazonian terrain
age_mask(ep_D==1)=NaN; % remove craters
age_mask(ep_D==2)=NaN; % remove Hesperian

figure(2)
subplot(2,1,1)
contourf(lonD,latD,ep_D, 'LineStyle', 'none' );
xlabel('longitude [deg]')
ylabel('latitude [deg]')
title('epoch of terrain')
colorbar vert
axis equal
axis([-180 180 -90 90])

subplot(2,1,2)
age_mask_disp = age_mask;
age_mask_disp(~(age_mask_disp==age_mask_disp)) = 0.0;
contourf(lonD,latD,age_mask_disp, 'LineStyle', 'none' );
xlabel('longitude [deg]')
ylabel('latitude [deg]')
title('age mask')
colorbar vert
axis equal
axis([-180 180 -90 90])

