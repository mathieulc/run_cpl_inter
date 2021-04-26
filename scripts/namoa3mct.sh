#!/bin/ksh
set -ue
#set -vx
#
. ./caltools.sh
##
##======================================================================
##----------------------------------------------------------------------
##    II. modify namcouple
##----------------------------------------------------------------------
##======================================================================
##
#

echo ' '
echo '-- OASIS inputs --------------'
echo 'fill oasis namcouple'

sed -e "s/<runtime>/$(( ${TOTAL_JOB_DUR} * 86400 ))/g" \
    -e "s/<cpldt>/${CPL_FREQ}/g"     \
    -e "s/<atmdt>/${TSP_ATM}/g"   -e "s/<atmnx>/${atmnx}/g"   -e "s/<atmny>/${atmny}/g"  \
    -e "s/<wavdt>/${TSP_WW3}/g"   -e "s/<wavnx>/${wavnx}/g"   -e "s/<wavny>/${wavny}/g"  \
    -e "s/<ocedt>/${TSP_OCE}/g"   -e "s/<ocenx>/${ocenx}/g"   -e "s/<oceny>/${oceny}/g"  \
    ${OASIS_IN_DIR}/inputs_oasis/${file} > ./namcouple

