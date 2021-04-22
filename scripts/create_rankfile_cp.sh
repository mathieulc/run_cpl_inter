set +vx
#
# needed variables:
#   nprocnode
#   ncoreproc
#   ncorenode=$(( $nprocnode * $ncoreproc ))
#   nnodes: total node used
#   ncoreswrf
#   ncoresiowrf
#   nperiowrf
#   ncoresnemo
#   ncoresxios
#   nperxios
#
export PYTHONPATH=/ccc/work/cont005/ra0542/massons/python-hostlist-1.11
export PATH=$PATH:$PYTHONPATH/build/scripts-2.6
#
ncoresio=$(( $ncoresiowrf + $ncoresxios ))
ncoresmod=$(( $ncoreswrf + $ncoresnemo ))
ncoresall=$(( $ncoresmod + $ncoresio ))
#
[ $nperxios  -gt $ncorenode ] && exit 11
[ $nperiowrf -gt $ncorenode ] && exit 12
[ $ncoresio  -gt $(( $nprocnode * $nnodes )) ] && exit 13  # max 1 io per proc 
[ $ncoresall -gt $(( $ncorenode * $nnodes )) ] && exit 14  
#----------------------------------------------------------------
# define host ($nnodes elements) containing the hosts names: curiexxx
# ----------------------------------------------------------------
cnt=0
for node in $( hostlist --expand --sep " " $SLURM_NODELIST )
do
  host[$cnt]=$node
  cnt=$(( $cnt + 1 ))
done
#----------------------------------------------------------------
# define used ($nnodes*$ncorenode elements) containing 1(0) is the core is atributed to an executable (or not)
#----------------------------------------------------------------
cntnd=0
while [ $cntnd -lt $nnodes ]
do
    cntco=0
    while [ $cntco -lt $ncorenode ]
    do
	used[$(( $cntco + $ncorenode * $cntnd ))]=0
	cntco=$(( $cntco + 1 ))
    done # loop on $ncorenode
    cntnd=$(( $cntnd + 1 ))
done # loop on $nnodes
#
#----------------------------------------------------------------
# create node, proc and core that have ncoreswrf+ncoresiowrf+ncoresnemo+ncoresxios elements
#----------------------------------------------------------------
#
#----------------------------------------------------------------
# start with 1 io process per node (and per proc of there is more than 1 io per node) 
# first wrf io, next nemo io
#----------------------------------------------------------------
#
cntio=0
cntpr=0
while [ $cntpr -lt $nprocnode ]
do
    cntnd=0
    while [ $cntnd -lt $nnodes ]
    do
	numcore=$(( $ncoreproc * $cntpr + $ncorenode * $cntnd ))
	if [[ ( $cntio -lt $ncoresio ) && ( ${used[$numcore]} -eq 0 ) ]]
	then  
#	    
	    if [ $cntio -lt $ncoresiowrf ]
	    then
		rank=$(( $ncoreswrf + $cntio )) 
		nperio=$nperiowrf
	    else
		rank=$(( $ncoreswrf + $ncoresnemo + $cntio ))
		nperio=$nperxios
	    fi
#	    
	    node[${rank}]=$cntnd
	    proc[${rank}]=$cntpr
	    core[${rank}]=0
#	    
	    cntco=0
	    while [ $cntco -lt $nperio ]
	    do
		used[$(( $cntco + $numcore ))]=1
		cntco=$(( $cntco + 1 ))
	    done # loop on $nperio
#
	    cntio=$(( $cntio + 1 ))
	fi
	cntnd=$(( $cntnd + 1 ))
    done # loop on $nnodes
    cntpr=$(( $cntpr + 1 ))
done # loop on $nprocnode
#
#----------------------------------------------------------------
# add wrf and nemo cores...
#----------------------------------------------------------------
#
cntmod=0
cntnd=0
while [ $cntnd -lt $nnodes ]
do
    cntco=0
    while [ $cntco -lt $ncorenode ]
    do
	numcore=$(( $cntco + $ncorenode * $cntnd ))
	if [ ${used[$numcore]} -eq 0 ]
	then
	    if [ $cntmod -lt $ncoresmod ]
	    then  

		[ $cntmod -lt $ncoreswrf ] && rank=$cntmod || rank=$(( $ncoresiowrf + $cntmod ))
echo $rank
		node[${rank}]=$cntnd
		proc[${rank}]=$(( $cntco / $ncoreproc ))
		core[${rank}]=$(( $cntco % $ncoreproc ))
		
		used[$numcore]=1
		cntmod=$(( $cntmod + 1 ))
	    fi
	fi
	cntco=$(( $cntco + 1 ))
    done # loop on $ncorenode
    cntnd=$(( $cntnd + 1 ))
done # loop on $nnodes

# print
rm -f rankfile
cnt=0
while [ $cnt -lt $ncoresall ]
do
    [ used[$cnt] -eq 1 ] && echo "rank ${cnt}=${host[${node[${cnt}]}]} slot=${proc[${cnt}]}:${core[${cnt}]}" >> rankfile
#
    cnt=$(( $cnt + 1 ))
done # loop on $nused
#
set -vx
