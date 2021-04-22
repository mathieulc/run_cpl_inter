#!/bin/bash 
set -u
set +x     # pour CURIE

umask 022

#-------------------------------------------------------------------------------
#  Which Computer and modules?
#-------------------------------------------------------------------------------
. ./module.sh
#-------------------------------------------------------------------------------
#  namelist of the experiment
#-------------------------------------------------------------------------------
cp namelist_exp.sh namelist_exp.tmp

cat common_definitions.sh >> namelist_exp.tmp

. ./namelist_exp.tmp

[ ! -d ${JOBDIR_ROOT} ] && mkdir -p ${JOBDIR_ROOT}  # for the first submitjob.sh call

cd ${JOBDIR_ROOT} 
ls ${jobname}  > /dev/null  2>&1 
if [ "$?" -eq "0" ] ; then
   printf "\n\n\n\n  Un fichier ${jobname} existe deja  dans  ${JOBDIR_ROOT} \n             => exit. \n\n  Nettoyer et relancer\n\n\n\n"; exit
fi
cd -
#-------------------------------------------------------------------------------
# calendar computations (to check dates consistency)
#-------------------------------------------------------------------------------
if [ ${USE_CPL} -eq 1 ]; then
  if [ $(( ${CPL_FREQ} % ${TSP_ATM} )) -ne 0 ] || \
     [ $(( ${CPL_FREQ} % ${TSP_OCE} )) -ne 0 ] || \
     [ $(( ${CPL_FREQ} % ${TSP_ICE} )) -ne 0 ] ; then
     printf "\n\n Problem of consistency between Coupling Frequency and Time Step, we stop...\n\n" && exit 1
  fi
fi

. ./caltools.sh

#-------------------------------------------------------------------------------
# create job and submit it
#-------------------------------------------------------------------------------

[ ${USE_OCE}  -eq 1 ] && TOTOCE=$((    $JPNI *    $JPNJ )) || TOTOCE=0
[ ${USE_ATM}  -eq 1 ] && TOTATM=$(( $NPROC_X * $NPROC_Y )) || TOTATM=0
[ ${USE_XIOS} -eq 0 ] && NXIOS=0
totalcore=$(( $TOTOCE + $TOTATM + $NXIOS ))
sed -e "/< insert here variables definitions >/r namelist_exp.tmp" \
    -e "s/<exp>/${ROOT_NAME_1}/g" \
    -e "s/<nmpi>/${totalcore}/g" \
    -e "s/<time_second>/${TIMEsnd}/g" \
    ./header.${COMPUTER} > HEADER_tmp
    cat HEADER_tmp job.base.sh >  ${JOBDIR_ROOT}/${jobname}
    \rm HEADER_tmp
    \rm ./namelist_exp.tmp

cd ${JOBDIR_ROOT}
chmod 755 ${jobname}

printf "\n  HOSTNAME: `hostname`\n     =>    COMPUTER: ${COMPUTER}\n"  
echo
printf "  CONFIG: ${CONFIG}\n"  
printf "  CEXPER: ${CEXPER}\n"  
echo
printf "  jobname: ${jobname}\n"  
echo
printf "  ROOT_NAME_1: ${ROOT_NAME_1}\n"  
printf "  ROOT_NAME_2: ${ROOT_NAME_2}\n"  
printf "  ROOT_NAME_3: ${ROOT_NAME_3}\n"  
#printf "  EXEDIR: ${EXEDIR}\n"  
#printf "  OUTPUTDIR: ${OUTPUTDIR}\n"  
#printf "  RESTDIR_OUT: ${RESTDIR_OUT}\n"  
#printf "  JOBDIR: ${JOBDIR}\n"  


if [ "${SCRIPT_DEBUG}" == "TRUE" ] ; then
   printf "\n\n\n\n  SCRIPT_DEBUG=${SCRIPT_DEBUG}  Mode script debug => Pas de soumission en queue\n\n\n\n"
else
   ${QSUB} ${jobname}
   if [ "${MODE_TEST}" != "" ] ; then
      printf "\n\n\n\n  MODE_TEST=${MODE_TEST}  Mode test et non production => Pas d'enchainement de jobs.\n\n\n\n"
   fi
fi

