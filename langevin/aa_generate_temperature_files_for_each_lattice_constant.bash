mapfile -t latts < ca_lattice_constants.txt
let "array_ca_len = ${#latts[@]}"
let "len_ca = ${#latts[@]} - 1"

for((i=0; i<$array_ca_len; i++))
do
touch ${latts[i]}A_temps.txt
done
