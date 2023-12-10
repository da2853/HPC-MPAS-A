#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=4
#SBATCH --tasks-per-node=32
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
chmod 755 /scratch/da2853/mpas-a-benchmark/MPAS-Bench2/atmosphere_model
source ~/mpas-env.sh

# Function to modify the namelist file
modify_namelist() {
    local parameter=$1
    local value=$2
    sed -i "s/^    $parameter = .*/    $parameter = $value/" $NAMELIST
}

# Test different config_sst_update values
for sst_update in true false; do
    echo "Running simulation with config_sst_update = $sst_update"
    modify_namelist "config_sst_update" $sst_update
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.sstupdate$sst_update.out
done
modify_namelist "config_sst_update" false  # Reset to default

# Test different config_do_restart values
for do_restart in true false; do
    echo "Running simulation with config_do_restart = $do_restart"
    modify_namelist "config_do_restart" $do_restart
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.restart$do_restart.out
done
modify_namelist "config_do_restart" false  # Reset to default

# Test different config_apply_lbcs values
for apply_lbcs in true false; do
    echo "Running simulation with config_apply_lbcs = $apply_lbcs"
    modify_namelist "config_apply_lbcs" $apply_lbcs
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.lbcs$apply_lbcs.out
done
modify_namelist "config_apply_lbcs" false  # Reset to default

# Test different config_IAU_option values
# Replace 'on' and 'off' with actual IAU options available in your MPAS version
for iau_option in 'off' 'on'; do
    echo "Running simulation with config_IAU_option = $iau_option"
    modify_namelist "config_IAU_option" $iau_option
    srun ./atmosphere_model
    mv log.atmosphere.0000.out log.atmosphere.iau$iau_option.out
done
modify_namelist "config_IAU_option" 'off'  # Reset to default