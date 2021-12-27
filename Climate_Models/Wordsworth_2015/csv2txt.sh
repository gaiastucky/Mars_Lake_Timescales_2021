#!/bin/bash
in="ww15_ro_avg.csv"
out="ww15_ro_avg.txt"

sed 's|,|\t|g' $in > $out