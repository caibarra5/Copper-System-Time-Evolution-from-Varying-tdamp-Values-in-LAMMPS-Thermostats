mapfile -t dirs < zz_list_of_thermostats.txt
let "l = ${#dirs[@]}"
for((i=0;i<$l;i++))
do
  echo ${dirs[i]}
  echo " "
  echo "zy_thermo_files_with_time_and_temp"
  ls ${dirs[i]}/zy_thermo_files_with_time_and_temp --color=yes
  echo " "
  echo "zz_dump_files"
  ls ${dirs[i]}/zz_dump_files --color=yes
  echo " "
  echo " "
done
