#!/bin/bash

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------
    ${io_getfile} ${INPUTDIRO}/croco_grd.nc                croco_grd.nc
    . ${SCRIPTDIR}/getoce_bry_oce.sh 

else   
    . ${SCRIPTDIR}/getoce_bry_oce.sh
fi

                
	       














