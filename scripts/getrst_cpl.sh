#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then
    cpfile ${INPUTDIRC}/rst_oa3mct_pech12c.nc   sst01.nc
    cpfile ${INPUTDIRC}/rst_oa3mct_pech025w.nc  flx01.nc
else   
    cpfile ${RESTDIR_IN}/sstocean01_*.nc  sst01.nc
    cpfile ${RESTDIR_IN}/flxatmos01_*.nc  flx01.nc
fi
