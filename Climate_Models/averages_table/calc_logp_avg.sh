#!/bin/bash

# Dec 2020; Gaia Stucky de Quay
# Script to calculate log average value of precipitation/runoff from
# global climate models on Mars. Also calculates standard dev. 

# Input models:
model="s19_1b_50km_RAC_D" #Models you can extract:
#ww15_rain #ww15_snow
#k20_05bar #k20_10bar #k20_15bar #k20_20bar
#g20_10mGEL #g20_10mGEL_obliq45 #g20_10mGEL_obliq0 #g20_100mGEL #g20_100mGEL_obliq0 #g20_500mGEL
#s19_1b_50km_RAC_D #s19_1b_50km_RIC_C #s19_1b_100km_RAC_D #s19_150mb_100km_RIC_C

# Find input data: (pay attention to units!) Want to convert to mm / yr
if [ $model == 'ww15_rain' ]; then
	#indir="../Wordsworth_2015/early_mars_data_2015_paper/ww_15_rain.txt" #units: (m / Mars yr)/r_avg* --> *check this is right
	indir="../Wordsworth_2015/early_mars_data_2015_paper/ww_15_lograin.txt" #units:  LOG (m / Mars yr)/r_avg* --> *check this is right : I think it's not normalized
elif [ $model == 'k20_05bar' ] || [ $model == 'k20_10bar' ] || [ $model == 'k20_15bar' ] || [ $model == 'k20_20bar' ] ; then
	indir="../Kamada_2020/Data/${model}.txt" #units: mm / yr
elif [ $model == 's19_1b_50km_RAC_D' ] || [ $model == 's19_1b_50km_RIC_C' ] || [ $model == 's19_1b_100km_RAC_D' ] || [ $model == 's19_150mb_100km_RIC_C' ]; then
	indir="../Steakley_2019/Data/${model}.txt" #units: cm / 10 year
elif [ $model == 'g20_10mGEL' ] || [ $model == 'g20_10mGEL_obliq45' ] || [ $model == 'g20_10mGEL_obliq0' ] || [ $model == 'g20_100mGEL' ] || [ $model == 'g20_100mGEL_obliq0' ] || [ $model == 'g20_500mGEL' ]; then
	indir="../Guzewich_2020/EGU_abstract_data/${model}.txt" #units: mm / year
fi

# NONE OF THEM ACTUALLY HAVE ZERO VALUES SO THIS IS NOT NECESSARY
# Extract data on 0 (zero) values
echo "#######"
gmt info $indir #Show data
echo "Model running: $model"
nrows=$(gmt info -L2 $indir | grep 'N = ' | awk '{print $4}'); echo "Number of points: " $nrows #output number of rows
zeros_pc=$(awk -v var=$nrows '$3 == 0 {count++} END {print (count/var)*100}' $indir)
echo "Zero values: ${zeros_pc} %"
echo "#######"

val=0
# Extract precipitation values and convert to mm/yr:
if [ $model == 'ww15_rain' ]; then # two options, without zeros and with detection limit/2
	#awk '{if ($3!=0) print log($3*(365/687)*1000)/log(10)}' $indir > ./p_columns/${model}_logp.txt #{mulitply by ravg=0.4}-NO! and e-2-m yrs = 687/365
	awk '{if ($3!=0) print log((10^($3))*(365/687)*1000)/log(10)}' $indir > ./p_columns/${model}_logp.txt #put it back into nonlog, then do changes, then back into log
elif [ $model == 'k20_05bar' ] || [ $model == 'k20_10bar' ] || [ $model == 'k20_15bar' ] || [ $model == 'k20_20bar' ]; then #calculate both MAX and MIN scenarios
	awk '{if ($3!=0) print log($3)/log(10)}' $indir > ./p_columns/${model}_logp.txt #units already in mm/yr
elif [ $model == 's19_1b_50km_RAC_D' ] || [ $model == 's19_1b_50km_RIC_C' ] || [ $model == 's19_1b_100km_RAC_D' ] || [ $model == 's19_150mb_100km_RIC_C' ]; then #calculate both MAX and MIN scenarios
	awk '{if ($3!=0) print log($3*10)/log(10)}' $indir > ./p_columns/${model}_logp.txt #convert from cm/10yr to mm/yr
elif [ $model == 'g20_10mGEL' ] || [ $model == 'g20_10mGEL_obliq45' ] || [ $model == 'g20_10mGEL_obliq0' ] || [ $model == 'g20_100mGEL' ] || [ $model == 'g20_100mGEL_obliq0' ] || [ $model == 'g20_500mGEL' ]; then
	awk '{if ($3!=0) print log($3)/log(10)}' $indir > ./p_columns/${model}_logp.txt #units already in mm/yr
fi


echo "Data info (Unlogged/unedited):" #<--- coincides with R_avg = 0.4 given by Wordsworth!
awk '{print $3}' $indir  | awk '{if($1!="-inf"){count++;sum+=$1};y+=$1^2} END{sq=sqrt(y/NR-(sum/NR)^2);sq=sq?sq:0;print "Mean (mm/yr) = "sum/count ORS "S.D = ",sq ORS "#######"}'
# Need to deal with zero values... two different ways below:
echo "Data info (truncating 0's):" # Remove zero value (makes mean bigger, but simpler)
#awk '{if($1!="-inf"){count++;sum+=$1};y+=$1^2} END{sq=sqrt(y/NR-(sum/NR)^2);sq=sq?sq:0;print "Mean = "sum/count ORS "S.D = "sq ORS "#######"}'  ./p_columns/${model}_logp.txt #original
awk '{if($1!="-inf"){count++;sum+=$1};y+=$1^2} END{sq=sqrt(y/NR-(sum/NR)^2);sq=sq?sq:0;print "Mean (mm/yr) = "10^(sum/count) ORS "S.D+ = "((10^((sum/count)+sq))-10^(sum/count)) ORS "S.D- = "(10^(sum/count)-(10^((sum/count)-sq))) ORS "#######"}'  ./p_columns/${model}_logp.txt
echo "Data info (using detection limit/2):" # Add constant to zero values
minval=$(gmt info -C ./p_columns/${model}_logp.txt | awk '{print $1}') # What is the minimum that is not zero? i.e., "detection limit"
awk -v var=${minval} '{if ($3==0) print log((10^var)/2.)/log(10)}' $indir >> ./p_columns/${model}_logp.txt
awk '{if($1!="-inf"){count++;sum+=$1};y+=$1^2} END{sq=sqrt(y/NR-(sum/NR)^2);sq=sq?sq:0;print "Mean (mm/yr) = "10^(sum/count) ORS "S.D+ = "((10^((sum/count)+sq))-10^(sum/count)) ORS "S.D- = "(10^(sum/count)-(10^((sum/count)-sq)))}'  ./p_columns/${model}_logp.txt
#awk '{if($1!="-inf"){count++;sum+=$1};y+=$1^2} END{sq=sqrt(y/NR-(sum/NR)^2);sq=sq?sq:0;print "Mean = "sum/count ORS "S.D = "sq ORS "#######"}'  ./p_columns/${model}_logp.txt #original



