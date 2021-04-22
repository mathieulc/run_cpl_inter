#!/bin/bash
set -ue
#set -vx
#
##======================================================================
##======================================================================
## This script automatically modify the CROCO "namelist"
##======================================================================
##======================================================================
#
#
##
##======================================================================
##----------------------------------------------------------------------
##    I. Calendar computations
##----------------------------------------------------------------------
##======================================================================
##
#
# some calendar tools...
#
#                           *** WARNING ***
#   To get back the functions defined in caltools.sh, we have to call 
#   it with ". caltools.sh" instruction. If we directly call "caltools.sh",
#   we will not have the functions back
#
. ./caltools.sh
#
##
##======================================================================
##----------------------------------------------------------------------
##    II. modify namelist
##----------------------------------------------------------------------
##======================================================================
##
#
for nn in $( seq 0 ${AGRIFZ} ) 
do
    if [ ${nn} -gt 0 ] 
    then
	namfile=croco.in.${nn}
	cp ${nn}_namelist.base.oce ${namfile}
	SUBTIME=$( sed -n -e "$(( 2 * ${nn} )) p" AGRIF_FixedGrids.in | awk '{print $7 }' )
    else
	namfile=croco.in
	cp namelist.base.oce ${namfile}
	SUBTIME=1
    fi
    TSP_OCE_2=$(( ${TSP_OCE} / ${SUBTIME} ))
#-------
## Number of time step per day
#-------
    OCE_NTSP_DAY=$(( 86400 / ${TSP_OCE_2} ))
    OCE_NTIMES=$(( ( ${JDAY_END_JOB} - ${JDAY_BEGIN_JOB} + 1 ) * ${OCE_NTSP_DAY}     ))
#
#-------
# change some namelist values
#-------
# General changes
#
    DATE0="${DATE_BEGIN_JOB}"
#
    sed -e "s/<dt>/${TSP_OCE_2}/"     \
	-e "s/<ntimes>/${OCE_NTIMES}/"     \
	-e "s/<ntimeshis>/$(( 2 * ${OCE_NTIMES} ))/"     \
	-e "s/<ntimesavg>/${OCE_NTSP_DAY}/"     \
	${namfile} > namelist.tmp

    mv namelist.tmp ${namfile}
#
#cat namelist
#
done


exit






