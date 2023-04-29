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


