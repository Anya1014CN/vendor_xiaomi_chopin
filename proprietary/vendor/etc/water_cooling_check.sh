if [ ! -f "/data/local/water_cooling_check.txt" ];then
    echo "begin to record tsens log temp"
else
    echo "water_cooling_check.txt already exist, regenerate it"
    rm /data/local/water_cooling_check.txt
fi
echo "water_test" > /sys/power/wake_lock
stop mi_thermald
echo 1 > /sys/class/power_supply/battery/input_suspend

echo "cpu0 1625000" > /sys/class/thermal/thermal_message/cpu_limits
echo "cpu4 1740000" > /sys/class/thermal/thermal_message/cpu_limits
echo "cpu7 1632000" > /sys/class/thermal/thermal_message/cpu_limits
#echo userspace > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
#echo userspace > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
#echo userspace > /sys/devices/system/cpu/cpufreq/policy7/scaling_governor
#echo 4 3 1 > /proc/ppm/policy/ut_fix_core_num
#echo 3 7 9 > /proc/ppm/policy/ut_fix_freq_idx

# cpu0  2000000 1800000 1725000 1625000 1525000 1450000 1350000 1250000 1075000 1000000 925000 850000 750000 675000 600000 500000
# cpu4  2600000 2507000 2354000 2200000 1985000 1855000 1740000 1624000 1537000 1451000 1335000 1162000 1046000 902000 700000 437000
# cpu7  2600000 2529000 2410000 2292000 2127000 2032000 1938000 1820000 1745000 1632000 1482000 1370000 1258000 1108000 921000 659000

echo "Time,CurrentNow,VoltageNow,mtktsAP,mtktsbtsmdpa,mtktsbtsnrpa,mtktscpu,battery,mtktscharger,charger_therm,lcd_therm,quiet_therm,board_sensor_temp" >> /data/local/water_cooling_check.txt
starttime=`date +%s`

j=1;
while [ j -le 8 ]
do
    while true;do done &
    j=$j+1;
done

n=1
while [ $n -le 150 ]
do
    nowtime=`date +%s`
    #echo 'nowtime: '$nowtime
    #Time=`expr $nowtime - $starttime`
    Time=$(date "+%H:%M:%S")
    echo $Time	
    CurrentNow=`cat /sys/class/power_supply/battery/current_now`
    VoltageNow=`cat /sys/class/power_supply/battery/voltage_now`

    mtktsAP=`cat /sys/class/thermal/thermal_zone1/temp`		
    mtktsbtsmdpa=`cat /sys/class/thermal/thermal_zone2/temp`
    mtktsbtsnrpa=`cat /sys/class/thermal/thermal_zone3/temp`
    mtktscpu=`cat /sys/class/thermal/thermal_zone4/temp`

    battery=`cat /sys/class/thermal/thermal_zone24/temp`
    mtktscharger=`cat /sys/class/thermal/thermal_zone26/temp`
    charger_therm=`cat /sys/class/thermal/thermal_zone7/temp`
    lcd_therm=`cat /sys/class/thermal/thermal_zone8/temp`
    quiet_therm=`cat /sys/class/thermal/thermal_zone9/temp`
    board_sensor_temp=`cat /sys/class/thermal/thermal_message/board_sensor_temp`

    ((n++))

    echo "$Time,$CurrentNow,$VoltageNow,$mtktsAP,$mtktsbtsmdpa,$mtktsbtsnrpa,$mtktscpu,$battery,$mtktscharger,$charger_therm,$lcd_therm,$quiet_therm,$board_sensor_temp" >> /data/local/water_cooling_check.txt
    sleep 0.75
done

#echo schedutil > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
#echo schedutil > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
#echo schedutil > /sys/devices/system/cpu/cpufreq/policy7/scaling_governor
#echo -1 -1 -1 > ../proc/ppm/policy/ut_fix_freq_idx

start mi_thermald
echo 0 > /sys/class/power_supply/battery/input_suspend

echo "Finished"

pkill sh
