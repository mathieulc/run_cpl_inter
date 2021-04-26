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
	cp ${CROCO_IN_DIR}/${nn}_croco.in.base ${namfile}
	SUBTIME=$( sed -n -e "$(( 2 * ${nn} )) p" AGRIF_FixedGrids.in | awk '{print $7 }' )
    else
	namfile=croco.in
	cp ${CROCO_IN_DIR}/croco.in.base ${namfile}
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
#    sed -e "s/<dt>/${TSP_OCE_2}/"     \
#	-e "s/<ntimes>/${OCE_NTIMES}/"     \
#	-e "s/<ntimeshis>/$(( 2 * ${OCE_NTIMES} ))/"     \
#	-e "s/<ntimesavg>/${OCE_NTSP_DAY}/"     \
#	${namfile} > namelist.tmp

sed -e "s/<ocentimes>/${OCE_NTIMES}/g" -e "s/<ocedt>/${TSP_OCE_2}/g"   -e "s/<ocendtfast>/${TSP_OCEF}/g" \
    -e "s/<oce_nrst>/${OCE_NTIMES}/g"   -e "s/<oce_nhis>/${oce_nhis}/g" -e "s/<oce_navg>/${oce_navg}/g"     \
    -e "s/<yr1>/${YEAR_BEGIN_JOB}/g"             -e "s/<mo1>/${MONTH_BEGIN_JOB}/g"           \
    -e "s/<yr2>/${YEAR_END_JOB}/g"             -e "s/<mo2>/${MONTH_END_JOB}/g"           \
    ${namfile} > namelist.tmp

    mv namelist.tmp ${namfile}
#
#cat namelist
#
done


exit






