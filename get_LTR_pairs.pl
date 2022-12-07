#!/usr/bin/perl -w
#
# get_LTR_pairs.pl
#
# From a fasta file with all left and right LTR sequences,
# print one fasta file for each possible LTR pair to be run in an alignment
# June 20, 2022

use strict;
use Data::Dumper;

# Take from the command line the name of the fasta file you want to process
# and the name of an output folder to print all of the new fasta files into
my ($USAGE) = "$0 <input.fasta> <output.dir>\n";
unless ((@ARGV) && ((scalar @ARGV) == 2)) {
  print $USAGE;
  exit;
}
my ($infile, $outdir) = @ARGV;

# Create 2 hashes, each keyed by LTR ID number
# One hash will be for all left sequences, the other for all right sequences
my %left = ();
my %right = ();

# Open the input fasta file and begin reading through one line at a time
# Outside of the file loop, save a flag for left or right and for the LTR id number
my $side = '';
my $id = 0;

open (IN, $infile) || die "\nUnable to open the file $infile!\n";

while (<IN>) {
  chomp $_;

  ## If the line is a header (i.e. starts with '>') then reset the flags
  if ($_ =~ /^>/) {
    my @info = split(/\s{1,}/, $_);
    $side = $info[1];
    #$id = (split(/\-/, $info[2]))[0];
    my $num = (split(/\-/, $info[2]))[0];
    my $chr = (split(/_/, $info[0]))[0];
    $chr =~ s/^>Chr//g;
    $id = $chr . $num;
    next;
  }

  ## If the line corresponds to a sequence, use the side flag to figure out which hash to store it in
  else {
    if ($side =~ /LEFT/) {

      ## Use the saved ID to figure out what key to save the sequence under
      if (exists $left{$id}) {
	push (@{$left{$id}}, $_);
      } else {
	@{$left{id}} = ();
	push (@{$left{$id}}, $_);
      }
    } else {

      if (exists $right{$id}) {
	push (@{$right{$id}}, $_);
      } else {
	@{$right{$id}} = ();
	push (@{$right{$id}}, $_);
      }
    }
  }
}
close(IN);

#print Dumper (\%left);

# Now that all of the sequences are saved, cycle through each hash key,
# then use a nested loop to print every possible pair of left and right sequences
my @ltrs = keys %left;

foreach my $ltr (@ltrs) {
  my @left_seqs = @{$left{$ltr}};
  my @right_seqs = ();
  if (exists $right{$ltr}) {
    @right_seqs = @{$right{$ltr}};
  } else {
    next;
  }

  for (my $i = 0; $i < scalar @left_seqs; $i++) {
    my $left = $left_seqs[$i];

    for (my $j = 0; $j < scalar @right_seqs; $j++) {
      my $right = $right_seqs[$j];

      my $outfile = $ltr . "_" . $i . "_" . $j . ".fa";
      open (OUT, ">$outdir/$outfile") || die "\Unable to open the file $outdir/$outfile!\n";
      print OUT ">LEFT", "\n", $left, "\n", ">RIGHT", "\n", $right, "\n";
      close(OUT);
    }
  }
}

exit;

