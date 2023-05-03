# Deadline and tracking hand-in files  and other important stuffs (to be deleted later)
## Readme
1. Introduction to software
2. Pipeline of analysis
## Report
1. Abstract 
>  may re-use some infomations the old abstract for the application
2. Introduction 
> may re-use some writing from the application as well
3. Material & methods
> list out the software packages and step by step of performing the pipeline
4. Resutls
5. Conclusion
6. Ack
7. Ref
# Author's note
This project was done in the server UPPMAX. Most of the applications/packages/softwares were already installed on the server, except where noted.\
When running code on UPPMAX's server, when using certain software (Kraken2 to be specific), code written in multiple lines had problem running, thus the codes/scripts here were all written as one long line of code to avoid having problem when running on the server. It was not the best way to demonstrate and keep track of code but that was the best bet to run codes/scripts normally on UPPMAX.
# Introduction to software which would be used in this pipeline
## conda
Version: [23.3.1](https://docs.conda.io/projects/conda/en/latest/index.html)\
Description: Package management system and environment management, package/software installation.\
Installation: Available on UPPMAX's resources, but the manual for installation can be found [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html)
## trimmomatic
Version: [0.39](https://github.com/usadellab/Trimmomatic)\
Description: Trimming and filtering sequencing read.\
Installation: Available on UPPMAX's resources, but can be installed using **conda**
> conda install -c bioconda trimmomatic=0.39

Author's note: I do not recommend to install through conda because it's more complicated when run the program, download the [package](https://github.com/usadellab/Trimmomatic/releases) and call the package when running the trimming process is more logical for me at least.
## FastQC
Version: [0.11.9](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)\
Description: Quality control tool for high throughput sequencing data.\
Installation: Available on UPPMAX's resources, but can be installed using **conda**
>conda install -c bioconda fastqc=0.11.9
## MultiQC
Version: [1.12](https://github.com/ewels/MultiQC)\
Description:\
Installation: Available on UPPMAX's resources, but can be installed using **conda**
> conda install -c bioconda multiqc=1.12
## Kraken2
Version: [2.1.2](https://ccb.jhu.edu/software/kraken2/)\
Description: Taxonomic sequence classifier.\
Installation: Available on UPPMAX's resources, but can be installed using **conda**
> conda install -c bioconda kraken2=2.1.2
## Bracken
Version: \
Description: \
Installation: \
* * * 
# Pipeline of analysis
**NOTE**  
Add a link tree of the working directory at (1).\
Add absolute working dir on uppmax at (2)\
Add raw data wd at (3)\
* * *
My file tree of my repository on the server could be found [here](). (1)\
The absolute path to the working directory on the UPPMAX's server is: (2)\
The absolute path to the raw data on UPPMAX's server is: (3)\
In order to sucessufully follow this analysis, you must:
- Following strictly to the naming of directory, subdirectory, naming format, ect.
- Installing every software that was stated.
- To receive similar outcome, same version of software should be used.
## 1. Setting working directory & data.
**NOTE**\
Add more directory as the pipeline goes on!!!.
* * *
The following directories were created in the current working directory, using *mkdir*.
```bash
mkdir wgs_sample
mkdir trimm
mkdir fastqc
mkdir multiqc
mkdir kraken
mkdir bracken
```
These following directories were made in order to have more organised working place.
- *scripts* contains all the scripts that were written to perform the pipeline, and to submit onto the server to run.
- *err_out* contains any additionally output from the code, or any error that happened during the run.
```bash
mkdir scripts
mkdir err_out
```
This is the directory on the server to the list of all sample that gonna be used in this analysis
> /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt
```bash
head /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt
P12002_144	CHES
P12002_145	CHES
P12002_146	CHES
P12002_147	CHES
P12002_148	CHES
P12002_149	CHES
P12002_150	CHES
P12002_151	CHES
P12002_152	CHES
P12002_153	CHES
```
This is the location of whole genome sequences, here it has 3 folders, each folder has multi subfolder that contains samples of whole genome sequences
> /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/
```bash
ls /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/
P12002	P14052	P18751
```
Exploring the above directory, it contains multiple **.lst* files that has the information about the path to the samples, for example:
```bash
less /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/P12002/P12002_101.lst
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L005_R2_001.fastq.gz
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L008_R2_001.fastq.gz
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L002_R2_001.fastq.gz
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L008_R1_001.fastq.gz
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L002_R1_001.fastq.gz
P12002_101/02-FASTQ/190111_ST-E00214_0275_AHWLHMCCXY/P12002_101_S13_L005_R1_001.fastq.gz
P12002_101.md5
```
Using these information, a soft-link to the samples were created to the current working directory.
```bash
### STEP 1: Create id.txt file
# Go to the main working directory
cd /proj/snic2022-6-377/Projects/Tconura/working/Huy/test
# Create a file call id.txt that contains only the name of the sample folder
cut -f 1 /proj/snic2022-6-377/Projects/Tconura/working/Rachel/popgen_Tconura/allpops.Tcon.txt > id.txt

### STEP 2: Soft-link the sample
# 1. Make diretory as the in the txt file, cd to folder
# 2. Loop through the *.lst file, that contains the directory the fastq.gz
# 3. Create soft link of fastq.gz inside that folder
# 4. Cd out, repeat the loop
# Note: could write an if to not read the md5 so we dont have to remove later but it's easier to remove than thinking about writing a extra condition code so what's the point
# Note2: if this code did not work for you, try to mkdir first, and then run the code again without the mkdir $folder
cd wgs_samples
cat ../id.txt | while read folder; do main=$(echo $folder | cut -d \_ -f 1) ; mkdir $folder; cd $folder ; cat /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$folder.lst | while read dir; do ln -s /proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/$main/$dir ; done ; cd .. ; done

### STEP 3: Cleaning
# The .lst file contains the md5 that is not useful in this situation so remove it
rm */*.md5
```
## 2. Trimming.
The script *trimm.sh* was run in *wgs_sample* directory. See the scripts *trimm.sh* for more information.\
The trimming process took about 40 hours to run on the server, and needed approximately over 400 GB of storage.\
When running *trimmomatic* using *conda*, you might need to look for more information yourself on how to modify the code. When running it by calling the downloaded package, *$TRIMMOMATIC_ROOT* should be replaced by the directory to the *trimmomatic* package.
```bash
### STEP 1: Make directory in trimm
cd trimm
cat ../id.txt | while read folder; do mkdir $folder; done

### STEP 2: Run trimmomatic
# Load tools from UPPMAX
module load bioinfo-tools trimmomatic/0.39

# 1. Loop through each folder
# 2. In every folder, ls to have all the file, paste - - to have pair of files in one line
# 3. Loop through each pair, cut and set and other stuff to have the name of the output for trimmomatic
# 4. Do trimmomatic for each pair and put the output in trimm folder
# 5. cd out when finish with one folder
ls | while read folder; do cd $folder; ls | paste - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_paired.fastq/'); unpair1=$(echo $pair | cut -d ' ' -f 1 | sed 's/.fastq/_unpaired.fastq/'); pair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_paired.fastq/'); unpair2=$(echo $pair | cut -d ' ' -f 2 | sed 's/.fastq/_unpaired.fastq/'); java -jar $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -threads 10 $pair ../../trimm/$folder/$pair1 ../../trimm/$folder/$unpair1 ../../trimm/$folder/$pair2 ../../trimm/$folder/$unpair2 ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10:2:True SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36; done; cd ..; done
```
## 3. FastQC and MultiQC.
* * *
The script *fastqc.sh* was run in *trimm* directory. See the scripts *fastqc.sh* for more information.\
The fastqc process was estimated to take about 12 hours to run on the server.\
```bash
### STEP 1: Make directory in fastqc
cd fastqc
cat ../id.txt | while read folder; do mkdir $folder; done

### STEP 2: Run fastqc
# Load module
module load bioinfo-tools FastQC/0.11.9
# 1. Ls of folder and cd in each folder
# 2. Fastqc for every file, -o flag for output directory

ls | while read folder; do cd $folder; ls | while read file; do fastqc -o ../../fastqc/$folder $file ; done;  cd ..; done
```
KNOWN ISSUE:
> Exception in thread "Thread-1" java.lang.OutOfMemoryError: GC overhead limit exceeded\
Exception: java.lang.OutOfMemoryError thrown from the UncaughtExceptionHandler in thread "Thread-1"

This was raised when running files in *P14052_101* directory inside *trimm* directory. To overcome this, another flag was added to the code to run *fastqc* on the rest of the data.\
Personally I did not want to re run the whole data so keep in my that the last 12 samples were run with the flag *-t 2*, which indicated specifies the number of files which could be processedsimultaneously. Therefore this flag was not an additional parameter that can alter the outcome if it was to run everything again.
```bash
ls | while read folder; do cd $folder; ls | while read file; do fastqc -t 2 -o ../../fastqc/$folder $file ; done;  cd ..; done
```
After having the result, *multiqc.sh* script was run in the *fastqc* directory. It took about at least 5 minutes to run. See the scripts *multiqc.sh* for more information.
```bash
# Load module
module load bioinfo-tools MultiQC/1.12
# Run multiqc
multiqc .
```
## 4. Kraken2
```bash
ls | while read folder; do cd $folder; ls | paste - - - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1); pair2=$(echo $pair | cut -d ' ' -f 3); prefix=$(echo $pair | cut -d ' ' -f 1 | sed -E 's/(P[0-9]+_[0-9]+_[A-Z0-9]+)_L([0-9]+)_R[0-9]+_001_paired.fastq.gz/\1_L\2_001/');  kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --report-zero-counts --gzip-compressed --use-names --confidence 0.05 --paired $pair1 $pair2 --output ../../kraken/$folder/$prefix.out --report ../../kraken/$folder/$prefix.report ; done; cd ..; done
```