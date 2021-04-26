
#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
   [ $USE_ATM -eq 1 ] && ${io_putfile} atm.nc ${RESTDIR_OUT}/atm_${CEXPER}_${DATE_END_JOB}.nc
   [ $USE_OCE -eq 1 ] && ${io_putfile} oce.nc ${RESTDIR_OUT}/oce_${CEXPER}_${DATE_END_JOB}.nc

   [$USE_ATM -eq 1 && $USE_OCE -eq 1 ] && ${io_putfile} *atmt_to_ocnt* ${RESTDIR_OUT}/ && ${io_putfile} *ocnt_to_atmt* ${RESTDIR_OUT}/



