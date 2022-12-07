#!/usr/bin/perl -w
# saveTE_pos.pl
# get TE positions in a table with chr and id
# this output is needed to associate positions with TE ages from R script
# July 5, 2022
# L.Cooper

# Edited on July 29, 2022 to also save the max position for each TE

use strict;

# Get the name of the tagged fasta file, the age file and an output file name from the command line
my ($USAGE) = "$0 <tagged.fa> <age.txt> <output.txt>\n";
unless ((@ARGV) && ((scalar @ARGV) == 3)) {
  print $USAGE;
  exit;
}
my ($input, $agefile, $output) = @ARGV;

# Create a hash to save smallest positions associated with each TE
# the hash needs to be keyed by chr.TEID to be unique
my %positions = ();

# Create a second hash to also save the largest/end position associated with each TE
my %end_positions = ();

# Read through the fasta file one line at a time
# parse each header line to extract chromosome, TE ID, and position info
open (IN, $input) || die "\nUnable to open the file $input!\n";
while (<IN>) {
  chomp $_;

  if ($_ =~ /^>/) {
    my @info = split(/\s{1,}/, $_);
    my @info2 = split(/_/, $info[0]);
    my $chr = $info2[0];
    $chr =~ s/>Chr//g;
    $chr = int($chr);
    $info2[1] =~ s/RagTag\://g;
    my @pos = split(/\-/, $info2[1]);
    my $min_pos = $pos[0] < $pos[1] ? $pos[0] : $pos[1];
    my $max_pos = $pos[1] > $pos[0] ? $pos[1] : $pos[0];
    my @info3 = split(/\-/, $info[2]);
    my $teID = int($info3[0]);
    my $temp_key = $chr . "." . $teID;

    if (exists $positions{$temp_key}) {
      $positions{$temp_key} = $positions{$temp_key} < $min_pos ? $positions{$temp_key} : $min_pos;
    } else {
      $positions{$temp_key} = $min_pos;
    }

    if (exists $end_positions{$temp_key}) {
      $end_positions{$temp_key} = $end_positions{$temp_key} > $max_pos ? $end_positions{$temp_key} : $max_pos;
    } else {
      $end_positions{$temp_key} = $max_pos;
    }
  } else {
    next;
  }
}
close(IN);

# Open the output file for printing
open (OUT, ">$output") || die "\nUnable to open the file $output\n";

# Open the TE age estimate file and start reading through line by line
# add the header to the output file, plus TWO additional columns for start and end position
open (AGE, $agefile) || die "\nUnable to open the file $agefile!\n";
while (<AGE>) {
  chomp $_;

  if ($_ =~ /^Chromosome/) {
    print OUT $_, "\t", "StartPos\t", "EndPos\n";
    next;
  } else {
    my @info = split(/\s{1,}/, $_);
    my $id = $info[0] . "." . $info[1];
    if (exists $positions{$id}) {
      print OUT $_, "\t", $positions{$id};
    } else {
      print "ERROR: Cannot find start position for TE $id!\n";
    }
    if (exists $end_positions{$id}) {
      print OUT "\t", $end_positions{$id}, "\n";
    } else {
      print "ERROR: Cannot find end position for TE $id!\n";
    }
  }
}
close(AGE);
close(OUT);
exit;


