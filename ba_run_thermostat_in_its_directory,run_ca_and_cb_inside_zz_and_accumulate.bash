in_file=$1
mapfile -t params < langevin/xb_parameters_for_ab.txt
mapfile -t lattice < langevin/ca_lattice_constants.txt
mapfile -t dirs < zz_list_of_thermostats.txt
let "dirs_len = ${#dirs[@]}"
let "len_dirs = ${#dirs[@]} -1"


dir_name_to_collect_dump_results="${lattice[0]}A_dump_results"

mapfile -t temperatures < langevin/${lattice[0]}A_temps.txt
let "temperatures_len = ${#temperatures[@]}"
let "len_temperatures = ${#temperatures[@]} -1"

mapfile -t tdamps < langevin/cb_tdamps.txt
let "tdamps_len = ${#tdamps[@]}"
let "len_tdamps = ${#tdamps[@]} -1"


for((i=0;i<$temperatures_len;i++))
do
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${temperatures[i]}
done
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}K

dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${params[0]}_steps
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_1_dump_every_${params[1]}_steps
#dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${params[2]}


# Commented because of too long a name for files*******************
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_tdamps
#for((i=0;i<$tdamps_len;i++))
#do
#dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${tdamps[i]}
#done
#dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}ps
#dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${in_file}
# Commented because of too long a name for files*******************
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${tdamps[0]}_to_${tdamps[len_tdamps]}
step=`c_summation ${tdamps[len_tdamps]} -${tdamps[0]}`
step=`c_division $step $len_tdamps`
dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_by_${step}

# Add thermostats to directory name
#for((i=0;i<$dirs_len;i++))
#do
#dir_name_to_collect_dump_results=${dir_name_to_collect_dump_results}_${dirs[i]}
#done

SECONDS=0
time_file=ta_wall-clock_time_${dir_name_to_collect_dump_results}.txt
touch $time_file


mkdir -p ${dir_name_to_collect_dump_results}
mkdir -p \
${dir_name_to_collect_dump_results}/{a_phase_trajectories,b_rms_for_r_and_v,c_temperature_averages}



for((i=0;i<$dirs_len;i++))
do
cd ${dirs[i]} # Went inside thermostat directory
# Run bash files in parent thermostat directory
./ab_run_lattice_loop_and_temperature_loop.bash $in_file
./bb_move_all_thermo_files_from_dir_input_to_zy.bash
./bc_move_all_dump_files_into_zz.bash

# For temperature averages
cd zy_thermo_files_with_time_and_temp
./da_run_ca_and_cb_for_full_analysis.bash
rm thermo_info_*.dat_cleaned 
#rm thermo_info_*.dat # Removed inside zy directory
mv thermo_info_*.dat_cleaned.jpg ../../${dir_name_to_collect_dump_results}/c_temperature_averages

# For phase trajectories and rms's
cd ../zz_dump_files
./ha_run_ga_and_gb_for_full_analysis.bash

mv *trajectory* ../../${dir_name_to_collect_dump_results}/a_phase_trajectories
#rm *cleaned # Removed inside zz directory
#rm dump_every*.Cu # Removed inside zz directory

mv *r_rms.dat.jpg ../../${dir_name_to_collect_dump_results}/b_rms_for_r_and_v
rm *r_rms.dat 
mv *v_rms.dat.jpg ../../${dir_name_to_collect_dump_results}/b_rms_for_r_and_v
rm *v_rms.dat 
rm *_cleaned_ordered 

cd ../../

done

touch \
${dir_name_to_collect_dump_results}/a_phase_trajectories/trajectories_${dir_name_to_collect_dump_results}.tex
#touch \
#${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/rms_${dir_name_to_collect_dump_results}.tex
touch \
${dir_name_to_collect_dump_results}/c_temperature_averages/temp_avgs_${dir_name_to_collect_dump_results}.tex

cp zt_testing_latex_generating_bash_script/ca_generate_latex_file.bash ${dir_name_to_collect_dump_results}/a_phase_trajectories/
cp zt_testing_latex_generating_bash_script/ca_generate_latex_file.bash ${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/
cp zt_testing_latex_generating_bash_script/ca_generate_latex_file.bash ${dir_name_to_collect_dump_results}/c_temperature_averages/

cp zt_testing_latex_generating_bash_script/cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash ${dir_name_to_collect_dump_results}/a_phase_trajectories/
cp zt_testing_latex_generating_bash_script/cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash ${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/
cp zt_testing_latex_generating_bash_script/cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash ${dir_name_to_collect_dump_results}/c_temperature_averages/

mkdir ${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/r_rms
mkdir ${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/v_rms

cd ${dir_name_to_collect_dump_results}/b_rms_for_r_and_v/

touch r_rms/r_rms_${dir_name_to_collect_dump_results}.tex
touch v_rms/v_rms_${dir_name_to_collect_dump_results}.tex

mv *r_rms.dat.jpg r_rms
mv *v_rms.dat.jpg v_rms

cp ca_generate_latex_file.bash r_rms
cp cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash r_rms

mv ca_generate_latex_file.bash v_rms
mv cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash v_rms

cd ../..

# Make directory in zr_collected_pdf_files_in_folders_for_results_from_ba to
# put results in there.
mkdir zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}

# Make pdf files for the results
cd ${dir_name_to_collect_dump_results}

cd a_phase_trajectories
#./cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash
#./ca_generate_latex_file.bash trajectories_${dir_name_to_collect_dump_results}.tex
#pdflatex trajectories_${dir_name_to_collect_dump_results}.tex
#cp trajectories_${dir_name_to_collect_dump_results}.pdf ../../zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}
cp ../../xb_make_video.bash .
cd ..


cd c_temperature_averages
#./cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash
#./ca_generate_latex_file.bash temp_avgs_${dir_name_to_collect_dump_results}.tex
#pdflatex temp_avgs_${dir_name_to_collect_dump_results}.tex
#cp temp_avgs_${dir_name_to_collect_dump_results}.pdf ../../zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}
cp ../../xb_make_video.bash .
cd ..

cd b_rms_for_r_and_v/r_rms
#./cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash
#./ca_generate_latex_file.bash r_rms_${dir_name_to_collect_dump_results}.tex
#pdflatex r_rms_${dir_name_to_collect_dump_results}.tex
#cp r_rms_${dir_name_to_collect_dump_results}.pdf ../../../zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}
cp ../../../xb_make_video.bash .
cd ../..


cd b_rms_for_r_and_v/v_rms
#./cb_give_order_to_jpg_files_by_temp_tdamp_thermostat.bash
#./ca_generate_latex_file.bash v_rms_${dir_name_to_collect_dump_results}.tex
#pdflatex v_rms_${dir_name_to_collect_dump_results}.tex
#cp v_rms_${dir_name_to_collect_dump_results}.pdf ../../../zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}
cd ../../..


  d=$SECONDS

  echo "$(($d / 3600)) hours, $(($(($d % 3600)) / 60)) minutes and $(($(($d % 3600)) % 60))\
 seconds" >> \
     $time_file 
cat $time_file
mv $time_file ${dir_name_to_collect_dump_results}  

cd zr_collected_pdf_files_in_folders_for_results_from_ba/${dir_name_to_collect_dump_results}
#for file in *.pdf
#do
#  xdg-open $file
#done
#cd ..
