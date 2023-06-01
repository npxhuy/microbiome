#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J bracken_filtered
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken_filtered.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/bracken_filtered.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/bracken


#  Name of file: bracken_filtered.sh
#
#  Created by Huy on 2023-05-06.
#
#  Write bash script below

# 1. Loop through the bracken results
# 2. Sed the name of the file for naming the output
# 3. Run KrakenTools on the bracken results

# Parameter's explanation:
# --exclude 9604 and --exclude 9606: exclude anything that mapped to human sequences (taxonomic id at family and species level respectively), which is our only metazoan representative

# Exclude human at family level
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_F_filtered/$name.bracken_filtered --exclude 9604 ; done


# Exclude human at species level
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_filtered/$name.bracken_filtered --exclude 9606 ; done
