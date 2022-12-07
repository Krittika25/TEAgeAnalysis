### Set working dir and environmental variables
setwd("Google Drive/My Drive/Projects/NAM-Genomes/TE_analysis/")
options(stringsAsFactors = FALSE)

### Load the MSA library (to perform the sequence alignment)
library(msa)

### Load the phangorn library (to get the distance calculation)
library(phangorn)

### Get the list of all of the pairwise LTR fasta files 
### These were created by my perl script, and mine are in a 
### folder I called Test2
my.files = list.files(path="Test2", pattern="*.fa", full.names=TRUE)

### Using the file names, get the Chromosome, TE ID, and Pair ID for each file
temp = strsplit(gsub("\\.fa","", gsub("Test2\\/","", my.files)), split="_")
chr = as.numeric(unlist(lapply(lapply(temp,`[[`,1), substr, start=1, stop=2)))
te = as.numeric(unlist(lapply(lapply(temp, `[[`, 1), substring, first=3)))
pair1 = unlist(lapply(temp, `[[`, 2))
pair2 = unlist(lapply(temp, `[[`, 3))
pairID = paste(pair1, pair2, sep=".")

### Now set up a table to hold the results, with the chromosome, te and pair IDs for each TE
my.results = data.frame(Chromosome=chr, TE_ID=te, PAIR=pairID)

### Add empty columns for the alignment length and divergence values
my.results$Length = rep(0, nrow(my.results))
my.results$Divergence = rep(99, nrow(my.results))

### Loop through all of the files
for (i in 1:length(my.files)) {
  
  ## Align the pair of sequences with ClustalW
  aln = msa(readDNAStringSet(my.files[i]), method="ClustalW")
  
  ## Save the length of the alignment
  my.results$Length[i] = ncol(aln)
  
  ## Convert the object to the right format for phangorn
  dna = as.DNAbin(msaConvert(aln, type="phangorn::phyDat"))
  
  ## Calculate divergence with the K80 model (which is the default)
  my.results$Divergence = as.numeric(dist.dna(dna))
}

### Filter the table of results to remove alignments less than 80bp long
filter.results = my.results[which(my.results$Length>79),]

### Filter again to remove divergence values greater than 0.2
filter.results2 = filter.results[which(filter.results$Divergence<0.2),]

### Calculate the time of divergence based on the equation T=K/(2*r)
### For r, use the substition rate of 0.013 per million years, which comes
### from Ma and Bennetzen 2004
filter.results2$Age_MY = filter.results2$Divergence/(2 * 0.013)

### Save the table to a file
write.table(filter.results2, file="TE_age_estimate.txt", row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")
