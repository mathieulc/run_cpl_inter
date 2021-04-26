#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

    echo 'copy oasis scripts'
    cpfile2 -f $OASIS_IN_DIR/*.sh .

    if [ $USE_ATM -eq 1 ] ; then
   varlist='WRF_d01_EXT_d01_SURF_NET_SOLAR WRF_d01_EXT_d01_EVAP-PRECIP WRF_d01_EXT_d01_SURF_NET_NON-SOLAR WRF_d01_EXT_d01_TAUX WRF_d01_EXT_d01_TAUY WRF_d01_EXT_d01_TAUMOD WRF_d01_EXT_d01_WND_U_01 WRF_d01_EXT_d01_WND_V_01'
   echo 'create restart file for oasis from calm conditions for variables:'$varlist
   ./create_oasis_restart_from_calm_conditions.sh wrfinput_d01 atm.nc wrf "$varlist"
  fi

  if [ $USE_OCE -eq 1 ] ; then
   varlist='SRMSSTV0 SRMSSHV0 SRMVOCE0 SRMUOCE0'
   echo 'create restart file for oasis from calm conditions for variables:'$varlist
   ./create_oasis_restart_from_calm_conditions.sh croco_grd.nc oce.nc croco "$varlist"
  fi

else   
    
    [ $USE_ATM -eq 1 ] && cpfile ${RESTDIR_IN}/atm_${CEXPER}_${DATE_BEGIN_JOB}.nc atm.nc
    [ $USE_OCE -eq 1 ] && cpfile ${RESTDIR_IN}/oce_${CEXPER}_${DATE_BEGIN_JOB}.nc oce.nc
    [$USE_ATM -eq 1 && $USE_OCE -eq 1 ] && cpfile2 ${RESTDIR_IN}/*atmt_to_ocnt* . && cpfile2 ${RESTDIR_IN}/*ocnt_to_atmt* . 

fi
