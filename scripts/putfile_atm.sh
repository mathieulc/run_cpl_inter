#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------

mv wrfout.nc ${CEXPER}_1d_${DATE_BEGIN_JOB}_${DATE_END_JOB}_wrfout.nc
rm -f wrfout_d01_${YEAR_BEGIN_JOB}-*
mv section_20s.nc ${CEXPER}_1h_${DATE_BEGIN_JOB}_${DATE_END_JOB}_section_20s.nc
mv wrfhf2d.nc ${CEXPER}_1h_${DATE_BEGIN_JOB}_${DATE_END_JOB}_wrfhf2d.nc
#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------
year=`printf "%02d"   ${YEAR_BEGIN_JOBp1}`
#echo year: ${year}
month=`printf "%02d"   ${MONTH_BEGIN_JOBp1}`
#echo month: ${month}
day=`printf "%02d"   ${DAY_BEGIN_JOBp1}`
#echo day: ${day}
date_rst="${year}-${month}-${day}"
echo date_rst = ${date_rst}

   for i in  wrfrst_d0?_${date_rst}_* 
   do
     ${io_putfile} $i ${RESTDIR_OUT}
   done

