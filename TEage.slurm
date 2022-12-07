#! /usr/bin/env bash
#SBATCH --partition=Draco
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem=15gb
#SBATCH --mail-type=end
#SBATCH --mail-user=kkrishn8@uncc.edu

module load R

Rscript TEage.R
