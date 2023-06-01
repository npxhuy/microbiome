#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J kraken
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/trimm


#  Name of file: kraken.sh
#
#  Created by Huy on 2023-05-03.
#
#  Write bash script below

# Load tools from UPPMAX
module load bioinfo-tools Kraken2/2.1.2-20211210-4f648f5


# 1. Loop through folder and cd to folder
# 2. Each folder now have 4 files for each pair (2 unpaired and 2 paired), paste to make 4 files in one line
# 3. Extract the pair with pair1 and pair2, prefix using regex for naming in kraken
# 4. Run kraken
# 5. kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ indicate the database PlusDF compile in 12/9/2022

ls | while read folder; do cd $folder; ls | paste - - - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1); pair2=$(echo $pair | cut -d ' ' -f 3); prefix=$(echo $pair | cut -d ' ' -f 1 | sed -E 's/(P[0-9]+_[0-9]+_[A-Z0-9]+)_L([0-9]+)_R[0-9]+_001_paired.fastq.gz/\1_L\2_001/');  kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --report-zero-counts --gzip-compressed --use-names --confidence 0.05 --paired $pair1 $pair2 --output ../../kraken/$folder/$prefix.out --report ../../kraken/$folder/$prefix.report ; done; cd ..; done
