# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import netCDF4 as nc
################################################################################

# Import the NETCDF file:
infile = './ROCKE3D_PaleoMars_Precipitation_Aug2020.nc'
ds = nc.Dataset(infile)
# print(ds)
# Look at variables:
for var in ds.variables.values():
    print("list of variables:")
    print(var)
# ANNUAL_PRECIP_10mGEL # ANNUAL_PRECIP_10mGEL_obliq0 # ANNUAL_PRECIP_10mGEL_obliq45
# ANNUAL_PRECIP_100mGEL # ANNUAL_PRECIP_100mGEL_obliq0 # ANNUAL_PRECIP_500mGEL
# units: mm annually
    
# Extract variable you want:
variable = 'ANNUAL_PRECIP_500mGEL'
outfile = 'g20_500mGEL'
ds1 = ds[variable][:,:]
#print(ds1)

# Now let's get x,y,z data:
lat = ds['Latitude'][:]
#print(lat)
lat_len=len(lat)
#print(lat_len)
lon = ds['Longitude'][:]
print("number of lats:", lat_len)
lon_len=len(lon)
print("number of longs:", lon_len)

# Start the loop and output the file:
f = open(f'{outfile}.txt', 'w')
xrange=range(0,lon_len)
yrange=range(0,lat_len)
for x in xrange:
    for y in yrange:
        #print(lon[x],lat[y],ds1[y,x])
        f.write("%s %s %s\n" % (lon[x], lat[y], ds1[y,x]))
f.close()