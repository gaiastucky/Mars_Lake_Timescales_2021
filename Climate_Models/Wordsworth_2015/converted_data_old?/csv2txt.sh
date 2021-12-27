#!/bin/bash
in="ww15_ln_ro.csv"
out="ww15_ln_ro.txt"

cat $in | tr '[,]' '[\t]' > $out