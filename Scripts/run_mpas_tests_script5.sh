#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-Bench4/atmosphere_model
source ~/mpas-env.sh
# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# Test different config_scalar_adv_order values
scalar_adv_orders=(2 3 4)
for order in "${scalar_adv_orders[@]}"
do
    echo "Running simulation with config_scalar_adv_order = $order"
    modify_namelist "config_scalar_adv_order" $order
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.scalaradv$order.out
done
modify_namelist "config_scalar_adv_order" 3  # Reset to default

# Test different config_len_disp values
len_disp_values=(50000 60000 70000)  # Example values
for value in "${len_disp_values[@]}"
do
    echo "Running simulation with config_len_disp = $value"
    modify_namelist "config_len_disp" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.lendisp$value.out
done
modify_namelist "config_len_disp" 60000  # Reset to default

# Test different config_visc4_2dsmag values
visc4_2dsmag_values=(0.04 0.05 0.06)  # Example values
for value in "${visc4_2dsmag_values[@]}"
do
    echo "Running simulation with config_visc4_2dsmag = $value"
    modify_namelist "config_visc4_2dsmag" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.visc4_2dsmag$value.out
done
modify_namelist "config_visc4_2dsmag" 0.05  # Reset to default

# Test different config_print_global_minmax_vel and config_print_detailed_minmax_vel values
for global_minmax in true false; do
    for detailed_minmax in true false; do
        echo "Running simulation with config_print_global_minmax_vel = $global_minmax and config_print_detailed_minmax_vel = $detailed_minmax"
        modify_namelist "config_print_global_minmax_vel" $global_minmax
        modify_namelist "config_print_detailed_minmax_vel" $detailed_minmax
        srun ./atmosphere_model
        mv log.atmosphere.0000.out log.atmosphere.global$detailed_minmax$out
    done
done
modify_namelist "config_print_global_minmax_vel" true  # Reset to default
modify_namelist "config_print_detailed_minmax_vel" false  # Reset to default