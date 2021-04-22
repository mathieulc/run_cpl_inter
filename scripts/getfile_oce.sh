#!/bin/bash

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------
    ${io_getfile} ${INPUTDIRO}/pech12_grd.nc                     grd.nc 
    ${io_getfile} ${INPUTDIRO}/pech12_bry_mercatorV22005_2011.nc bry.nc
    #${io_getfile} ${INPUTDIRO}/pech12_bry_20050101_20111231_grd88.nc bry.nc

    ./partit $JPNI $JPNJ grd.nc 
    ./partit $JPNI $JPNJ bry.nc 

else   

    if [ $(( $JPNI * $JPNJ )) -lt 10 ]; then
	mv ../????????_????????*/grd.?.nc .
	mv ../????????_????????*/bry.?.nc .
	nb1=$( ls -1 grd.?.nc | wc -l )
	nb2=$( ls -1 bry.?.nc | wc -l )
    else if [ $(( $JPNI * $JPNJ )) -lt 100 ]; then
	     mv ../????????_????????*/grd.??.nc .
	     mv ../????????_????????*/bry.??.nc .
	     nb1=$( ls -1 grd.??.nc | wc -l )
	     nb2=$( ls -1 bry.??.nc | wc -l )
	 else
	     mv ../????????_????????*/grd.???.nc .
	     mv ../????????_????????*/bry.???.nc .
	     nb1=$( ls -1 grd.???.nc | wc -l )
	     nb2=$( ls -1 bry.???.nc | wc -l )
	 fi
    fi

    if [ $nb1 -ne $(( $JPNI * $JPNJ )) ]; then
	echo "wrong number of grd files..., $nb1 -ne $(( $JPNI * $JPNJ )), we exit"
	exit 111
    fi
    
    if [ $nb2 -ne $(( $JPNI * $JPNJ )) ]; then
	echo "wrong number of bry files..., $nb2 -ne $(( $JPNI * $JPNJ )),we exit"
	exit 222
    fi
    
fi
