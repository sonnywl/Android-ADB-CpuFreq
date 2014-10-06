DIR='/sys/devices/system/cpu/cpu'
possible=$(adb shell "cat /sys/devices/system/cpu/possible"  | tr -d '\r')
CPUS="${possible: -1}"


reset() {
	for i in $CPUS
	do
		min=$(adb shell "$DIR$i/cpufreq/cpuinfo_min_freq"  | tr -d '\r')
		max=$(adb shell "$DIR$i/cpufreq/cpuinfo_max_freq"  | tr -d '\r')
		adb shell "echo ondemand > $DIR$i/cpufreq/scaling_governor"
		adb shell "echo $max > $DIR$i/cpufreq/scaling_max_freq"
		adb shell "echo $min > $DIR$i/cpufreq/scaling_min_freq"
	done
}

online() {
    for i in $CPUS
    do
        adb shell "echo $1 > $DIR$i/online"
    done
    echo -n "CPU online: "
    adb shell 'cat /sys/devices/system/cpu/online'
}

getFrequencies() {
    if [ "$#" -ne 1 ]; then
        echo 'Get Frequency Requires a CPU core number'
        return
    fi
    adb shell "cat $DIR$1/cpufreq/scaling_available_frequencies"| tr -d '\r'
}

getCurFrequency() {
    if [ "$#" -ne 1 ]; then
        echo 'Get Frequency Requires a CPU core number' 
        return
    fi
    adb shell "cat $DIR$1/cpufreq/scaling_cur_freq"| tr -d '\r'
}

getMaxFrequency() {
    if [ "$#" -ne 1 ]; then
        echo 'Get Frequency Requires a CPU core number' 
        return
    fi
    adb shell "cat $DIR$1/cpufreq/scaling_max_freq"| tr -d '\r'
}

getMinFrequency() {
    if [ "$#" -ne 1 ]; then
        echo 'Get Frequency Requires a CPU core number' 
        return
    fi
    adb shell "cat $DIR$1/cpufreq/scaling_min_freq"| tr -d '\r'
}

getPolicy() {
    if [ "$#" -ne 1 ]; then
        echo 'Get Policy Requires a CPU core number' 
        return
    fi
    adb shell "cat $DIR$1/cpufreq/scaling_governor"
}

setFrequency() {
    if [ "$#" -ne 2 ]; then
        echo 'Set Frequency Requires Cpu Core and a KHz'
        return
    fi
    adb shell "echo userspace > $DIR$1/cpufreq/scaling_governor"
    adb shell "echo $2 > $DIR$1/cpufreq/scaling_min_freq"
    adb shell "echo $2 > $DIR$1/cpufreq/scaling_max_freq"
}

setMaxFrequency() {
    if [ "$#" -ne 2 ]; then
        echo 'Set Frequency Requires Cpu Core and a KHz'
        return
    fi
    adb shell "echo $2 > $DIR$1/cpufreq/scaling_min_freq"
}

setMinFrequency() {
    if [ "$#" -ne 2 ]; then
        echo 'Set Frequency Requires Cpu Core and a KHz'
        return
    fi
    adb shell "echo $2 > $DIR$1/cpufreq/scaling_min_freq"
}

setPolicy() {
    if [ "$#" -lt 2 ]; then
        echo 'Set Frequency Requires Core Value and a KHz'
        return
    fi
    adb shell "echo $2 > $DIR$1/cpufreq/scaling_governor"
}

case ${1} in
    0|cpus) echo $CPUS;;
    1|online) online $2;;
    2|freqs) getFrequencies $2;;
    3|cur) getCurFrequency $2;;
    4|max) getMaxFrequency $2;;
    5|min) getMinFrequency $2;;
    6|getp) getPolicy $2;;
    7|setf) setFrequency $2 $3;;
    8|setmax) setMaxFrequency $2 $3;;
    9|setmin) setMinFrequency $2 $3;;
    10|setp) setPolicy $2 $3;;
	11|reset) reset;;
    -h|--help) 

printf "\tcpus - get avaiable cpus
\tonline - [01]+ - toggle cpu core
\tfreqs - [0-9]+ - avaiable frequencies for a given cpu
\tcur - [0-9]+ - current frequency for a given cpu
\tmax - [0-9]+ -current max frequency for a given cpu
\tmin - [0-9]+ -current min frequency for a given cpu
\tgetp - [0-9]+ - get current policy for a given cpu
\tsetf - [0-9]+, [frequency] - set frequency to a given cpu (userland)
\tsetmax - [0-9]+, [frequency] - set max frequency to a given cpu (userland)
\tsetmin - [0-9]+, [frequency] - set min frequency to a given cpu (userland)
\tsetp - [0-9]+, [policy] - set policy to a given cpu\n";;
esac
