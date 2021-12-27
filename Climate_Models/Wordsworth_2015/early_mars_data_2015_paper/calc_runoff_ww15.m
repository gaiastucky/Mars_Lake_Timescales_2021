 
clc
close all
clear all

% SNOW:
filename = 'ice_snow_data.mat';
m = matfile(filename);
lon = m.lon;
lat = m.lat;
snow = m.logicesrf_avg;

fileID = fopen('./ww_15_logsnow.txt', 'a');

k = 1
for i=1:length(lat)
    for j = 1:length(lon)
        k
        fprintf(fileID, '%f %f %f \n', lat(i), lon(j), snow(k));
        k = k+1;
    end
end
fclose(fileID);

% RAIN:
filename = 'warm_wet_data.mat';
m = matfile(filename);
lon = m.lon;
lat = m.lat;
rain = m.lograin_avg;

fileID = fopen('./ww_15_lograin.txt', 'a');

k = 1
for i=1:length(lat)
    for j = 1:length(lon)
        k
        fprintf(fileID, '%f %f %f \n', lat(i), lon(j), rain(k));
        k = k+1;
    end
end
fclose(fileID);
