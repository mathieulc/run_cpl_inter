
#-------------------------------------------------------------------------------
#                                                                      Average
#-------------------------------------------------------------------------------

for ff in croco_his.nc croco_avg.nc
do
    mv $ff ${CEXPER}_1d_${DATE_BEGIN_JOB}_${DATE_END_JOB}_$ff
done

#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

for ff in rst.*nc
do
    fff=${CEXPER}_${DATE_END_JOB}_rst${ff/rst.????/}
    ${io_putfile} $ff ${RESTDIR_OUT}/$fff
done
