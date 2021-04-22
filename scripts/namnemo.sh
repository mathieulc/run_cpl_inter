#!/bin/ksh
set -ue
#set -vx
#
##======================================================================
##======================================================================
## This script automatically modify the OPA namelist
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
	namfile=${nn}_namelist
	cp ${nn}_namelist.base.oce ${namfile}
	SUBTIME=$( sed -n -e "$(( 2 * ${nn} )) p" AGRIF_FixedGrids.in | awk '{print $7 }' )
    else
	namfile=namelist
	cp namelist.base.oce ${namfile}
	SUBTIME=1
    fi
    TSP_OCE_2=$(( ${TSP_OCE} / ${SUBTIME} ))
#-------
## Number of time step per day
#-------
    OCE_NTSP_DAY=$(( 86400 / ${TSP_OCE_2} ))
#-------
## computation of begin/end time step and number of time steps in job
#-------
    OCE_NIT000=$(( ( ${JDAY_BEGIN_JOB} - ${JDAY_BEGIN_EXP} ) * ${OCE_NTSP_DAY} + 1 ))
    OCE_NITEND=$(( ( ${JDAY_END_JOB} - ${JDAY_BEGIN_EXP} + 1 ) * ${OCE_NTSP_DAY}     ))
    OCE_NSTOCK=$(( ${OCE_NITEND} - ${OCE_NIT000} + 1 ))
#
#-------
# change some namelist values
#-------
# General changes
#
    DATE0="${DATE_BEGIN_JOB}"
#
    sed -e "s/<exp>/${CEXPER}/"         \
	-e "s/<it000>/${OCE_NIT000}/"     \
	-e "s/<itend>/${OCE_NITEND}/"     \
        -e "s/<date0>/${DATE0}/" \
	-e "s/<stock>/${OCE_NITEND}/"     \
	-e "s/<rdt>/${TSP_OCE_2}./"          \
	-e "s/<nn_trd>/${OCE_NTSP_DAY}/"          \
	-e "s/<jpni>/${JPNI}/"          \
	-e "s/<jpnj>/${JPNJ}/"          \
	${namfile} > namelist.tmp1

# RESTART (nn_rstctl is used only if ln_rstart=T)
# Changes only if it is the fist job of the experiment 
    if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]
    then
      if [ ${LEVITUS} -eq 1 ]
      then
	sed -e "s/<rstart>/.FALSE./" \
	    -e "s/<rstartobc>/.FALSE./" \
	    -e "s/<rstartmld>/.FALSE./" \
	    -e "s/<msh>/0/"          \
	    -e "s/<rstctl>/0/"          \
	    namelist.tmp1 > namelist.tmp2
      else
	sed -e "s/<rstart>/.TRUE./" \
	    -e "s/<rstartobc>/.FALSE./" \
	    -e "s/<rstartmld>/.FALSE./" \
	    -e "s/<msh>/0/"          \
	    -e "s/<rstctl>/0/"          \
	    namelist.tmp1 > namelist.tmp2
      fi
    else
# Changes only if we use restart
	sed -e "s/<rstart>/.TRUE./" \
	    -e "s/<rstartobc>/.TRUE./" \
	    -e "s/<rstartmld>/.TRUE./" \
	    -e "s/<msh>/0/"         \
	    -e "s/<rstctl>/0/"          \
	    namelist.tmp1 > namelist.tmp2
    fi

    if [ "${DEBUG}" == "TRUE" ]
    then
      sed -e "s/<ctl>/.true./" namelist.tmp2 > namelist.tmp3
    else
      sed -e "s/<ctl>/.false./" namelist.tmp2 > namelist.tmp3
    fi

    mv namelist.tmp3 ${namfile}
    \rm namelist.tmp?
#
#cat namelist
#
done
#-------
# xmlio_server.def 
#-------
#[ $NCPUOIO -eq 0 ] && useserv=".false." || useserv=".true."
#sed -e "s/<useserv>/$useserv/" xmlio_server.def  > tmpfile
#mv tmpfile xmlio_server.def


exit






