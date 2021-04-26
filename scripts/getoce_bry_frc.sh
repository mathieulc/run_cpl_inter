#!/bin/bash


for file in ${inputlist}; do
    #[ $file == *'bry'* ] && time_name='bry_time'
    for i in `seq 0 $(( ${JOB_DUR_MTH}-1 ))`; do
        echo $i
        if [ ${JOB_DUR_MTH} -eq 1 ]; then
            cur_Y=$( echo $DATE_BEGIN_JOB | cut -c 1-4 )
            cur_M=$( echo $DATE_BEGIN_JOB | cut -c 5-6 )
            ln -sf ${INPUTDIRO}/croco_bry_SODA_Y${curY}M${cur_M}.nc croco_bry.nc
        elif [ ${i} -eq 0 ]; then
            echo 'ICI'
            cur_Y=$( echo $DATE_BEGIN_JOB | cut -c 1-4 )
            cur_M=$( echo $DATE_BEGIN_JOB | cut -c 5-6 )
            ncks -O --mk_rec_dmn bry_time ${INPUTDIRO}/croco_bry_SODA_Y${cur_Y}M${cur_M}.nc ${INPUTDIRO}/croco_bry_SODA_Y${cur_Y}M${cur_M}.nc
            ncks -O -F -d bry_time,1,2 ${INPUTDIRO}/croco_bry_SODA_Y${cur_Y}M${cur_M}.nc croco_bry.nc
        else
            mdy=$( valid_date $(( $MONTH_BEGIN_JOB + $i )) $DAY_BEGIN_JOB $YEAR_BEGIN_JOB )
            cur_Y=$( printf "%04d\n"  $( echo $mdy | cut -d " " -f 3) )
            cur_M=$( printf "%02d\n"  $( echo $mdy | cut -d " " -f 1) )
            if [ $i -eq $(( ${JOB_DUR_MTH}-1 )) ]; then
                ncks -O -F -d bry_time,2,3 ${INPUTDIRO}/croco_bry_SODA_Y${cur_Y}M${cur_M}.nc croco_bry_end.nc
                ncrcat -O croco_bry.nc croco_bry_end.nc croco_bry.nc
                \rm -f croco_bry_end.nc
            else
                echo $cur_Y $cur_M
                ncks -O -F -d bry_time,2 ${INPUTDIRO}/croco_bry_SODA_Y${cur_Y}M${cur_M}.nc croco_bry_cur.nc
                ncrcat -O croco_bry.nc croco_bry_cur.nc croco_bry.nc
                \rm -f croco_bry_cur.nc
            fi
        fi
    done
done
