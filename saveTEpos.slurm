#! /usr/bin/env bash
#SBATCH --partition=Draco
#SBATCH --nodes=1
#SBATCH --time=30:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50gb
#SBATCH --mail-type=end
#SBATCH --mail-user=kkrishn8@uncc.edu



perl saveTEpos2.pl pi655972/data/pi655972_ltr_tagged.fa pi655972/data/TE_age_estimate_10k.txt TEpos10kage/pi655972TEpos.txt  
