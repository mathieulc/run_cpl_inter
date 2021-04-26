#-------------------------------------------------------------------------------
#                                                          Configuration files
#-------------------------------------------------------------------------------
# link data files necessary for running wrf in a dedicated directory $wrf/data
if [ ! -d $wrf/data ] ; then
 mkdir $wrf/data
 ln -s $wrf/run/* $wrf/data/.
 # remove executables that could exist and namelist file
 rm -f $wrf/data/*.exe
 rm -f $wrf/data/namelist.input*
fi
echo 'link wrf data files'
echo "ln -sf ${wrf}/data/* ."
ln -sf ${wrf}/data/* .

#-------------------------------------------------------------------------------
#                                                          BDY
#-------------------------------------------------------------------------------
${io_getfile} ${INPUTDIRA}/wrfbdy_d01_${YEAR_BEGIN_JOB}-01-01_${YEAR_BEGIN_JOB}-12-31 wrfbdy_d01  # maybe put month and day of simu istead

#-------------------------------------------------------------------------------
#                                            Forcing fields (interannual case)
#-------------------------------------------------------------------------------
filelist='wrflowin_d01'
for if [ $NB_dom -ge 2 ] ; then
  filelist="$filelist wrflowinp_d02"
  if [ $NB_dom -eq 3 ] ; then
   filelist="$filelist wrflowinp_d03"
  fi
 fi

for file in ${filelist}
 do
    ${io_getfile} ${INPUTDIRA}/${file}_${YEAR_BEGIN_JOB}-01-01_${YEAR_BEGIN_JOB}-12-31 $ ${file}  # add loop for d02 and d03
 done
