#!/bin/bash
#SBATCH -A snic2022-5-640
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 80:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J trimm
#SBATCH -o /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/trimm.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/trimm.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/wgs_sample


#  Name of file: trimm.sh
#
#  Created by Huy on 2023-04-25.
#
#  Write bash script below

# Load tools from UPPMAX
module load bioinfo-tools trimmomatic/0.39

# 1. Loop through each folder
# 2. In every folder, ls to have all the file, paste - - to have pair of files in one line
# 3. Loop through each pair, cut and set and other stuff to have the name of the output for trimmomatic
# 4. Do trimmomatic for each pair and put the output in trimm folder
# 5. cd out when finish with one folder
# Note: using TruSeq3-PE.fa as an adapter file containing the adapter sequences to be trimmed

ls | while read folder; do cd $folder; ls | paste - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_paired.fastq/'); unpair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_unpaired.fastq/'); pair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_paired.fastq/'); unpair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_unpaired.fastq/'); java -jar $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -threads 10 $pair ../../trimm/$folder/$pair1 ../../trimm/$folder/$unpair1 ../../trimm/$folder/$pair2 ../../trimm/$folder/$unpair2 ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10:2:True SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36; done; cd ..; done
