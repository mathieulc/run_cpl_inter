#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then
    ${io_getfile} ${INPUTDIRO}/croco_ini.nc                  croco_ini.nc
else
    for ff in ${RESTDIR_IN}/${CEXPER}_????????_rst.*.nc
    do
	${io_getfile} $ff croco_ini.nc # ${ff/*_rst/}
    done
fi
