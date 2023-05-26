#!/bin/bash
#SBATCH -A naiss2023-22-412
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH --mail-user=ph4342ng-s@student.lu.se
#SBATCH --mail-type=ALL
#SBATCH -J multiqc
#SBATCH -o /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/multiqc.out
#SBATCH -e /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/err_out/multiqc.err
#SBATCH -D /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/fastqc


#  Name of file: multiqc.sh
#
#  Created by Huy on 2023-05-03.
#
#  Write bash script below

module load bioinfo-tools MultiQC/1.12

multiqc .
