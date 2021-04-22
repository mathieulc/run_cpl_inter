#-------------------------------------------------------------------------------
#                                                                      Restart
#-------------------------------------------------------------------------------

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then
    ${io_getfile} ${INPUTDIRO}/pech12_ini_mercator.nc            ini.nc
    #${io_getfile} ${INPUTDIRO}/pech12_ini_20050101_grd88.nc            ini.nc
    ./partit $JPNI $JPNJ ini.nc 
else
    for ff in ${RESTDIR_IN}/${CEXPER}_????????_rst.*.nc
    do
	${io_getfile} $ff ini${ff/*_rst/}
    done
fi
