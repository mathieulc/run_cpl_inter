#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]
then
    [ ${MONTH_BEGIN_JOB} -le 9 ] && mm=0${MONTH_BEGIN_JOB} || mm=${MONTH_BEGIN_JOB}
    [ ${DAY_BEGIN_JOB}   -le 9 ] && dd=0${DAY_BEGIN_JOB}   || dd=${DAY_BEGIN_JOB}
    ncks -a -h -x -v LAKEMASK ${INPUTDIRA}/wrfinput_d01_${YEAR_BEGIN_JOB}-${mm}-${dd}_albmodisgs_0060_mydrop wrfinput_d01
    ncks -A ${INPUTDIRC}/cplmask_pech12c_pech025w.nc wrfinput_d01   
else
    touch ls_l/getfile_atm_restarts.txt
    for file in `${MACHINE_STOCKAGE} ls ${RESTDIR_IN}/wrfrst_d0?_*`
# for i in ${RESTDIR_IN}/wrfrst_d01_*
    do
	${io_getfile} ${file} . >> ls_l/getfile_atm_restarts.txt
    done
fi
