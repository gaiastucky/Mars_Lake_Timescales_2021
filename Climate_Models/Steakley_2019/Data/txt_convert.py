# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
################################################################################

# Import the NETCDF file:
infile = './Raw_data/Cprec_10yr_150mb_100km_RIC_caseC.txt'  # CHANGE THIS
outfile = 's19_150mb_100km_RIC_C.txt'                       # CHANGE THIS

f = open(infile,'r')
data = f.readlines()[5:] #ignore comments at the top
f.close()

f = open(infile,'r')
header = f.readlines()[:4] #ignore comments at the top
f.close()
print(header)

lats = data[0]
lats = lats.split()
print(len(lats))
longs = data[1]
longs = longs.split()
print(len(longs))

#data = data.split()
precip = data[2:62] #split in half because we don't want TOPOGRAPHY!


# Start the loop and output the file:
f = open(f'{outfile}', 'w')
xrange=range(0,len(longs))
yrange=range(0,len(lats))
for x in xrange:
    for y in yrange:
        #print(lon[x],lat[y],ds1[y,x])
        # each line in precip is a LONG, use split to get range of LATS
        lon = longs[x]
        lat = lats[y]
        p_list = precip[x]
        p_list = p_list.split()
        p = p_list[y]
        
        print(lon,lat,p)
        f.write("%s %s %s\n" % (lon, lat, p))

f.close()