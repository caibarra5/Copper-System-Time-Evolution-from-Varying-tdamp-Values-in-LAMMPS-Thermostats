./xa_parameters_computed_for_xb.bash
SECONDS=0

mapfile -t parameters < xb_parameters_for_ab.txt

#steps_per_run=$((2 * $((10 ** 4))))
#dump_freq=2        # Dump every dump_freq time steps
#data_points_freq=2 # Output data points every data_points_freq time steps

steps_per_run=${parameters[0]}
dump_freq=${parameters[1]}        # Dump every dump_freq time steps
data_points_freq=${parameters[2]} # Output data points every data_points_freq time steps

num_of_dumps=$(($steps_per_run / $dump_freq))
steps_per_dump=$(($steps_per_run / $num_of_dumps))

num_of_data=$(($steps_per_run / $data_points_freq))
steps_per_data_point=$(($steps_per_run / $num_of_data))

in_file=$1
#lowTemp=$2
lowTemp=10

mapfile -t tdamps < cb_tdamps.txt
let "array_cb_len = ${#tdamps[@]}"

mapfile -t latts < ca_lattice_constants.txt
let "array_ca_len = ${#latts[@]}"
let "len_ca = ${#latts[@]} - 1"

total_time=$SECONDS

for((k=0;k<$array_cb_len;k++))
do
for((i=0;i<$array_ca_len;i++))
do

  mapfile -t temps < ${latts[i]}A_temps.txt
  let "array_temps_len = ${#temps[@]}"
  let "len_temps = ${#temps[@]} - 1"
  
  SECONDS=0
  
  for((j=0;j<$array_temps_len;j++))
  do
  mpirun -np 4\
    lmp\
    -var temp ${temps[j]}\
    -var a ${latts[i]}\
    -var n $steps_per_run\
    -var k $steps_per_data_point\
    -var l $steps_per_dump\
    -var tdmp ${tdamps[k]}\
    -var lowTemp $(($((${temps[j]} / 5)) * 4)) \
    -i $in_file
  done
  
  d=$SECONDS

#  txt1=ta_${latts[$i]}A_n_${steps_per_run}_k_${steps_per_data_point}_${temps[0]}K_to_${temps[$len_temps]}K_over_${array_temps_len}.txt
#
#  echo "Wall-Clock time for this run: " >> $txt1
#  
#  echo "$(($d / 3600)) hours, $(($(($d % 3600)) / 60)) minutes and $(($(($d % 3600)) % 60))\
#    seconds" >> $txt1
  
  total_time=$(($total_time + $SECONDS))
  
done

done

f=$total_time

txt2=tb_${latts[0]}A_${latts[$len_ca]}A_${array_ca_len}_temp_custom_n_${steps_per_run}.txt

echo "Sum of wall-clock times for each run: " >> $txt2

  echo "$(($f / 3600)) hours, $(($(($f % 3600)) / 60)) minutes and $(($(($f % 3600)) % 60))\
    seconds" >> $txt2

#spd-say "done"
