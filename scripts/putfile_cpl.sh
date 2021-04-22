
#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
    ${io_putfile} sst01.nc ${RESTDIR_OUT}/sstocean01_${CEXPER}_${DATE_END_JOB}.nc
    ${io_putfile} flx01.nc ${RESTDIR_OUT}/flxatmos01_${CEXPER}_${DATE_END_JOB}.nc

