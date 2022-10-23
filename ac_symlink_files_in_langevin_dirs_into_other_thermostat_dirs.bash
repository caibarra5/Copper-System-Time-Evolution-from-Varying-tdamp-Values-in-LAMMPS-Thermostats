# Need this to loop over all other dirs besides langevin
mapfile -t dirs < zz_list_of_thermostats.txt
let "dirs_len = ${#dirs[@]}"

# Can use this to symlink all files in all directories but would rather not
# because some files are specific to each thermostat such as file cb in their
# dirs zz.
mapfile -t dirs_from_langevin < zx_list_of_dirs_in_langevin.txt
let "lan_len = ${#dirs_from_langevin[@]}"

# As such, we shall use the following three loops instead to exclude certain
# files.
mapfile -t dot < zu_list_of_files_in_langevin-..txt
let "dot_len = ${#dot[@]}"

mapfile -t zy < zv_list_of_files_in_langevin-zy_thermo_files_with_time_and_temp.txt
let "zy_len = ${#zy[@]}"

mapfile -t zz < zw_list_of_files_in_langevin-zz_dump_files.txt 
let "zz_len = ${#zz[@]}"

# We will thus need three double-nested for loops

for((i = 0; i < $dirs_len; i++))
do
  cd ${dirs[i]}
  for((j = 0; j < dot_len; j++))
  do
    ln -s \
    /home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin/${dot[j]}
  done
  cd ..
done


for((i = 0; i < $dirs_len; i++))
do
  cd ${dirs[i]}/zy_thermo_files_with_time_and_temp
  for((j = 0; j < $zy_len; j++))
  do 
    ln -s \
/home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin/zy_thermo_files_with_time_and_temp/${zy[j]}
done
cd ../../
done


for((i = 0; i < $dirs_len; i++))
do
  cd ${dirs[i]}/zz_dump_files
  for((j = 0; j < $zz_len; j++))
  do 
    ln -s \
/home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin/zz_dump_files/${zz[j]}
done
cd ../../
done


# /home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin
# /home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin/zy_thermo_files_with_time_and_temp
# /home/christopher/Dropbox/ah_LAMMPS_Simulations/aaw_Copper_thermostated_exploration_one_particle_phase_trajector,temp_avg_and_r_and_v_rms-es/langevin/zz_dump_files
