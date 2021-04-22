
############################# from namelist_exp.sh #############################
#===============================================================================
#  Namelist for the experiment
#===============================================================================

#-------------------------------------------------------------------------------
#  Config : Ocean - Atmosphere - Coupling
#-------------------------------------------------------------------------------
export CONFIG=pech12pech025_cow

export USE_XIOS=1  
export USE_ATM=1  
export USE_OCE=1
export USE_ICE=0
export USE_CPL=$(( ${USE_ATM} * ${USE_OCE} ))
export AGRIFZ=0
export AGRIF_NAMES=""

#-------------------------------------------------------------------------------
#  Nombre of core used
#-------------------------------------------------------------------------------
export NXIOS=16 # 4
#
export XI_RHO=359
export ETA_RHO=725
export JPNI=4
export JPNJ=32
#
export NPROC_X=8
export NPROC_Y=32
#
#-------------------------------------------------------------------------------
#  Various
#-------------------------------------------------------------------------------
export DEBUG="FALSE"     
export SCRIPT_DEBUG="FALSE"     
export LEVITUS=0  # for init state  ... si demarrage climato (levitus ou autre)
export TRDMLD=0

#-------------------------------------------------------------------------------
#  1 experiment / n jobs
#-------------------------------------------------------------------------------
# The experiment is divided into jobs (called with "llsubmit" command)

#                                                           Period of Experiment
export YEAR_BEGIN_EXP=2005
export MONTH_BEGIN_EXP=1
export DAY_BEGIN_EXP=1
#                                                     Duration of the Experiment
export EXP_DUR_MTH=$(( 12 * 6 ))
export EXP_DUR_DAY=0
#                                                                  Period of Job
export YEAR_BEGIN_JOB=2011
export MONTH_BEGIN_JOB=1
export DAY_BEGIN_JOB=1
#                                                            Duration of the Job
export JOB_DUR_MTH=3
export JOB_DUR_DAY=0
#-------------------------------------------------------------------------------
#  Time Steps
#-------------------------------------------------------------------------------
export TSP_ATM=60   # 100 90 75 72 60 45
export TSP_OCE=1200
export TSP_ICE=-1
export CPL_FREQ=3600
export TIMEsnd=20000

if [[ ( $YEAR_BEGIN_JOB -eq 0 ) && ( $MONTH_BEGIN_JOB -eq 4 ) ]]
then
    TSP_ATM=50
    TIMEsnd=55000
fi


#
# MODE_TEST: extension du nom de l'experience
#            pour tourner differents tests dans la meme experience
# on peut lancer plusieurs tests en même temps mais pas être en production et lancer des tests
 export         MODE_TEST=""    #   mode Production 
#export         MODE_TEST=".nouvelle_PHYSIQUE" 


#-------------------------------------------------------------------------------
#  Name and directory of the experiment (from the path of the experiment)
#-------------------------------------------------------------------------------
export CEXPER=`pwd | awk -F"/" '{print $(NF-1)}'`
PWD1=$(pwd)
export    RUNDIR=${PWD1%/*}

#-------------------------------------------------------------------------------
#  Directories
#-------------------------------------------------------------------------------
export  JOBDIR_ROOT=${RUNDIR}/jobs
export    SCRIPTDIR=${RUNDIR}/scripts
export      COMPDIR=${RUNDIR}/compile
export     PARAMDIR=${RUNDIR}/param_inputs

#-------------------------------------------------------------------------------
#  Calendar computation
#-------------------------------------------------------------------------------
cd ${SCRIPTDIR}
   . ./caltools.sh
cd - 

#-------------------------------------------------------------------------------
#  Names
#-------------------------------------------------------------------------------
export    ROOT_NAME_1="${CEXPER}_${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export              ROOT_NAME_2="${DATE_BEGIN_JOB}_${DATE_END_JOB}${MODE_TEST}"
export                                ROOT_NAME_3="${DATE_END_JOB}${MODE_TEST}"
export    jobname="job_${ROOT_NAME_1}.sh"


#-------------------------------------------------------------------------------
#  Which Computer?
#-------------------------------------------------------------------------------
if [ `hostname  |cut -c 1-5` == "curie" ]; then
   export QSUB="ccc_msub"
   export COMPUTER="CURIE"
elif [ `hostname  |cut -c 1-6` == "vargas" ]; then
   export QSUB="llsubmit"
   export COMPUTER="VARGAS"
else
#elif [ `hostname  |cut -c 1-7` == "service" ]; then 
   export QSUB="qsub"
   export COMPUTER="JADE"
fi
