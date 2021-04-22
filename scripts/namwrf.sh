#!/bin/ksh
set -ue
#set -vx
#
. ./caltools.sh
##
##======================================================================
##----------------------------------------------------------------------
##    II. modify namelist
##----------------------------------------------------------------------
##======================================================================
##
#

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then
  rst="false"
else
  rst="true"
fi

sed -e "s/<yr1>/$YEAR_BEGIN_JOB/"    -e "s/<yr2>/$YEAR_END_JOB/"      \
    -e "s/<mo1>/${MONTH_BEGIN_JOB}/" -e "s/<mo2>/${MONTH_END_JOB}/"   \
    -e "s/<dy1>/${DAY_BEGIN_JOB}/"   -e "s/<dy2>/${DAY_END_JOB}/"     \
    -e "s/<hr1>/00/"                 -e "s/<hr2>/24/"                 \
    -e "s/<nproc_x>/${NPROC_X}/" -e "s/<nproc_y>/${NPROC_Y}/" \
    -e "s/<iofmt>/2/" -e "s/<rst>/$rst/"                               \
    -e "s/<rdt>/${TSP_ATM}/"          \
    -e "s/<hisinth>/6/"     -e "s/<rstinth>/$(( ${TOTAL_JOB_DUR} * 24 ))/"             \
    namelist.base.atm > namelist.input


