# 19-26 Apr's questions
1. What does Kraken2 do? 
> Kraken2 is a tool in bioinformatics that is used to classify DNA sequences based on their taxonomic origin. It compares input sequences to a database of reference genomes to determine their similarity and assigns them a taxonomic label accordingly. This tool is especially useful for analyzing large datasets of microbial samples, where identifying the microbial community structure is important.
2. Are there other tools that do what Kraken2 does? How does Kraken2 compare? 
> There are other bioinformatics tools that classify DNA sequences based on their taxonomic origin, including MetaPhlAn, MEGAN, and CLARK. However, Kraken2 is highly regarded for its accuracy and efficiency in this task. It has a strong ability to accurately identify the taxonomic origin of DNA sequences and can handle large datasets quickly and with minimal computational resources. Additionally, Kraken2 is easy to use and compatible with various operating systems and programming languages.
3. What is the difference between Bracken and Kraken2? 
> Bracken is a tool that is used in combination with Kraken2 to estimate the abundance of taxa in metagenomic samples. It uses the output from Kraken2 to generate more accurate estimates of the abundance of different taxa. While Kraken2 is used for taxonomic classification of DNA sequences, Bracken is used for abundance estimation. 

> Kraken2 uses a database of reference genomes to assign taxonomic labels to input sequences based on their similarity to the reference sequences. On the other hand, Bracken uses a statistical model to estimate the abundance of taxa based on the number of reads assigned to each taxonomic label by Kraken2.  

> In summary, Kraken2 is used for taxonomic classification of DNA sequences, while Bracken is used for abundance estimation based on the output from Kraken2.
4. Why do we combine these two tools in the pipeline we are following (Lu et al. 2022). 
> For microbiome analysis, host-filtered microbial reads undergo classification against 
bacterial, viral, fungal, archaeal, and human genomes using Kraken 2. The 
classification report is then used by Bracken for species abundance estimation, which 
provides estimated reads per species in the sample.

> can obtain more accurate and reliable taxonomic and abundance information about the microbial community in a metagenomic sample.
5. In the pipeline (Lu et al. 2022), the first step is mapping to the reference genome. Why do they recommend this? 
> I guess the mapping step is to have a more accurate ref gene so when run Kraken, like can removeing the human or  host DNA from the samples cause it may contains contamination
6. We will not be mapping to the reference first because the reference has a load of microbial sequences. Do you think skipping this mapping step could cause any problems?
> As I remember, if we do mapping step first it could remove the host sample and potentially remove the microbiome DNA that we are interested in.

> If we do not remove, after running Kraken we might have bunches of identification saying there is are certain % come from the host or human ect because we did not remove them initially. Means we have more information to deal with.
