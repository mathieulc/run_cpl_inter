#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------
wrfdir=/ccc/work/cont005/ra0542/massons/now/models/wrf3.7.1/run
for file in ${wrfdir}/*TBL  ${wrfdir}/ozone* ${wrfdir}/RRTM*
do
  ${io_getfile} ${file} .
done

#-------------------------------------------------------------------------------
#                                                          BDY
#-------------------------------------------------------------------------------
${io_getfile} ${INPUTDIRA}/wrfbdy_d01_${YEAR_BEGIN_JOB}-01-01_${YEAR_BEGIN_JOB}-12-31 wrfbdy_d01

#-------------------------------------------------------------------------------
#                                            Forcing fields (interannual case)
#-------------------------------------------------------------------------------
${io_getfile} ${INPUTDIRA}/wrflowinp_d01_${YEAR_BEGIN_JOB}-01-01_${YEAR_BEGIN_JOB}-12-31_albmodisgs_0060_mydrop wrflowinp_d01
