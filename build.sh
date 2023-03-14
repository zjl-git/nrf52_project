PROJECT=$1
TOPDIR=${PWD}
OUTDIR=${PWD}/build
SDKDIR=${TOPDIR}/project/${PROJECT}

# reset
Color_Off='\033[0m'       # Text Reset

# regular colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

#cpu count
PLATFORM=$(uname)
if [[ "${platform}" =~ "MINGW" || "${platform}" =~ "MSYS" ]]; then
    max_jobs=$(( $(WMIC CPU Get NumberOfLogicalProcessors|tail -2|awk '{print $1}') - 1))
elif [[ "${platform}" =~ "Darwin" ]]; then
    export PATH="/usr/local/bin:${PATH}"
    max_jobs=`sysctl -n hw.ncpu`
else
    max_jobs=`cat /proc/cpuinfo |grep ^processor|wc -l`
fi

#start build
if [ $# -eq 0 ]; then
    echo -e "Parameter error1!";
    exit 1

elif [ $# -eq 1 ]; then
    mkdir ${OUTDIR}
    rm ${OUTDIR}/*
    cd ${SDKDIR}
    make -j${max_jobs} 2> ${OUTDIR}/err.log
    BUILD_RESULT=$?
    if [ "$BUILD_RESULT" -eq "0" ]; then
        echo -e "TOTAL BUILD: ${Green}PASS${Color_Off}"
    else
        cat ${OUTDIR}/err.log
        echo -e "TOTAL BUILD: ${Red}FAIL${Color_Off}"
    fi

elif [ $# -eq 2 ]; then
    cd ${SDKDIR}
    if [ "$2" == "clean" ]; then
        make clean
    elif [ "$2" == "flash" ]; then
        make flash
    elif [ "$2" == "erase" ]; then
        make erase
    elif [ "$2" == "help" ]; then
        make help
    fi

fi

exit ${BUILD_RESULT}