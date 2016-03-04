![ngstools](pictures/Irys_icon.png) - BioNano-Tools
bionano-tools
==========

*All tools presented below have only been tested by me and may contain bugs, please let me know if you find some. Each tool relies on dependencies normally listed at the top of the code (cpan for perl and cran for R will help you add them)*

## QC-tools

Tools to process and QC BioNanoGenomics data.

*Please do dry run to discover the available options in each command*

### **bnxstats.pl**

The perl script **[bnxstats_v1.pl](qc-tools/bnxstats_v1.pl)** computes basic stats from a BNX file with size filtering just like what IrysView does under windows (but without the W). This original script was renamed 'bnxstats_v1' and left for reference. A new version of the script **[bnxstats.pl](qc-tools/bnxstats.pl)** allows filtering by size but also by avgIntensity and SNR and returns counts for each filtering subset, it also supports gzipped BNX files which is a nice thing given the huge size these text files tend to develop.
```bash
## Usage: bnxstats.pl <-i bnx-file>
# Additional optional parameters are:
# <-l minsize in kb (100)>
# <-x maxsize in kb (5000)>
# <-s minimal SNR (3.50)>
# <-p percentile (99)>
# <-m max-AvgIntensity (or percentile if undef)>
# <-h to display this help>
```

### **bnxfilter.pl**

The perl script **[bnxfilter.pl](qc-tools/bnxfilter.pl)** filters BNX data based on min- and max-length, max-averageIntensity, min-SNR to generate nicer data for assembly. The avgIntensitty value can be read from a run with **bnxstats.pl**, a default absolute value of '0.6' will otherwise be applied. The most recent version of the code supports gzipped data and exports as gzip as option.
```bash
## Usage: bnxfilter.pl <-i bnx-file>
# Additional optional parameters are:
# <-l min-length in kb (100)>
# <-x max-length in kb (5000)>
# <-m max-AvgIntensity (0.6)>
# <-s min-SNR (3.5)>
# <-n min-nicks (6)>
# <-z zip results (default OFF)>
```

### **bnxfilter_repeats.pl**

The bash script **[bnxfilter_repeats.sh](qc-tools/bnxfilter_repeats.sh)** filters BNX data to 'remove', 'restrict to' or 'mask' simple repeats. It reflects the Windows version found in Irysview (that generates data with a wrongly formatted header) and works only on your linux server as it makes direct use of RefAligner. The code is simplistic and you could as well type the command in your terminal.

```bash
# Usage: bnxfilter-repeats.sh
#		-i <input (bnx file)>
#		[opt -t <stretch tolerance|0.1>]
#		[opt -m <min Repeat Units|5>]
#		[opt -c <choice (1/2/3)|1>]
#		[opt -l <keep log>
```

### **bnxreheader.pl**

The perl script **[bnxreheader.pl](qc-tools/bnxreheader.pl)** replaces unsupported characters in the header of a BNX file by '_' to avoid issue in IrysView (eg MQR returning empty sample name when other chatacters are present). This script should become obsolete when BNG correct their code or validate user input.
```bash
## Usage: bnxfilter.pl <-i bnx-file>
# Additional optional parameters are:
# <-z zip results (default OFF)>
# <-h to display this help>
```

### **run_MQR.sh**

The bash script **[run_MQR.sh](qc-tools/run_MQR.sh)**

Perform molecule quality report (MQR) at CLI instead of running this under IrysView. One may prefer to perform the MQR directly on his/her Nix server. The main advantage is that one can launch this code in a bash loop and perform all MQR from a list of BNX files (single runs) without supervision.

The following loop will process all BNX files in the current folder and create a MQR (in its own folder) from each BNX and a common reference (more parameters are available)
```bash
for b in *.bnx; do
  run_MQR.sh -i $b -r myreference.cmap;
done
```

Type the script name followed by -h will list all available parameters

**run_MQR.sh -h**
```bash
# Usage: runMQR.sh -i <molecules.bnx> -r <reference.cmap>
#		[optional: -l <minlen|150>]
#		[optional: -x <maxlen|3000>]
#		[optional: -a <maxai|0.6>]
#		[optional: -s <minSNR|3.5>]
#		[optional: -p <pval|1e-9>]
#		[optional: -t <max-threads|32> -m <max-ram|64>]
#		[optional: -n <sample N molecules>]
```
## general-tools

### **bnxclnheader.pl**

The perl script **[bnxclnheader.pl](general-tools/bnxclnheader.pl)** will clean/shorten file path in the '# Run Data' lines of a BNX header.

**bnxclnheader.pl -h**
```bash
## Usage: bnxclnheader.pl <-i bnx-file>
# Additional optional parameters are:
# <-z zip results (default OFF)>
# <-h to display this help>
```

### **bnxreheader.pl**

The perl script **[bnxreheader.pl](general-tools/bnxreheader.pl)** will swap the BNX header of a badly formatted BNX file with a correct header from a related BNX file. This script was made to correct multiple syntax issues in headers originated from IrysView 2.4 filtering or masking of repeats.

**bnxclnheader.pl -h**
```bash
## Usage: bnxreheader.pl <-i bnx-file> <-t template-file>
# Additional optional parameters are:
# <-z zip results (default OFF)>
# <-h to display this help>
```

### **bedRename.pl**

The perl script **[bedRename.pl](general-tools/bedRename.pl)** will create a new BED file from a public file and replace the original chromosome names with the BNG translation provided with a key file (first column='official-name', second column='BNG-key' from Knicker). The resulting file can be viewed in IGV together with BNG data.

**bedRename.pl -h**
```bash
## Usage: 
bedRename.pl <-i bed file (required)> <-k key file (required)>
# <-h to display this help>
```

### **cmap2bed.pl**

The perl script **[cmap2bed.pl](general-tools/cmap2bed.pl)** will create a BED file from a data.cmap file. The resulting file can be used with **[BEDTools](http://bedtools.readthedocs.org/en/latest/)** to go further.

**cmap2bed.pl -h**
```bash
Aim: Convert cmap data to BED5. You must provide a cmap file with -i
# Usage: cmap2bed.pl <-i cmap-file> 
# Optional parameters:
# -s <field number for BED-score (0-based; default to coverage=7)>
# (v1.2) 1:ContigLength 2:NumSites 3:SiteID 4:LabelChannel 
#        5:Position
#	 6:StdDev 7:Coverage 8:Occurrence 
#        9:GmeanSNR 10:lnSNRsd
# <-h to display this help>
```

### **xmap2bed.pl**

The perl script **[xmap2bed.pl](general-tools/xmap2bed.pl)** will create a BED file from a 'xmap' file. The resulting file can be used with **[BEDTools](http://bedtools.readthedocs.org/en/latest/)** to go further.

**xmap2bed.pl -h**
```bash
Aim: Convert xmap data to BED5. You must provide a xmap file with -i
# Usage: xmap2bed.pl <-i xmap-file> 
# Optional parameters (v0.2) :
# -x <minimal value for score (default=0)>
# -c <coordinate system used <'q'=query/'r'=ref> (default='r')
# -n <field number for BED-name (1-based; default to XmapEntryID=1)>
#        1:XmapEntryID 2:QryContigID 3:RefContigID 4:QryStartPos 5:QryEndPos
#        6:RefStartPos 7:RefEndPos 8:Orientation 9:Confidence
#       10: HitEnum 11:QryLen 12:RefLen 13:LabelChannel 14:Alignment
# -s <field number for BED-score (1-based; default to confidence=9)>
#        1:XmapEntryID 2:QryContigID 3:RefContigID 4:QryStartPos 5:QryEndPos
#        6:RefStartPos 7:RefEndPos 8:Orientation 9:Confidence
#       10: HitEnum 11:QryLen 12:RefLen 13:LabelChannel 14:Alignment
# <-h to display this help>
```

### **bnxsplitter.pl**

The perl script **[bnxsplitter.pl](general-tools/bnxsplitter.pl)** will split data from a BNX file (or archive thereof) into five separate 'invisible' TSV files available for down-processing using **R** (or your favorite script).

* .header.tsv
* .zero.tsv
* .one.tsv
* .qx11.tsv
* .qx12.tsv

The files are created next to the input file and are made invisible with a starting '.'. This can easily be changed in the code.

Type the script name followed by -h will list all available parameters

**bnxsplitter.pl -h**
```bash
You must provide a BNX file with -i
## Usage: bnxsplitter.pl <-i bnx-file>
# <-h to display this help>
```

### **labeldensity.pl**

The perl tool **[labeldensity.pl](general-tools/labeldensity.pl)** Search for nicking enzyme sites in multifasta (reqired: restrict2bed.pl), create genome intervals from multifasta (reqired: fasta2chromsizes.pl), create windows (reqired: bedtools makewindows), compare both bed files and compute for each bin (reqired: bedtools map), sort BED files naturally requires a recent version of GNU sort, report results in BED format visualisation.

```bash
## Usage: labeldensity.pl <-i fasta-file> <-n 'nicker(s)'>
# multiple allowed separated by ',')>
#  'Nt-BspQI' => 'GCTCTTC',
#  'Nt-BbvCI' => 'CCTCAGC',
#  'Nb-BsMI'  => 'GAATGC',
#  'Nb-BsrDI' => 'GCAATG'
# Additional optional parameters are:
# <-t title ('label-density')>
# <-l minimal length for dna sequence (20000)>
# <-b bin width for computing label density (100000)>
# <-h to display this help>bel density (100000)>
# <-h to display this help>
```

### **findNregions.pl**

The perl tool **[findNregions.pl](general-tools/findNregions.pl)** find regions of N's from a reference multi-fasta file and the corresponding knicker key table. It stores the coordinate of all hits to BED for loading in IrysView as track with sequence titles renamed using the key file. Such track may prove useful to identify issues associated with sequence gaps of incorrect size introduced in assemblies.

```bash
## Usage: findNregions.pl <-i fasta-file> <-k key-file to rename contigs>
# Additional optional parameters are:
# <-l minsize in bps (100)>
# <-h to display this help>
```

### **cmap2renum.pl**

The perl tool **[cmap2renum.pl](general-tools/cmap2renum.pl)** takes one reference cmap and its matching key-file generated by 'Knicker' and renumbers all cmaps starting from 1 in both files. A new pair of files is saved to disk with added prefix. Such operation is required when the original cmap contained high values for the cmap IDs (over 100,000) which is not supported by downstream steps like hybrid scaffolding). large ID numbers may come from very large contig lists where a number of sequences have been filtered out due to Knicker cutoffs, leaving holes in the ID range and breaching the limit of 100,000.

```bash
# Usage: cmap2renum.pl <-c cmap-file> <-k key-file>
# Optional parameters:
# -p <prefix ('new_')>
# -h <this help message>
```

In order to clean your assembly file, you may consider applying the next two perl scripts before using 'Knicker'.

### **fastaFiltLength.pl**

The BIO-perl script [fastaFiltLength.pl](fasta-tools/fastaFiltLength.pl) will filter a multifasta file and keep only sequence with length > min and <max values. Was created to filter genome assemblies containing multiple small files.
```bash
## Usage: fastaFiltLength.pl <-i fasta_file (required)>
# Additional optional parameters are:
# <-o outfile_name (filtered_)>
# <-m minsize (undef)>
# <-x maxsize (undef)>
# <-h to display this help>
```

### **fastaSortLength.pl**

The BIO-perl script [fastaSortLength.pl](fasta-tools/fastaSortLength.pl) will sorts a multifasta file by decreasing or increasing order. Was created to clean input fasta files before applying Knicker (BionanoGenomics).
```bash
## Usage: fastaSortlength.pl <-i fasta-file> <-o size-order ('i'=increasing | 'd'=decreasing)>
# <-h to display this help>
```

### **fastaRename.pl**

The BIO-perl script [fastaRename.pl](fasta-tools/fastaRename.pl) will rename headers of a multifasta file using the index file generated by Knicker (BionanoGenomics). The resulting file can be used with data exported from BNG in IGV.
```bash
## Usage: 
fastaRename.pl <-i fasta_file (required)> <-k key file (required)>
# <-h to display this help>
```
<h4>Please send comments and feedback to <a href="mailto:nucleomics.bioinformatics@vib.be">nucleomics.bioinformatics@vib.be</a></h4>

------------

![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png?raw=true)

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).
