
############################# from namelist_exp.sh #############################
#===============================================================================
#  Namelist for the experiment
#===============================================================================

#-------------------------------------------------------------------------------
#  Config : Ocean - Atmosphere - Coupling
#-------------------------------------------------------------------------------
export CONFIG=CARAIBE_OWA
export RUN=owa

export USE_XIOS=0  
export USE_ATM=1  
export USE_OCE=1
export USE_WW3=0
export USE_ICE=0
export USE_CPL=$(( ${USE_ATM} * ${USE_OCE} + ${USE_ATM} * ${USE_WW3} + ${USE_OCE} * ${USE_WW3}))

export AGRIFZ=0
export AGRIF_NAMES=""

# Namelist files
# ----------------------------
# OASIS namelist
export namcouplename=namcouple.base.${RUN}
# WRF namelist
export wrfnamelist=namelist.input.prep.CARAIBE.${RUN}
export NB_dom=1 # Number of coupled domains
export wrfcpldom='d01'

# Forcing (if needed)
# CROCO
export inputlist='bry_SODA' # frc to add
#-------------------------------------------------------------------------------
#  Nombre of core used
#-------------------------------------------------------------------------------
MPI_LAUNCH_CMD=$MPI_LAUNCH
export NXIOS=16 # 4
#
### IF COMPILE CROCO ONLINE ###
#export XI_RHO=359 
#export ETA_RHO=725

### PROC CROCO ###
export NP_CRO=8
#export JPNJ=32

### PROC WRF ###
export NP_WRF=8
# MPI Settings for WRF 
export wrf_nprocX=-1      # -1 for automatic settings
export wrf_nprocY=-1      # -1 for automatic settings
export wrf_niotaskpg=0    # 0 for default settings
export wrf_niogp=1        # 1 for default settings


### PROC WW3 ###
export NP_WW3=12

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
export EXP_DUR_MTH=$(( 12 * 1 ))
export EXP_DUR_DAY=0
#                                                                  Period of Job
export YEAR_BEGIN_JOB=2005
export MONTH_BEGIN_JOB=1
export DAY_BEGIN_JOB=1
#                                                            Duration of the Job
export JOB_DUR_MTH=1
export JOB_DUR_DAY=0

#-------------------------------------------------------------------------------
#  Time Steps
#-------------------------------------------------------------------------------
### WRF ###
export TSP_ATM=120   # 100 90 75 72 60 45

### CROCO ###
export TSP_OCE=1200
export TSP_OCEF=60

### WW3 ###
export TSP_WW3=480     # TMAX = 3*TCFL
export TSP_WW_PRO=160  # TCFL --> ww3.grid to see the definition
export TSP_WW_REF=320  # TMAX / 2
export TSP_WW_SRC=8

### ICE ###
export TSP_ICE=-1

export CPL_FREQ=3600
#export TIMEsnd=20000 # NO NEED on datarmor

#-------------------------------------------------------------------------------
# Grids sizes
#-------------------------------------------------------------------------------
export atmnx=121 ; export atmny=51
export wavnx=413 ; export wavny=172
export ocenx=413 ; export oceny=172
export hmin=75; # minimum water depth in CROCO, delimiting coastline in WW3 

#-------------------------------------------------------------------------------
#  Output Settings
#-------------------------------------------------------------------------------

#WRF
export wrf_his_h=1                        # output interval (h)
export wrf_his_frames=1000 # $((31*24))          # nb of outputs per file
export wrf_diag_int_m=$((${wrf_his_h}*60))  # diag output interval (m)
export wrf_diag_frames=1000 #$wrf_his_frames    # nb of diag outputs per file

# CROCO
#export oce_nrst=144  # in namcroco rst is equal to ocean time  # restart interval (in number of timesteps) 
export oce_nhis=36     # history output interval (in number of timesteps) 
export oce_navg=144     # average output interval (in number of timesteps) 



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
#export      COMPDIR=${RUNDIR}/compile
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
export    jobname="job_${ROOT_NAME_1}.pbs"


#-------------------------------------------------------------------------------
#  Which Computer?
#-------------------------------------------------------------------------------
if [ `hostname  |cut -c 1-5` == "curie" ]; then
   export QSUB="ccc_msub"
   export COMPUTER="CURIE"
elif [ `hostname  |cut -c 1-6` == "vargas" ]; then
   export QSUB="llsubmit"
   export COMPUTER="VARGAS"
elif [ `hostname  |cut -c 1-8` == "datarmor" ]; then
   export QSUB="qsub"
   export COMPUTER="DATARMOR"
else
#elif [ `hostname  |cut -c 1-7` == "service" ]; then 
   export QSUB="qsub"
   export COMPUTER="JADE"
fi
