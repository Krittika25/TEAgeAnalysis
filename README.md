# TEAgeAnalysis

This repository contains information on performing age analysis on transposable elements found in sorghum genomes (NAM panel).

Transposable element (TE) age analysis is performed by comparing the 5' and 3' terminal repeat regions to look for sequence divergence.

To annotate the TE structure, TE-greedy-nester tool was used. Information on this tool can be accessed at https://gitlab.fi.muni.cz/lexa/nested

The input and output files can be accessed on the HPC cluster- /nobackup/cooper_research/krittikak/nester_output

###Steps:
1. Run TE-greedy-nester on the scaffold data.
The data is generated per chromosome. This data was concatenated into a single file before proceeding to the next step.

2. Filter out only the Right and Left ends for each TE id from TE-greedy-nester output.

3. Get the FASTA sequences for the right and left ends- used bedtools getfasta. 
The FASTA headers were renamed to contain the TE pair ids.

4. Right and Left pairs were split into their own fasta files for performing pairwise alignment- custom perl script get_LTR_pairs.pl used.

5. Performed pairwise sequence alignment and calulation of TE age- custom R script TEage.R used.

6. TE positions were added to the output of age calculation to be able to visualize the age distribution -  custom perl script saveTEpos2.pl used.
