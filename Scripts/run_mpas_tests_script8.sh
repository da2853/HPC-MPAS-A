#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-Bench3/atmosphere_model
source ~/mpas-env.sh

# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# Test different config_epssm values
epssm_values=(0.05 0.1 0.15 0.2)  # Example values
for value in "${epssm_values[@]}"
do
    echo "Running simulation with config_epssm = $value"
    modify_namelist "config_epssm" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.epssm$value.out
done
modify_namelist "config_epssm" 0.1  # Reset to default

# Test different config_smdiv values
smdiv_values=(0.05 0.1 0.15 0.20)  # Example values
for value in "${smdiv_values[@]}"
do
    echo "Running simulation with config_smdiv = $value"
    modify_namelist "config_smdiv" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.smdiv$value.out
done
modify_namelist "config_smdiv" 0.1  # Reset to default

# Test different config_v_theta_eddy_visc2 values
v_theta_eddy_visc2_values=(0.0 0.1 0.2 0.3)  # Example values
for value in "${v_theta_eddy_visc2_values[@]}"
do
    echo "Running simulation with config_v_theta_eddy_visc2 = $value"
    modify_namelist "config_v_theta_eddy_visc2" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.vthetaeddyvisc2$value.out
done
modify_namelist "config_v_theta_eddy_visc2" 0.0  # Reset to default

# Test different config_v_mom_eddy_visc2 values
v_mom_eddy_visc2_values=(0.0 0.1 0.2 0.3 0.4)  # Example values
for value in "${v_mom_eddy_visc2_values[@]}"
do
    echo "Running simulation with config_v_mom_eddy_visc2 = $value"
    modify_namelist "config_v_mom_eddy_visc2" $value
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.vmomeddyvisc2$value.out
done
modify_namelist "config_v_mom_eddy_visc2" 0.0  # Reset to default
