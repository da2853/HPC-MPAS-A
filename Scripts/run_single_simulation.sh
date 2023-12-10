#!/bin/bash

#SBATCH --job-name=mpas-atmosphere
#SBATCH --nodes=8
#SBATCH --tasks-per-node=16
#SBATCH --mem=180GB
#SBATCH --time=12:00:00
#SBATCH --output=mpas_run_%j.out

# Path to the namelist file
NAMELIST=namelist.atmosphere
DT_VALUE=$1

# Modify the namelist file
sed -i "s/^    config_dt = [0-9]*\.*[0-9]*/    config_dt = $DT_VALUE/" $NAMELIST

# Run the model
srun ./atmosphere_model

# Rename the output file
mv log.atmosphere.0000.out log.atmosphere.dt$DT_VALUE.out
