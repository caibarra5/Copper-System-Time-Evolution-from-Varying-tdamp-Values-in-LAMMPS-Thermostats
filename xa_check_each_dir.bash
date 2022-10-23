mapfile -t a < zz_list_of_thermostats.txt ; for((i = 0; i < 6; i++)); do echo ${a[i]};cd ${a[i]}; tree; cd ..; done
