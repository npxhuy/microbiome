#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J krakentest
#SBATCH -o //proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/kraken.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/trimm/P12002_101


#  Name of file: krakentest.sh
#
#  Created by Huy on 2023-05-02.
#
#  Write bash script below

module load bioinfo-tools Kraken2/2.1.2-20211210-4f648f5

ls | paste - - - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1); pair2=$(echo $pair | cut -d ' ' -f 3); prefix=$(echo $pair | cut -d ' ' -f 1 | sed -E 's/(P[0-9]+_[0-9]+_[A-Z0-9]+)_L([0-9]+)_R[0-9]+_001_paired.fastq.gz/\1_L\2_001/');  kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --report-zero-counts --gzip-compressed --use-names --confidence 0.05 --paired $pair1 $pair2 --output ../../kraken/P12002_101/$prefix.out --report ../../kraken/P12002_101/$prefix.report ; done
