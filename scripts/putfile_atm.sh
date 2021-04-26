#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------


for dom in `seq $NB_dom`; do
    mv wrfout_d0${dom}_${YEAR_BEGIN_JOB}-* ${CEXPER}_1d_${DATE_BEGIN_JOB}_${DATE_END_JOB}_wrfout_d0${dom}.nc
    mv wrfxtrm_d0${dom}_${YEAR_BEGIN_JOB}-* ${CEXPER}_1d_${DATE_BEGIN_JOB}_${DATE_END_JOB}_wrfxtrm_d0${dom}.nc

    rm -f wrfout_d0${dom}_${YEAR_BEGIN_JOB}-*
    rm -f wrfxtrm_d0${dom}_${YEAR_BEGIN_JOB}-*

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

