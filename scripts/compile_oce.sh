#!/bin/bash
set -ue

if [ ${DATE_BEGIN_JOB} -eq ${DATE_BEGIN_EXP} ]; then

#-------------------------------------------------------------------------------
#   Get files
#-------------------------------------------------------------------------------

    CROCOSRC=/ccc/work/cont005/ra0542/massons/now/models/croco

    rsync -a ${CROCOSRC}/Roms_Agrif/ Roms_Agrif/
    [ ! -d Run ] && rm -rf Run
    mkdir Run
    rsync -a ${CROCOSRC}/Run/param.h   Run/.
    rsync -a ${CROCOSRC}/Run/cppdefs.h Run/.
    rsync -a ${CROCOSRC}/Run/jobcomp   Run/.
    
#-------------------------------------------------------------------------------
#   sed on files
#-------------------------------------------------------------------------------
    cd Run
    
    sed -e "s/-O3 /-O3 -xAVX /" jobcomp > tmp$$
    mv tmp$$ jobcomp

    sed -e "s/NP_XI *= *[0-9]* *,/NP_XI=${JPNI},/" \
	-e "s/NP_ETA *= *[0-9]* *,/NP_ETA=${JPNJ},/" \
	-e "s/LLm0 *= *[0-9]* *,/LLm0=$(( ${XI_RHO} - 2 )),/" \
	-e "s/MMm0 *= *[0-9]* *,/MMm0=$(( ${ETA_RHO} -2 )),/" \
	param.h > tmp$$
    mv tmp$$ param.h

    if [ $USE_CPL -eq 1 ]
    then
	sed -e "s/#  *undef  *OA_COUPLING/# define OA_COUPLING/" cppdefs.h > tmp$$
    else
	sed -e "s/#  *define  *OA_COUPLING/# undef OA_COUPLING/" cppdefs.h > tmp$$
    fi
    mv tmp$$ cppdefs.h

    if [ $AGRIFZ -eq 0 ]
    then
	sed -e "s/#  *define  *AGRIF/# undef AGRIF/" cppdefs.h > tmp$$
	sed -e "s/MAKE  *\-j  *[1-9]/MAKE -j 8/" jobcomp > tmp2$$
    else
	sed -e "s/#  *undef  *AGRIF/# define AGRIF/" cppdefs.h > tmp$$
	sed -e "s/MAKE  *\-j  *[1-9]/MAKE -j 1/" jobcomp > tmp2$$
    fi
    mv tmp$$ cppdefs.h
    mv tmp2$$ jobcomp

#-------------------------------------------------------------------------------
#   compile
#-------------------------------------------------------------------------------

    chmod 755 jobcomp
    time ./jobcomp 
    mv roms ../croco.exe
    if [ $AGRIFZ -eq 0 ]
    then
	cd Compile/
	make partit
	mv partit ../..
	cd ../..
    else
	cd ..
	rsync -a ${CROCOSRC}/Run/partit .
    fi
# save exe for next jobs
    [ ! -d ${COMPDIR}/croco ] && mkdir -p ${COMPDIR}/croco
    rsync -av croco.exe ${COMPDIR}/croco/croco_${JPNI}x${JPNJ}.exe
    
else   

    rsync -av ${COMPDIR}/croco/croco_${JPNI}x${JPNJ}.exe croco.exe 
	
fi

exit


