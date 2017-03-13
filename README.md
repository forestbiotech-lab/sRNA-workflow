# miRPursuit

[![DOI](https://zenodo.org/badge/36737158.svg)](https://zenodo.org/badge/latestdoi/36737158)

**Check out our read the docs page for a more structured overview of this project:**
<ul><a href="http://goo.gl/HHijqe" target="_blank">Read the Docs - DOCUMENTATION</a> </ul>
  
**miRPursuit – a pipeline for automated analyses of small RNAs in non-model plants**
<ul>Inês Chaves <sup>a,b,*,φ</sup> , Bruno Costa <sup>a,b,φ</sup> , Andreia S. Rodrigues <sup>a,b</sup> , Andreas Bohn <sup>a,b</sup> , Célia
M. Miguel <sup>a,b,c</sup></ul>

<ul><sup>a</sup> iBET, Instituto de Biologia Experimental e Tecnológica, Apartado 12, 2781-901 Oeiras, Portugal</ul>
<ul><sup>b</sup> Instituto de Tecnologia Química e Biológica António Xavier, Universidade Nova de Lisboa, Av. República, 2780-157 Oeiras, Portugal</ul>
<ul><sup>c</sup> Biosystems & Integrative Sciences Institute, Faculdade de Ciências, Universidade de Lisboa (FCUL), Campo Grande, 1749-016, Lisboa, Portugal
<ul><sup>φ</sup><strong> These authors contributed equally to this work. </strong></ul>
</ul>

<img src="http://www.itqb.unl.pt/labs/forest-biotech/forest-biotechnology" height="200px"/>

## Table of Contents
- [Abstract](#abstract)
- [How to start](#how-to-start)
- [Analysing sRNA](#analysing-srna)
- [Programs](#programs)
- [References](#references)


## Abstract
MiRPursuit, a pipeline developed for running end-
to-end analyses of high-throughput small RNA (sRNA) sequence data in model and
non-model plants, from raw data to identified and annotated conserved and novel
sequences. It consists of a series of UNIX shell scripts, which connect the in- and
outputs of several established, open-source sRNA analysis software. This way, high
customizability and full transparency of the analyses and the involved parameters
can be combined with convenient workflow management, also for users without
advanced computational skills. One considerable advantage is that several sRNA
libraries can be processed in parallel.


Small non-coding RNAs (sRNAs) are pivotal in the regulation of gene expression during plant growth and development, and in response to abiotic and biotic stresses. The affordable, high-throughput sequencing provided by NGS platforms is an attractive approach to discover the small RNAs involved in the regulation of important biological processes in plants. However, the large amounts of data generated by such type of studies can be staggering and requires efficient tools to quickly analyze the data produced.

This pipeline has been built around a publicly available software package, the University of East Anglia sRNA workbench[1], which includes various tools which can be used to identify sRNA classes, such as micro RNAs (miRNAs) and trans-acting siRNA (tasi), both conserved and novel and predict their precursor RNA using a user specified reference genome. Moreover, the target genes can be predicted and validated by using degradome fragment sequences and a reference transcriptome.

By setting up a workflow, a predefined sequence of tools can be run autonomously. The NGS raw data obtained from various libraries can be supplied as input files, allowing the user to process multiple libraries in one command line interaction. The degree of customization in this pipeline provides the ability to fine tune the workflow with the freedom to use user supplied omics data.

Thus, the main advantage of using this system over the workbench's individual tools is minimizing the need to perform manual repetitive tasks. The pipeline automatically connects each step by processing the data flow between tools. This sRNA workflow was implemented in bash which is optimal to be run on unix servers allowing uninterrupted runs on high capacity clusters enabling the processing of large scale multiple datasets. The end result provides the identification and annotation of conserved and novel miRNAs and tasiRNAs, along with the expression matrix of the libraries from the input dataset, which can be easily imported to excel or R to perform differential expression analyses.

As future work the development of the pipeline will include, a database of the annotations generated and a user friendly graphic interface.



This pipeline was build to simplify the manipulation of NGS sequenced data. Use of this pipeline provides a seamless classification of sRNA, prediction of TaSi and sRNA targets from FASTQ files.

<!-- This version was based on the output given by fasteris (tar.gz files need to have *GZT-[lib_n]*.tar.gz format or be put in this format).
However if the .fastq files are in .gz archives they can also be used, given the pattern before the library number. -->


## How to start:
<ul> Make sure you have all the software necessary (Check list) 
  <ul> UEA Workbench Optimized for linux version (~3.2) </ul>
  <ul> perl version (5.8) </ul>
  <ul> Java optimized for version (~1.7) </ul>
</ul>
<ul> Set up the variables in the config dir.</ul>
<ul>You should also have the following software configured in your path
    <ul> [Patman](https://bioinf.eva.mpg.de/patman/) (Can be installed with install script)</ul>
    <ul> [Tar](http://linuxcommand.org/man_pages/tar1.html) sudo apt-get install tar</ul>
    <ul> [Fastx Toolkit](http://hannonlab.cshl.edu/fastx_toolkit/) (Can be install with install script)</ul>
</ul>
<ul>run miRPursuit.sh</ul>


<h3>Installation</h3>
<h5>From git hub</h5>

```shell
$ cd /toDesiredLocation/
$ git clone https://github.com/forestbiotech-lab/miRPursuit.git
$ cd miRPursuit
```

<h5>From tar</h5>

```shell
#Download archive from github
$ cd /toDesiredLocation/
$ unzip miRPursuit-master.zip
``` 

<h5>Dependencies</h5> 
<ul>To install the necessary dependencies you can run install.sh in the main folder</ul>

```shell
$ cd /pathtoMiRPursuit/
$ ./install.sh
```

<h5>Custom Installation</h5>
<ul>Set software dir in config file</ul>
<ul>Fill out the software variables in the software.cfg file. <br>Set the paths to any program listed if already installed.</ul>

```shell
$ cd /pathtoMiRPusuit/
$ vim config/software_dirs.cfg
```

<h5>Running test dataset</h5>
<ul>A test dataset was provided to ensure the pipeline is installed successfully
   <ul>edit config/workdirs.cfg </ul>
   <ul>Set INSERTS_DIRS=pathToMiRPursuit/testDataset (Example for test dataset)</ul>
   <ul>Use as reference genome a simple plant genome. (Dataset has sRNAS detected by C.canephora genome)</ul>
</ul>   

<ul>Example code to analyse test_dataset (Make sure all var above mentions are already set):</ul>

```shell
$ bash pathToMirPursuit/miRPursuit.sh -f 1 -l 2 --fasta test_dataset-
```

## Analysing sRNA

Works for fastq and fasta input formats. 
  
<strong>config</strong> - Directory that has all the variables for the workflow.

<ul><strong>workdirs.cfg</strong>- Sets variables with directories and files necessary for the project.
  <ul>workdir - path to workdir (will create one if it doesn't exist)</ul>
  <ul>genomes path to genomes</ul>
  <ul>GENOME_MIRCAT  _The path to the genome to be used by mircat. Set to ${GENOME} if you don't need to run various parts. (My be necessary if you have short amount of ram.)"</ul>
  <ul>FILTER_SUF _Filter-suffix to chose the predefined filter settings to be used.</ul>
  <ul>MEMORY  - Amount of memory to be used my java when using memory intensive scripts. Ex:10g, 2000m ... </ul>
  <ul>THREADS - Number of cores to be used during execution</ul>
  <ul>INSERTS_DIR Path to the inserts directory</ul> 
  <ul>MIRBASE Path to mirbase database</ul>
</ul>
<br>  
<ul><strong>software_dirs.cfg</strong> - Sets the directory paths to all major programs</ul>
<br>
<ul><strong>patman_genome.cfg</strong> - General genome filtering parameters </ul>
<br>
<ul><strong>wbench_mircat.cfg</strong> - General parameters for mircat</ul>
<br>
<ul><strong>wbench_tasi.cfg</strong> - General parameters for TaSi.</ul>

## Programs

<ul><strong>sRNAworkFlow.sh</strong>
<br>Description: This is the main script that runs the full pipeline.
Some commands are being changed to config files.
<ul>inputs:
  <ul>-f|--lib-first "First library to be processed"</ul>
  <ul>-l|--lib-last "last Library to be processed"</ul>
  <ul>-h|--help "Display help" </ul>
</ul>
<ul>Optional arguments:
  <ul>-s|--step Step is an optional argument used to jump steps and start analysis from a different point.
    <ul>Step 1: Wbench Filter</ul>
    <ul>Step 2: Filter Genome & miRBase</ul>
    <ul>Step 3: Tasi</ul>
    <ul>Step 4: Mircat</ul>
    <ul>Step 5: PareSnip</ul>
  </ul>
  <ul>--lc Set the program to begin in lcmode instead of fs mode. The preceding substring from the lib num (Pattern) Template + Lib num mas identify only one file in the inserts_dir</ul>
  <ul>--fasta Set the program to start using fasta files. As an argument supply the file name that identifies the series to be used. Ex: Lib_1.fa, Lib_2.fa, .. --> argument should be Lib_</ul>
  <ul>--fastq Set the program to start using fastq files. As an argument supply the file name that identifies the series to be used. Ex: Lib_1.fq, Lib_2.fq, .. --> argument should be Lib, will also extract the file if extension is fastq.gz </ul>
</ul>
<ul>Outputs:
  <ul>mirbase hits</ul>
  <ul>predicted targets</ul>
  <ul>predicted mRNA</ul>
  <ul>[workdir]/logs</ul>
  <ul>[workdir]/counts</ul>
</ul>
</ul>

<object data="https://raw.githubusercontent.com/forestbiotech-lab/miRPursuit/master/images/Figure1-miRPursuit.svg" type="image/svg+xml"/>
  <img src="https://raw.githubusercontent.com/forestbiotech-lab/miRPursuit/master/images/Figure1-miRPursuit.png" />
</object>

<ul><ul><strong>Figure 1</strong> - MiRPursuit pipeline diagram and miRPursuit file structure.</ul> 
<ul>In the file structure, each rectangle represents a folder, dotted lines indicate relative paths, while solid lines indicate direct relation (folder is child of arrow origin).</ul>
<ul>/miRPursuit is located in the path where it was installed. /[workdir_name] has the path that was set in workdir in workdir.cfg. /config has all the configuration files specified in supp file 1.
/count has all count files generated. /data stores all generated files along if any intermediary files generated by the processes in the pipeline. /log stores all the log file related to the pipeline execution.</ul>
</ul>
------
 
<ul><strong>predict_target.sh</strong>
<br>Description: This is last step of the pipeline responsible for identifying sRNA targets in the transcriptome through degradome mediated search.
<ul>inputs:
  <ul>-f|--lib-first "First library to be processed"</ul>
  <ul>-l|--lib-last "last Library to be processed"</ul>
</ul>
<ul>Optional arguments: (If no degradome file parameter is given the script will give a list of options based on the location of the last used degradome file
  <ul>-d|--degradome "Degradome location"</ul>
  <ul>-h|--help "Display help"</ul>
</ul>
<ul>Outputs:
  <ul>targets</ul>
</ul>
</ul>

------

For detailed file names check the corresponding pipeline. This program executes the following programs in that order.
Stats on the number of reads are stored in the count directory.
The count file is not really a tsv it is in fact a space separated values. But I though i was close enough to a tsv.
The format used for counts is  %y%m%d:%h%m&s-type-lib[lib_first]-[lib_last].tsv

The log directory has alot of information about what happened during the execution of the scripts. It has a similar file notations as the count
files. %y%m%d:%h%m%s-type.log or *.log.ok if it ran till the end. *.

------

## References:
<ul>1 - **Borges F & Martienssen RA** (2015) The expanding world of small RNAs in plants. Nat Rev Mol Cell Biol 16, 727–741.</ul>
<ul>2 - **Sunkar R** (2010) MicroRNAs with macro-effects on plant stress responses. Semin Cell Dev Biol 21, 805–811.</ul>
<ul>3 - **Liu J & Vance CP** (2010) Crucial roles of sucrose and miRNA399 in systemic signaling of P deficiency - A tale of two team players? Plant Signaling and</ul>
Behaviour 5, 1–5.
<ul>4 - **Bartel DP** (2004) MicroRNAs: genomics, biogenesis, mechanism, and function. Cell 116, 281–297.</ul>
<ul>5 - **Allen E, Xie Z, Gustafson AM & Carrington JC** (2005) microRNA-directed phasing during trans-acting siRNA biogenesis in plants. Cell 121, 207–221.</ul>
<ul>6 - **Conesa A, Madrigal P, Tarazona S, Gomez-Cabrero D, Cervera A, McPherson A, Szcześniak MW, Gaffney DJ, Elo LL, Zhang X & Mortazavi A** (2016) A survey of</ul>
best practices for RNA-seq data analysis. Genome Biol 17, 13.Page 11 of 399 FEBS Letters
<ul>7 - **Kozomara A & Griffiths-Jones S** (2011) miRBase: integrating microRNA annotation and deep-sequencing data. Nucleic Acids Res 39, D152–7.</ul>
<ul>8 - **Chaves I, Lin Y-C, Pinto-Ricardo C, Van de Peer Y & Miguel C** (2014) miRNA profiling in leaf and cork tissues of Quercus suber reveals novel miRNAs and</ul>
tissue-specific expression patterns. Tree Genet. Genomes 10, 721–737.
<ul>9 - **Stocks MB, Moxon S, Mapleson D, Woolfenden HC, Mohorianu I, Folkes L, Schwach F, Dalmay T & Moulton V** (2012) The UEA sRNA workbench: a suite of tools for</ul> analysing and visualizing next generation sequencing microRNA and small RNA datasets. Bioinformatics 28, 2059–2061.
<ul>10 - **BabrahamBioinformatics** (2016) A quality control tool for high throughput sequence data http://www.bioinformatics.babraham.ac.uk/projects/fastqc/.</ul>
<ul>11 - **HannonLab** (2010) FASTX-Toolkit http://hannonlab.cshl.edu/fastx_toolkit/index.html.</ul>
<ul>12 - **Nawrocki EP, Burge SW, Bateman A, Daub J, Eberhardt RY, Eddy SR, Floden EW, Gardner PP, Jones TA, Tate J & Finn RD** (2015) Rfam 12.0: updates to the RNA</ul> families database. Nucleic Acids Res 43, D130–7.
<ul>13 - **Prüfer K, Stenzel U, Dannemann M, Green RE, Lachmann M & Kelso J** (2008) PatMaN: rapid alignment of short sequences to large databases. Bioinformatics 24, 1530–1531.</ul>
<ul>14 - **Chen H-M, Li Y-H & Wu S-H** (2007) Bioinformatic prediction and experimental validation of a microRNA-directed tandem trans-acting siRNA cascade in Arabidopsis.</ul> Proc Natl Acad Sci U S A 104, 3318–3323.
<ul>15 - **Griffiths-Jones S** (2006) miRBase: the microRNA sequence database. Methods Mol Biol 342, 129–138.</ul>
<ul>16 - **Griffiths-Jones S**, Saini HK, van Dongen S & Enright AJ (2008) miRBase: tools for microRNA genomics. Nucleic Acids Res 36, D154–8.</ul>
<ul>17 - **Taylor RS, Tarver JE, Foroozani A & Donoghue PCJ** (2017) MicroRNA annotation of plant genomes - Do it right or not at all. Bioessays 39.</ul>
<ul>18 - **Meyers BC, Axtell MJ, Bartel B, Bartel DP, Baulcombe D, Bowman JL, Cao X, Carrington JC, Chen X, Green PJ, Griffiths-Jones S, Jacobsen SE, Mallory AC, Martienssen RA, Poethig RS, Qi Y, Vaucheret H, Voinnet O, Watanabe Y, Weigel D & Zhu J-K** (2008) Criteria for annotation of plant MicroRNAs. Plant Cell 20, 3186–3190.</ul>
<ul>19 **Goodstein DM, Shu S, Howson R, Neupane R, Hayes RD, Fazo J, Mitros T, Dirks W, Hellsten U, Putnam N & Rokhsar DS** (2012) Phytozome: a comparative platform for green plant genomics. Nucleic Acids Res 40, D1178–86.
<ul>20 **Kersey PJ, Allen JE, Armean I, Boddu S, Bolt BJ, Carvalho-Silva D, Christensen M, Davis P, Falin LJ, Grabmueller C, Humphrey J, Kerhornou A, Khobova J, Aranganathan NK, Langridge N, Lowy E, McDowall MD, Maheswari U, Nuhn M, Ong CK & Staines DM (2016)** Ensembl Genomes 2016: more genomes, more complexity. Nucleic Acids Res 44, D574–80.</ul>




<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-47286927-5', 'auto');
  ga('send', 'pageview');

</script>