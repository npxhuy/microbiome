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

Author's note: I do not recommend to install through conda because it's more complicated when run the program in my experiecne, download the [package](https://github.com/usadellab/Trimmomatic/releases) and call the package when running the trimming process is more logical for me at least.
## FastQC
Version: [0.11.9](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)\
Description: Quality control tool for high throughput sequencing data.\
Installation: Available on UPPMAX's resources, but can be installed using **conda**
>conda install -c bioconda fastqc=0.11.9
## MultiQC
Version: [1.12](https://github.com/ewels/MultiQC)\
Description: Aggregating and visualizing quality control results from multiple FastQC.\
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
Description: Estimating the abundance of species in metagenomic samples \
Installation: Installed using **conda**
> conda install bracken=2.8
## R & R Studio
Version: R [4.3.0](https://cran.rstudio.com/) & R studio [2023.03.1+446](https://posit.co/download/rstudio-desktop/)\
Description: Data analysis & visualisation.\
Installation: Visit the link above for requirments and tutorial of installation.
* * * 
# Pipeline of analysis
* * *
In order to sucessufully follow this analysis, you must:
- Following strictly to the naming of directory, subdirectory, naming format, ect.
- Installing every software that was stated.
- To receive similar outcome, same version of software should be used.
## 1. Setting working directory & data.
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
mkdir bracken_F
mkdir bracken_F_filtered
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
# Note: using TruSeq3-PE.fa as an adapter file containing the adapter sequences to be trimmed
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
# -l is level, F stands for Family, S stands for Species
# -r is reading frame, since the multiqc report give the average length is from 100 to 150, we take 100
# -t is threshold, need at least 10 similar results to classify it as a family/species

# level Specices
ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l S -r 100 -t 10 -o ../bracken/$name.bracken ; done

# level Family
ls | while read report; do name=$(echo $report | sed 's/\.reports$//'); bracken -d /sw/data/Kraken2_data/prebuilt/k2_pluspf_20221209/ -i $report -l F -r 100 -t 10 -o ../bracken_F/$name.bracken ; done
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
# --exclude 9604 and --exclude 9606: exclude anything that mapped to human sequences (taxonomic id at family and species level respectively), which is our only metazoan representative
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_filtered/$name.bracken_filtered --exclude 9606 ; done

# Family
ls | while read bracken; do name=$(echo $bracken | sed 's/\.bracken$//'); python ../tools/KrakenTools/filter_bracken.out.py -i $bracken -o ../bracken_F_filtered/$name.bracken_filtered --exclude 9604 ; done
```
## 6. Richness & DiversityTools (KrakenTools - alpha_diversity.py & beta_diversity.py)
### Richness
This script was run directly in the *bracken_filtered* directory. This scripts took at least 1 minutes to run on the server
```bash
# Note: Do not need to batch this on UPPMAX, this task does not take much resources.
# 1. Loop through the bracken results
# 2. Sed the name of the file for naming the output
# 3. Count the total of line except for the header (the number of lines represent the richness)
# 4. Output the name and count into a file called species_count.txt

ls | while read file; do name=$(echo $file| cut -d "." -f 1)  ;count=$(cat $file | grep -v "new_est_reads" |  wc -l); echo $name $count; done > ../diversity_result/species_count.txt

# Family
ls | while read file; do name=$(echo $file| cut -d "." -f 1)  ;count=$(cat $file | grep -v "new_est_reads" |  wc -l); echo $name $count; done > ../diversity_result/family_count.txt
```
### Shannon's alpha diversity
The script *alpha_shannon.sh* was run in *bracken_filtered* directory. See the scripts *alpha_shannon.sh* for more information.\
Calculate Shannon's alpha diversity using KrakenTools (*alpha_diversity.py*). The calculating process took at least 1 minutes to run on the server.
```bash
# 1. Loop through the bracken's results
# 2. Cut the file name for naming
# 3. Calculate alpha diversity, cut the result to have only the wanted information.
# 4. Write results in shannon_alpha.txt
ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file | cut -d : -f 2); echo $name $result; done > ../diversity_result/shannon_alpha.txt

# For bracken result in family level
ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file | cut -d : -f 2); echo $name $result; done > ../diversity_result/shannon_alpha_F.txt
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

# For bracken result in family level
ls | while read file; do name=$(echo $file | cut -d . -f 1); result=$(python ../tools/KrakenTools/DiversityTools/alpha_diversity.py -f $file -a ISi | cut -d : -f 2); echo $name $result; done > ../diversity_result/inverse_simpson_alpha_F.txt
```
### Beta diversity
Create all possible combination of 2 of the filtered bracken files for calculating beta diversity. Run in *bracken_filtered* directory.
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
# For bracken results at level Family
cat ../combination.txt | while read pair; do result=$(python ../tools/KrakenTools/DiversityTools/beta_diversity.py -i $pair --type bracken); echo $result; done >> ../diversity_result/beta_F.txt

# For bracken results at level Species
cat ../combination.txt | while read pair; do result=$(python ../tools/KrakenTools/DiversityTools/beta_diversity.py -i $pair --type bracken); echo $result; done >> ../diversity_result/beta.txt
```
## 7. Data analysis & visualisaiton

Three main analysis will be done, including:
1. Alpha diversity\
Required files: *shannon_alpha.txt* and *inverse_simpson_alpha.txt* in the *diversity_result* directory.
2. Beta diversity\
Required files: *beta.txt* in the *diversity_result* directory.
3. PCA\
Required files: 96 bracken filtered files in the *bracken_filtered* directory.

Those files were copied to local computer using [scp](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) and the following data analysis and visualisation are mainly done in R except where noted.\
Additionally, a *all.pops.metadata.tsv* file that has all the information of the sample inculding host plant, transect, population and host range, is used for this part.
```bash
head /proj/snic2022-6-377/Projects/Tconura/working/Rachel/all.pops.metadata.tsv 
sample_id	pop	hostplant	transect	hostrange
P12002_144	CHES	CH	East	Sympatric
P12002_145	CHES	CH	East	Sympatric
P12002_146	CHES	CH	East	Sympatric
P12002_147	CHES	CH	East	Sympatric
P12002_148	CHES	CH	East	Sympatric
P12002_149	CHES	CH	East	Sympatric
P12002_150	CHES	CH	East	Sympatric
P12002_151	CHES	CH	East	Sympatric
P12002_152	CHES	CH	East	Sympatric
```
### 1. Alpha diversity
Plotting box plot to visuallise the alpha diversity and the richness of samples. In order to use this code on your own computer, you have to change the working directory. Your directory must have the required files.
```r
# Set working directory
setwd("set/your/own/directory") 

# Load library, you may have to install them first using install.package()
library(lme4)
library(tidyverse)
library(dyplr)

# Load required data
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)
count <- read.table("species_count.txt",col.names = c("sample_id","richness"))
alpha1 <- read.table("shannon_alpha.txt", col.names = c("sample_id","shannon"))
alpha2 <- read.table("inverse_simpson_alpha.txt", col.names = c("sample_id","inverse_simpson"))

# Join with the metadata
count_join <- (count) %>%
  left_join(metadata, by = "sample_id")
alpha1_join <- (alpha1) %>%
  left_join(metadata, by = "sample_id")
alpha2_join <- (alpha2) %>%
  left_join(metadata, by = "sample_id")

# Plotting
richness <- ggplot(count_join, aes(x=pop,y=richness, color=hostplant, shape=hostrange)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  xlab("Population") + ylab("Richness") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

alpha1_plot <- ggplot(alpha1_join, aes(x=pop,y=shannon, color=hostplant, shape=hostrange)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  xlab("Population") + ylab("Shannon Diversity") +
  facet_grid(~transect, scales = "free") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

alpha2_plot <- ggplot(alpha2_join, aes(x=pop,y=inverse_simpson, color=hostplant)) +
  scale_color_manual(values = c("#5E548E", "#32936F"), name = "Hostplant")+
  geom_boxplot(outlier.shape = NA) + theme_bw() +
  facet_grid(~transect, scales = "free")+
  xlab("Population") + ylab("Inverse Simpson Diversity") +
  theme(legend.position = "bottom") +
  geom_jitter(width = 0.1)

# Saving plot richness
ggsave(plot = richness, filename = "richness.pdf", height = 3.5, width = 5.5)

# Saving plot alpha diversity
combine <- ggarrange(alpha1_plot, alpha2_plot, ncol = 1,nrow = 2, common.legend = TRUE, labels = "AUTO", legend = "bottom")
ggsave(plot = combine, filename = "combine_alpha_F.pdf", height = 7, width = 5.5)
```

### 2. Beta diversity
The raw *beta.txt* result is kinda messy so run this code in **bash** to take only the information we want.
```bash
head beta.txt
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_102.bracken_filtered (102099 reads) x 0 1 0 0.000 0.315 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_103.bracken_filtered (278914 reads) x 0 1 0 0.000 0.673 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_104.bracken_filtered (118762 reads) x 0 1 0 0.000 0.413 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_105.bracken_filtered (314229 reads) x 0 1 0 0.000 0.653 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_106.bracken_filtered (80230 reads) x 0 1 0 0.000 0.497 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_107.bracken_filtered (118902 reads) x 0 1 0 0.000 0.277 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_108.bracken_filtered (111833 reads) x 0 1 0 0.000 0.454 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_109.bracken_filtered (503861 reads) x 0 1 0 0.000 0.729 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_110.bracken_filtered (111549 reads) x 0 1 0 0.000 0.353 1 x.xxx 0.000
#0 P12002_101.bracken_filtered (136408 reads) #1 P12002_111.bracken_filtered (91837 reads) x 0 1 0 0.000 0.256 1 x.xxx 0.000

# Clean the data
cat beta.txt | while read line; do s1=$(echo $line | cut -d " " -f 2 | sed 's/\.bracken_filtered$//'); s2=$(echo $line | cut -d " " -f 6 | sed 's/\.bracken_filtered$//'); v=$(echo $line | cut -d " " -f 14) ; echo $s1 $s2 $v; done > newbeta.txt

# Result
head newbeta.txt 
P12002_101 P12002_102 0.315
P12002_101 P12002_103 0.673
P12002_101 P12002_104 0.413
P12002_101 P12002_105 0.653
P12002_101 P12002_106 0.497
P12002_101 P12002_107 0.277
P12002_101 P12002_108 0.454
P12002_101 P12002_109 0.729
P12002_101 P12002_110 0.353
P12002_101 P12002_111 0.256
```
A matrix was built base on this beta diversity results to contrusct the heatmap. In order to use this code on your own computer, you have to change the working directory. Your directory must have the required files.
```r
# Set working directory
setwd("/set/your/own/working/directory")

# Load library, you may want to install them with install.package()
library(dplyr)
library(circlize)
library(ComplexHeatmap)

# Load data
data <- read.table("newbeta.txt")
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)

# Prepare to construct matrix
metadata <- metadata %>%
  arrange(pop)

# Change label
metadata <- metadata %>%
  group_by(pop) %>%
  mutate(new_pop = paste0(pop, "_", sprintf("%02d", row_number()))) # Add a new column name "new_name" with value of pop and count number 

# Make new_data by merging the original data with the meta data
new_data <- merge(data, metadata, by.x = "V1", by.y = "sample_id", all.x = TRUE)
new_data <- merge(new_data, metadata, by.x = "V2", by.y = "sample_id", all.x = TRUE)

# Select the required columns in the desired order
new_data <- new_data[, c("new_pop.x", "new_pop.y", "V3")]

# Rename the columns
colnames(new_data) <- c("V1", "V2", "V3")

# Extract unique sample names
sample_names <- sort(unique(c(new_data$V1, new_data$V2)))

# Create an empty matrix
# Dimensions based on the length of the sample_names vector. 
# The matrix is initialized with zeros.
matrix_data <- matrix(0, nrow = length(sample_names), ncol = length(sample_names))

# Fill in the matrix with values from the third column
# The for loop iterates over each row of the data data frame:
for (i in 1:nrow(new_data)) { 
  # Finds the index of the V1 value in the sample_names vector and assigns it to row_index
  row_index <- match(new_data$V1[i], sample_names)
  # Finds the index of the V2 value in the sample_names vector and assigns it to col_index
  col_index <- match(new_data$V2[i], sample_names)
  # Assigns the value from the V3 column of data to the corresponding position in matrix_data.
  matrix_data[row_index, col_index] <- new_data$V3[i]
  # Set symmetrical value
  matrix_data[col_index, row_index] <- new_data$V3[i]  
}

# Transposes the matrix to a symmetrical matrix
matrix_data <- t(matrix_data)

# Set row and column names
rownames(matrix_data) <- sample_names
colnames(matrix_data) <- sample_names

# Transform to matrix
df <- as.data.frame(matrix_data)
df$row <- rownames(matrix_data)

# Reshape the data to long format
df_long <- reshape2::melt(df, id.vars = "row")

# Plot the heatmap using ggplot
norm_heat <- ggplot(df_long, aes(x = variable, y = row, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#534b7e") +
  theme_minimal() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  labs(fill = "Beta diversity") + xlab("") + ylab("")

# Clustering heatmap + dendogram
col_fun = colorRamp2(c(0, 0.8), c("white", "#534b7e"))
heat_dendo <- Heatmap(matrix_data,
        clustering_distance_rows = "euclidean",
        heatmap_legend_param = list(
          title = "Beta diversity",
          labels = c(0,0.2,0.4,0.6,0.8)),
        col = col_fun,
        row_names_gp = gpar(fontsize = 8),
        column_names_gp = gpar(fontsize = 8))

# Save plot
ggsave(plot = norm_heat, filename = "norm_heat.pdf", height = 11, width = 12)

# heat_dendo was saved differently because can't use ggsave, have not figured out why
pdf("heat_dendo.pdf",width = 12, height = 11)
draw(heat_dendo)
dev.off()
```
### 3. PCA
Construct PCA data for plotting, with 3 different filter parameters:
1. Species appeared in at least one sample
2. Species appeared in at least 30% of samples
3. Species appeared in at least 50% of samples

With bracken results, we only interested in the estimated reads, so we gonna filtered out the bracken_filtered data one more time before running analysis in **bash**. This code was run in the folder that has the bracken_filtered files.
```bash
# Original file
head P12002_101.bracken_filtered 

name	taxonomy_id	taxonomy_lvl	kraken_assigned_reads	added_reads	new_est_reads	fraction_total_reads
Staphylococcus haemolyticus	1283	S	8441	17879	26320	0.1929505601
Ralstonia solanacearum	305	S	10812	7557	18369	0.1346621899
Nonlabens sp. MB-3u-79	2058134	S	822	16060	16882	0.1237610697
Flammeovirga sp. MY04	1191459	S	12048	287	12335	0.0904272477
Paenalkalicoccus suaedae	2592382	S	6464	1860	8324	0.0610228139

# Clean the file
# A new directory outside the folder that has the bracken_filtered results must be made, for demonstration I name it "new_bracken_folder"
ls | while read file; do cat $file | cut -f 1,6 > ../new_bracken_folder/$file; done

# Result
head P12002_101.bracken_filtered

name	new_est_reads
Staphylococcus haemolyticus	26320
Ralstonia solanacearum	18369
Nonlabens sp. MB-3u-79	16882
Flammeovirga sp. MY04	12335
Paenalkalicoccus suaedae	8324
```
```r
# Set working directory
setwd("/set/your/own/working/directory")

# Load library, you may want to install them with install.package()
library(tidyverse)
library(dplyr)
library(tibble)
library(ggplot2)
library(DESeq2)
library(RColorBrewer)
library(ggpubr)

# Functions
# Function 1: Merge data function
merge_data_funciton <- function(dir){
  setwd(dir)
  # Take the directory that contains the bracken files
  # Put the names of the files into a list
  files <- list.files(dir)
  # Manually handle the first file
  merge_data <- read.table(files[1], header=TRUE, sep='\t') # Read file
  name <- sub("\\..*", "", files[1]) # Change column name
  colnames(merge_data)[2] <- name
  
  # Set the first data frame as a variable for the loop
  # merge_data <- one
  for (i in 2:length(files)){ # Loop through the files
    temp_data <- read.table(files[i], header=TRUE, sep='\t') # Read the df
    colnames(temp_data)[2] <- sub("\\..*", "", files[i]) # Change column name
    merge_data <- merge(merge_data, temp_data, all.x = TRUE, all.y = TRUE) # Merge
  }
  return(merge_data)
}

# Function 2: Find rows of species that need to be removed
removed <- function(percentage, dat, thres) {
  to_be_removed <- c()
  for (i in 1:nrow(dat)) {
    if (sum(dat[i, ] <= thres) >= ((1-percentage) * ncol(dat))) { # Here we count the number of 0 instead of species, so have to 1 - percentage
      to_be_removed <- c(to_be_removed, i)
    }
  }
  return(to_be_removed)
}

# Function 3: Remove the rows from data
clean_data <- function(vec,dat){
  if (length(vec)>0){
    for (i in 1:length(vec)){
      dat <- dat[-rev(vec)[i],]
    }
  }
  return(dat)
}

# Load data
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)

# Merge data
merge_data <- merge_data_funciton("/directory/to/folder/of/bracken")

# Replace NA in ORIGINAL DATA with 0
raw_counts_matrix <- merge_data %>% 
  mutate(across(where(is.numeric), ~replace_na(.x, 0))) %>% # Replace NA with 0
  column_to_rownames("name") %>% #Change to first column (label as name) to the row name
  as.matrix()

# PCA 1: Original + log2
PCA1 <- log2(raw_counts_matrix +1)

# PCA 2: 30%
PCA2 <- log2(clean_data(vec = removed( percentage = 0.3, dat = raw_counts_matrix, thres = 0),
                        dat = raw_counts_matrix) + 1)

# PCA 3: 50%
PCA3 <- log2(clean_data(vec = removed( percentage = 0.5, dat = raw_counts_matrix, thres = 0),
                        dat = raw_counts_matrix) + 1)

# RUN PCA
plotPCA <- function(PCA,x1,x2,y1,y2){ #Take PCA data and xlim and ylim value for aesthetic
  PCA.scaled_log_counts <- prcomp(t(PCA), scale. = F, center = T)
  
  PCA.summary <- as.data.frame(t((summary(PCA.scaled_log_counts))$importance)) %>% 
    rownames_to_column(var = "Principal Component")
  
  PCA.data.frame <- (as.data.frame(PCA.scaled_log_counts$x)) %>%
    rownames_to_column(var = "sample_id") %>% 
    left_join(metadata, by = "sample_id") 
  
  first <- ggplot(PCA.data.frame, aes(x = PC1, y = PC2)) +
    xlim(x1, x2) + ylim(y1, y2) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_point(size = 4, stroke = 1.25, aes(shape = pop, color = hostplant)) +
    scale_color_manual(values = c("#5E548E", "#32936F"), name = "Host Plant")+
    geom_point(pch = 21,stroke = 0, size = 2, aes(fill = hostrange)) +
    scale_shape_manual(values = c(0,1,15,16,2,17,5,18), name = "Population") +
    scale_fill_manual(values = c("Allopatric" = "white", "Sympatric" = "black"), name = "Host Range") +
    theme_minimal(base_size = 12) + theme(legend.position = "bottom",legend.key = element_rect(fill = "lightgrey")) + 
    facet_grid(~transect)
  
  second <- ggplot(PCA.data.frame, aes(x = PC2, y = PC3)) +
    xlim(x1, x2) + ylim(y1, y2) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_point(size = 4, stroke = 1.25, aes(shape = pop, color = hostplant)) +
    scale_color_manual(values = c("#5E548E", "#32936F"), name = "Host Plant")+
    geom_point(pch = 21,stroke = 0, size = 2, aes(fill = hostrange))+
    scale_shape_manual(values = c(0,1,15,16,2,17,5,18), name = "Population") +
    scale_fill_manual(values = c("Allopatric" = "white", "Sympatric" = "black"), name = "Host Range") +
    theme_minimal(base_size = 12) + theme(legend.position = "bottom",legend.key = element_rect(fill = "lightgrey")) + 
    facet_grid(~transect)
  
  # Arrange two plots
  final <- ggarrange(first, second, ncol = 2, nrow = 1, common.legend = TRUE, legend = "bottom")
  
  return(final)
}
# The number are only for aesthetic of the plot (the xlim and ylim)
PCA1_plot <- plotPCA(PCA1, -70, 60, -70, 25)
PCA2_plot <- plotPCA(PCA2, -40, 50, -25, 25)
PCA3_plot <- plotPCA(PCA3, -40, 40, -20, 25)

#Save plot
ggsave(plot = PCA1_plot, filename = "0.pdf", height = 5, width = 8)
ggsave(plot = PCA2_plot, filename = "30.pdf", height = 5, width = 8)
ggsave(plot = PCA3_plot, filename = "50.pdf", height = 5, width = 8)
```

### 4. Hierarchical model
Find the most fitting model. The initial model includes all the factors, and we cut the factors out of the model base on the ANOVA result of that model. If a factor or a combination of factors was to be insignificant, it will be cut out of the model.
The *model_family.R* and *model_species.R* show all the code for running model, here is an example of finding the most fitting model of Inverse Simpson's alpha diversity on Family level.
```r
setwd("/set/your/working/directory")
metadata <- read.table("all.pops.metadata.tsv",header=TRUE)

# Inverse Simpson Family
isi_F <- read_table("inverse_simpson_alpha_F.txt", 
                        col_names= c("sample_id", "inverse_simpson"), 
                        col_types = "cd")

full_isi_F <- full_join(metadata, isi_F) # Combine with metadata

# Initial model
F_isi1 <- lm(inverse_simpson ~ hostplant*transect*hostrange, data = full_isi_F)
anova(F_isi1) # Base on the anova result of this, we decided what to drop on the next model, and continued to do so for the rest

# drop 3way interaction
F_isi2 <- lm(inverse_simpson ~ hostplant*transect + hostplant*hostrange + transect*hostrange, data = full_isi_F)
anova(F_isi2)

# drop hostplant*transect
F_isi3 <- lm(inverse_simpson ~  hostplant*hostrange + transect*hostrange, data = full_isi_F)
anova(F_isi3)

# drop hostplant*hostrange
F_isi4 <- lm(inverse_simpson ~ hostplant + transect*hostrange, data = full_isi_F)
anova(F_isi4)

# drop hostplant
F_isi5 <- lm(inverse_simpson ~  transect*hostrange, data = full_isi_F)
anova(F_isi5)

# drop transect * host range
F_isi6 <- lm(inverse_simpson ~  transect + hostrange, data = full_isi_F)
anova(F_isi6) # F_isi5 appeared to be the most fitting model but we still drop it down another level for comparision

# AIC and BIC score
AIC(F_isi1, F_isi2, F_isi3, F_isi4, F_isi5, F_isi6)
BIC(F_isi1, F_isi2, F_isi3, F_isi4, F_isi5, F_isi6)

# Compare between models to have F score, df, and p value
anova(F_isi2, F_isi1)
anova(F_isi3, F_isi2)
anova(F_isi4, F_isi3)
anova(F_isi5, F_isi4)
anova(F_isi6, F_isi5)

# This model is the most suitable, so look into that model
print(F_isi5)
anova(F_isi5)
```


