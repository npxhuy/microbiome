# Deadline and tracking hand-in files  and other important stuffs (to be deleted later)
## PRESENTATION DAY: 14 June
## -> SUBMISSION: 7 June
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
This project was mainly done in the server UPPMAX (except from data analysis & visualisation). Most of the applications/packages/softwares were already installed on the server, except where noted.\
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
## KrakenTools
Description: Merge kraken reports and subset braken's output.\
Installation: Clone from [github](https://github.com/jenniferlu717/KrakenTools)
> git clone https://github.com/jenniferlu717/KrakenTools
## Bracken
Version: [2.8](https://github.com/jenniferlu717/Bracken)\
Description: \
Installation: Installed using **conda**
> conda install bracken=2.8
## R & R Studio
Version: R [4.3.0](https://cran.rstudio.com/) & R studio [2023.03.1+446](https://posit.co/download/rstudio-desktop/)\
Description: Data analysis & visualisation.\
Installation: Visit the link above for requirments and tutorial of installation.
* * * 
# Pipeline of analysis
**NOTE**  
Add a link tree of the working directory at (1).\
Add absolute working dir on uppmax at (2)\
* * *
My file tree of my repository on the server could be found [here](). (1)\
The absolute path to the working directory on the UPPMAX's server is: (2)\
The absolute path to the raw data on UPPMAX's server is: 
>/proj/snic2022-6-377/Projects/Tconura/data/WGS/rawdata/

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
mkdir tools
mkdir env
mkdir wgs_sample
mkdir trimm
mkdir fastqc
mkdir multiqc
mkdir kraken
mkdir kraken_combined
mkdir bracken
mkdir bracken_filtered
mkdir diversity_result
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
### STEP 1: Make directories in trimm
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
### FastQC
The script *fastqc.sh* was run in *trimm* directory. See the scripts *fastqc.sh* for more information.\
The fastqc process was estimated to take about 12 hours to run on the server.\
```bash
### STEP 1: Make directories in fastqc
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
### MultiQC
After having the result, *multiqc.sh* script was run in the *fastqc* directory. It took about at least 5 minutes to run. See the scripts *multiqc.sh* for more information.
```bash
# Load module
module load bioinfo-tools MultiQC/1.12
# Run multiqc
multiqc .
```
## 4. Kraken2 and KrakenTools (combine_kreports.py)
### Kraken2
The script *kraken.sh* was run in *trimm* directory. See the scripts *kraken.sh* for more information.\
The Kraken2 process was estimated to take about 16 hours to run on the server.
```bash
### STEP 1: Make directories in kraken
cd kraken
cat ../id.txt | while read folder; do mkdir $folder; done

### STEP 2: Run Kraken2
# Load tools from UPPMAX
module load bioinfo-tools Kraken2/2.1.2-20211210-4f648f5

# 1. Loop through folder and cd to folder
# 2. Each folder now have 4 files for each pair (2 unpaired and 2 paired), paste to make 4 files in one line
# 3. Extract the pair with pair1 and pair2, prefix using regex for naming in kraken
# 4. Run kraken
ls | while read folder; do cd $folder; ls | paste - - - - | while read pair; do pair1=$(echo $pair | cut -d ' ' -f 1); pair2=$(echo $pair | cut -d ' ' -f 3); prefix=$(echo $pair | cut -d ' ' -f 1 | sed -E 's/(P[0-9]+_[0-9]+_[A-Z0-9]+)_L([0-9]+)_R[0-9]+_001_paired.fastq.gz/\1_L\2_001/');  kraken2 –db /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ --threads 20 --report-zero-counts --gzip-compressed --use-names --confidence 0.05 --paired $pair1 $pair2 --output ../../kraken/$folder/$prefix.out --report ../../kraken/$folder/$prefix.report ; done; cd ..; done
```
### Combine Krakens' result
The script *kraken_combined.sh* was run in *kraken* directory. See the scripts *kraken_combined.sh* for more information.\
The KrakenTools' combining process was estimated to take at least 3 minutes to run on the server. 
```bash
### STEP 1: Download KrakenTools
cd tools
git clone https://github.com/jenniferlu717/KrakenTools

### STEP 2: Run KrakenTools to merge Kraken2's report files
# Note: Do not need to batch this on UPPMAX, this task does not take much resources.

# 1. Loop through folder and cd to folder
# 2. Take only the report files in the directory and put them all in one line as a variable $reports
# 3. Run the KrakenTools on the reports and cd back to the main folder
ls| while read folder; do cd $folder; reports=$(ls *report | tr '\n' ' '); python ../../tools/KrakenTools/combine_kreports.py -r $reports --only-combined -o ../../kraken_combined/$folder.reports; cd .. ; done

ls| while read folder; do cd $folder; reports=$(ls *report | tr '\n' ' '); python ../../tools/KrakenTools/combine_kreports.py -r $reports --only-combined -o ../../kraken_combined2/$folder.reports; cd .. ; done
```
## 5. Bracken and KrakenTools (filter_bracken_out.py)
### Bracken
The script *bracken.sh* was run in *kraken_combined* directory. See the scripts *bracken.sh* for more information.\
The Bracken process was estimated to take at least 2 minutes to run on the server. 

```bash
# Load and install bracken
module load conda # Load conda on uppmax
export CONDA_ENVS_PATH=/proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env # Change env directory 
conda create -n microbiome # Create new env
source conda_init.sh #Only needed when run on UPPMAX
conda activate /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env/microbiome # Activate this environment
conda install bracken=2.8

# Bracken
# Note: Do not need to batch this on UPPMAX, this task does not take much resources.

# 1. Loop through the combined report files
# 2. Sed the name of the file for naming the output
# 3. Run Bracken on the report file

# Parameter's explanation: 
# -d is database, same database when using to run Kraken
# -l is level, S stands for Species
# -r is reading frame, since the multiqc report give the average length is from 100 to 150, we take 100
# -t is threshold, need at least 10 similar results to classify it as a species
ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l S -r 100 -t 10 -o ../bracken/$name.bracken ; done

# Run level Family
module load conda; source conda_init.sh; conda activate /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env/microbiome ; ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l F -r 100 -t 10 -o ../bracken_F/$name.bracken ; done

#Genus
module load conda; source conda_init.sh; conda activate /proj/snic2022-6-377/Projects/Tconura/working/Huy/test/env/microbiome ; ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l G -r 100 -t 10 -o ../bracken_G/$name.bracken ; done
```
### Filter bracken's results
The script *bracken_filtered.sh* was run in *bracken* directory. See the scripts *bracken_filtered.sh* for more information.\
The KrakenTools' filtering process was estimated to take at least 1 minutes to run on the server. 
```bash
# Note: Do not need to batch this on UPPMAX, this task does not take much resources.
# 1. Loop through the bracken results
# 2. Sed the name of the file for naming the output
# 3. Run KrakenTools on the bracken results

# Parameter's explanation:
# --exclude 9606: exclude anything that mapped to human sequences (taxonomic id 9606), which is our only metazoan representative
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_filtered/$name.bracken_filtered --exclude 9606 ; done

# Family
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../../bracken_F_filtered/$name.bracken_filtered --exclude 9604 ; done

# Genus include wolbachia
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_F_filtered/$name.bracken_filtered --include 953 ; done

ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_Wolbachia_filtered/$name.bracken_filtered --include $wol ; done


#Filter out only wolbachia
wol=$(ls | while read file; do cat $file | grep "Wolbachia" | cut -f 2 | sort | uniq| tr "\n" " "; done); ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_wolbachia_filtered/$name.bracken_wol_filtered --include $wol --exclude 9606 ; done
```
## 6. DiversityTools (KrakenTools - alpha_diversity.py & beta_diversity.py)
### Shannon's alpha diversity
The script *alpha_shannon.sh* was run in *bracken_filtered* directory. See the scripts *alpha_shannon.sh* for more information.\
Calculate Shannon's alpha diversity using KrakenTools (*alpha_diversity.py*). The calculating process took at least 1 minutes to run on the server.
```bash
# 1. Loop through the bracken's results
# 2. Cut the file name for naming
# 3. Calculate alpha diversity, cut the result to have only the wanted information.
# 4. Write results in shannon_alpha.txt
ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file | cut -d : -f 2); echo $name $result; done > ../diversity_result/shannon_alpha.txt
```
### Inverse Simpson's alpha diversity
The script *alpha_inverse_simpson.sh* was run in *bracken_filtered* directory. See the scripts *alpha_inverse_simpson.sh* for more information.\
Calculate inverse Simpson's diversity using KrakenTools (*alpha_diversity.py*). The calculating process took at least 1 minutes to run on the server.
```bash
# 1. Loop through the bracken's results
# 2. Cut the file name for naming
# 3. Calculate alpha diversity, cut the result to have only the wanted information.
# 4. Write results in inverse_simpson_alpha.txt
ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file -a ISi | cut -d : -f 2); echo $name $result; done > ../diversity_result/inverse_simpson_alpha.txt
```
### Beta diversity
Create all possible combination of 2 of the filtered bracken files for calculating beta diversity.
```bash
# 1. Store all files names in an array
# 2. Run a nested for loop to iterate over all possible combinations of two files in the files array. The outer loop iterates over the indices of the first file in each pair, while the inner loop iterates over the indices of the second file in each pair. The range of the inner loop starts from the index of the outer loop plus one to avoid duplicate pairs.
# 2.1 For each pair of files, prints them out on a single line separated by a space. The filenames are accessed using the array indices i and j, which correspond to the indices of the first and second files in each pair, respectively. The ${files[i]} and ${files[j]} syntax retrieves the filenames stored in the files array at the specified indices.
# 2.2 Break down of the for loop:
# 2.2.1 'for' is the keyword used to indicate the start of the loop.
# 2.2.2 '((' indicates that the loop uses C-style syntax.
# 2.2.3 'i=0' initializes a variable called 'i' to zero, which will be used to track the current index in the loop.
# 2.2.4 'i<${#files[@]}' sets the condition that the loop will continue as long as the value of 'i' is less than the number of elements in the 'files' array.
# 2.2.5 'i++' is the operation that increments the value of i by one after each iteration of the loop.
# 2.2.6 '))' indicates the end of the loop.
# 3. Save the printed pairs into a file call 'combination.txt'
files=($(ls)) ;for (( i=0; i<${#files[@]}; i++ )); do for (( j=i+1; j<${#files[@]}; j++ )); do echo "${files[i]} ${files[j]}"; done ; done > combination.txt
```
The script *beta_diversity.sh* was run in *bracken_filtered* directory. See the scripts *beta_diversity.sh* for more information.\
Calculate inverse beta diversity using KrakenTools (*beta_diversity.py*). The calculating process took at least 8 minutes to run on the server.
```bash
cat ../combination.txt | while read pair; do result=$(python ../tools/KrakenTools/DiversityTools/beta_diversity.py -i $pair --type bracken); echo $result; done >> ../diversity_result/beta.txt
```
## 7. Data analysis

```bash
cat beta.txt | while read line; do s1=$(echo $line | cut -d " " -f 2 | sed 's/\.bracken_filtered$//'); s2=$(echo $line | cut -d " " -f 6 | sed 's/\.bracken_filtered$//'); v=$(echo $line | cut -d " " -f 14) ; echo $s1 $s2 $v; done
```


ls | while read file; do cat $file | cut -f 1,6 > ../copy_local_2/$file; done



