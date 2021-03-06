#!/usr/bin/perl

# Rename multifasta file using BioNano key file
#
# Stephane Plaisance (VIB-NC+BITS) 2015/12/04; v1.0
# supports compressed files (zip, gzip, bgzip)
# the key file can be produced using the faSize tool (Jim Kent)
## create key file from fasta file
## asm=<assembly file>
## c=0; 
## while read id l; do c=$((c+1)); 
## echo -e "$c\t$id\t$l"; 
## done < <(faSize -detailed ${asm}) > ${asm}.keys.txt
#
# visit our Git: https://github.com/Nucleomics-VIB

use warnings;
use strict;
use Bio::SeqIO;
use Getopt::Std;

my $usage="## Usage: fastaRename.pl <-i fasta_file (required)> <-k key file (required)>
# <-r reverse convertion (optional, default to forward)>
# <-h to display this help>";

####################
# declare variables
####################
getopts('i:o:k:rh');
our ($opt_i, $opt_o, $opt_k, $opt_r, $opt_h);

my $infile = $opt_i || die $usage."\n";
my $outfile = $opt_o || "renamed_".$infile;
my $keyfile = $opt_k || die $usage."\n";
my $reverse = defined($opt_r) || undef;
defined($opt_h) && die $usage."\n";

# load keys from keyfile
my @header = "";
my @keys = ();
my %translate = ();

print STDOUT "\n# loading key pairs\n";
open KEYS, $keyfile or die $!;
while (my $line = <KEYS>) {
	$line =~ s/\s+$//;
	next if ($line =~ /^#|^$|^CompntId/);

	# fill a hash with replacement numbers
	my @keys = split /\t/, $line;
	if ( defined($reverse) ) {
		# forward renaming: CompntId to CompntName
		$translate{$keys[0]} = $keys[1];
		print STDOUT "\"".$keys[0]."\" => \"".$translate{$keys[0]}."\"\n";
	} else {
		# reverse renaming: CompntName to CompntId
		$translate{$keys[1]} = $keys[0];
		print STDOUT "\"".$keys[1]."\" => \"".$translate{$keys[1]}."\"\n";
	}
}
close KEYS;
print STDOUT "\n";

# process multifasta
my $seq_in = OpenArchiveFile($infile);
my $seq_out = Bio::SeqIO -> new( -format => 'Fasta', -file => ">$outfile" );
# my $seq_out = Bio::SeqIO -> new( -format => 'Fasta', -file => " | gzip -c >$outfile" );

while ( my $seq = $seq_in->next_seq() ) {
	my $curname = $seq->display_id()." ".$seq->desc;
	# trim spaces around
	$curname =~ s/^\s+|\s+$//g;
	my $newname = $translate{$curname};
	print STDOUT "# renaming: \"".$curname."\" to ".$newname."\n";
	$seq->display_id($newname);
	$seq->accession_number("");
	$seq->desc("");
	$seq_out->write_seq($seq); 
	}

undef $seq_in;

exit 0;

#### Subs ####
sub OpenArchiveFile {
    my $infile = shift;
    my $FH;
    if ($infile =~ /.fa$|.fasta$|.fna$/i) {
    $FH = Bio::SeqIO -> new(-file => "$infile", -format => 'Fasta');
    }
    elsif ($infile =~ /.fa.bz2$|.fasta.bz2$|.fna.bz2$/i) {
    $FH = Bio::SeqIO -> new(-file => "bgzip -c $infile | ", -format => 'Fasta');
    }
    elsif ($infile =~ /.fa.gz$|.fasta.gz|.fna.gz/i) {
    $FH = Bio::SeqIO -> new(-file => "gzip -cd $infile | ", -format => 'Fasta');
    }
    elsif ($infile =~ /.fa.zip$|.fasta.zip$|.fna.zip$/i) {
    $FH = Bio::SeqIO -> new(-file => "unzip -p $infile | ", -format => 'Fasta');
    } else {
	die ("$!: do not recognise file type $infile");
	# if this happens add, the file type with correct opening proc
    }
    return $FH;
}
