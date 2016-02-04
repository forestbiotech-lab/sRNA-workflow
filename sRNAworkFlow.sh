#!/usr/bin/env bash

# sRNAworkFlow.sh
# 
#
# Created by Bruno Costa on 25/05/2015.
# Copyright 2015 ITQB / UNL. All rights reserved.
# Executes the complete pipline
# Call: sRNAworkFlow.sh [inserts_dir] [LIB_FIRST] [LIB_LAST] [STEP]

set -e

# OUTPUT-COLORING
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
blink='\e[5m'
unblink='\e[25m'
invert='\e[7m'
NC='\e[0m' # No Color

while [[ $# > 0 ]]
do
  key="$1"

case $key in
  -f|--lib-first)
  LIB_FIRST="$2"
  shift # past argument
  ;;
  -l|--lib-last)
  LIB_LAST="$2"
  shift # past argument
  ;;
  -s|--step)
  step="$2"
  shift # past argument
  ;;
  --fastq)
  fastq="$2"
  shift #past argument
  ;;
  --fasta)
  fasta="$2"
  shift #past argument
  ;;
  --lc)
  LC="$2"
  shift # past argument
  ;;
  -h|--help)
  echo -e " 
  ${blue}-f|--lib-first
  -l|--lib-last
  -h|--help${NC}
  ---------------------
  Optional args
  ---------------------
  ${blue}-s|--step${NC} Step is an optional argument used to jump steps to start the analysis from a different point  
      ${green}Step 1${NC}: Wbench Filter
      ${green}Step 2${NC}: Filter Genome & mirbase
      ${green}Step 3${NC}: Tasi
      ${green}Step 4${NC}: Mircat
      ${green}Step 5${NC}: PAREsnip    
 ${blue}--lc${NC} Set the program to begin in lcmode instead of fs mode. The preceading substring from the lib num (Pattern) Template + Lib num, but identify only one file in the inserts_dir    
 ${blue}--fasta${NC} Set the program to start using fasta files. As an argument supply the file name that identifies the series to be used. Ex: Lib_1.fa, Lib_2.fa, .. --> argument should be Lib_
 ${blue}--fastq${NC} Set the program to start using fastq files. As an argument supply the file name that identifies the series to be used. Ex: Lib_1.fq, Lib_2.fq, .. --> argument should be Lib_ , if no .fq file is present but instead a .fastq.gz file will additionally be extracted automatically.  
  "
  exit 0
esac
shift # past argument or value
done

if [[ -z $LIB_FIRST || -z $LIB_LAST ]]; then
  echo -e"${red}Invalid input${NC} - Missing mandatory parameters"
  echo -e "use ${blue}-h|--help${NC} for list of commands"
  exit 127
else
  if [[ $LIB_FIRST != '^[0-9]+$' ]]; then
    echo -e"${red}Invalid input${NC} - Missing mandatory parameters for -f|--first"
    echo -e "use ${blue}-h|--help${NC} for list of commands"
    exit 127
  fi
  if [[ $LIB_LAST != '^[0-9]+$' ]]; then  
    echo -e"${red}Invalid input${NC} - Missing mandatory parameters for -l|--last"
    echo -e "use ${blue}-h|--help${NC} for list of commands"
    exit 127
  fi  
fi
##Should check if libraries exit


if [[ ! -z "$step" ]]; then
  if [[ "$step" -gt 5 || "$step" -lt 1 ]]; then
     >&2 echo -e "${red}Terminating${NC} - That step doen't exist please specify a lower step"         
     exit 127
  fi
fi


#Gets the scipt directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#Get config settings
. $DIR/"config/workdirs.cfg"
SOFT_CFG=${DIR}"/config/software_dirs.cfg"
. $SOFT_CFG

#Check programs are set up and can run (Java and Wbench).
if [[ -z "$JAVA_DIR"  ]]; then
  echo -e "${red}Not set${NC}: Please set java var in config file or run install script"
  exit 127
else
  if [[ -x "$JAVA_DIR" && -e "${JAVA_DIR}" ]]; then
    echo -e "Java set up: ${green}OK${NC}"
  else
    echo -e "${red}Failed${NC}: Java can't be run or invalid path"
    exit 127
  fi        
fi
if [[ -z "$WBENCH_DIR" ]]; then
  echo -e "${red}Not set${NC}: Please set workbench var in config file or run install script"
  exit 127        
else        
  if [[ -x "$WBENCH_DIR" && -e "$WBENCH_DIR" ]]; then
    echo "Workbench set up ${green}OK${NC}"   
  else
    echo -e "${red}Failed${NC}: Workbench can't be run or invalid path"
    exit 127
  fi
fi

echo "Running pipeline with the following arguments:"
printf "FIRST Library\t\t\t= ${LIB_FIRST}\n"
printf "Last Library\t\t\t= ${LIB_LAST}\n"
printf "Number of threads\t\t\t= ${THREADS}\n"
#Test numer of cores is equal or lower the avalible

#Test Filter exists
echo "Filter suffix                 = ${FILTER_SUF}"
if [[ -e "${GENOME}" ]]; then        
  echo "Genome                      = "${GENOME}
else
  >&2 echo -e "${red}Error${NC} - The given genome file doesn't exist please check the file exists. Correct the config file"
  exit 127
fi
if [[ -e "${GENOME_MIRCAT}" ]]; then        
  echo "Genome mircat               = "${GENOME_MIRCAT}
else
  echo -e "${red}Error${NC} - The given genome file for mircat doesn't exit please check the file exists. Correct the config file."
fi
if [[ -e "${MIRBASE}" ]]; then        
  echo "miRBase                     = "${MIRBASE}
else
  echo -e "${red}Error${NC} - The given mirbase file doesn't exist please check the file exists. Correct the config file"
  exit 127
fi
if [[ -z "${workdir}" ]]; then
  echo -e "${red}Not set:${NC} No workdir hasn't been set please don't put a trailing /, see config workdirs.cfg"
  exit 127
else
  echo "Working directory (workdir) =  ${workdir}"      
fi        
if [[ -d "${INSERTS_DIR}" ]]; then
  echo "sRNA directory (INSERTS_DIR)=  ${INSERTS_DIR}"      
else        
  echo -e "${red}Invalid dir${NC}: The inserts directory hasn't been configured properally, see config workdirs.cfg"
  exit 127
fi        
#nonempty string bigger than 0 (Can't remember purpose of this!)
if [[ -n $1 ]]; then 
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi




mkdir -p $workdir"log/"
log_file=$workdir"log/"$(echo $(date +"%y%m%d:%H%M%S")":"$(echo $$)":run_full_pipline:"${LIB_FIRST}":"${LIB_LAST})".log"
exec >&1 > ${log_file}
echo ${log_file}

SCRIPTS_DIR=$DIR"/scripts"

#Test if the var step exists
if [[ -z "$step" ]]; then 
  step=0
fi

if [[ ! -z "$LC" ]]; then
  >&2 echo -e "${blue}Running in LC mode.${NC}"
  ${DIR}/extract_lcscience_inserts.sh $LIB_FIRST $LIB_LAST $LC
  step=1
fi
if [[ ! -z "$fastq" ]]; then
  >&2 echo -e "${blue}Running in fastq mode.${NC}"
  ${DIR}/pipe_fastq.sh $LIB_FIRST $LIB_LAST $fastq
  step=1
fi
if [[ ! -z "$fasta" ]]; then
  >&2 echo -e "${blue}Running in fasta mode.${NC}"
  ${DIR}/pipe_fasta.sh $LIB_FIRST $LIB_LAST $fasta
  step=1
fi

if [[ "$step" -eq 0 ]]; then        
  #Concatenate and convert to fasta
  >&2 echo -ne "${blue} Step 0${NC} - Concatenating libs and converting to fasta\t[                         ]  0%\r"
  ${DIR}/extract_fasteris_inserts.sh $LIB_FIRST $LIB_LAST
  step=1
fi 
if [[ "$step" -eq 1 ]]; then
  #Filter size, t/rRNA, abundance.
  >&2 echo -ne "${blue} Step 1${NC} - Filtering lib workbench Filter            \t[#####                    ] 20%\r"
  ${DIR}/pipe_filter_wbench.sh $LIB_FIRST $LIB_LAST $FILTER_SUF
  step=2
fi
if [[ "$step" -eq 2 ]]; then 
  #Filter genome and mirbase
  >&2 echo -ne "${blue}Step 2${NC} - Filtering against genome and mirbase       \t[##########               ] 40%\r"
  ${DIR}/pipe_filter_genome_mirbase.sh $LIB_FIRST $LIB_LAST
  step=3
fi
if [[ "$step" -eq 3 ]]; then 
  #tasi
  >&2 echo -ne "${blue} Step 3${NC} - Running tasi, searching for tasi reads    \t[###############          ] 60%\r"
  ${DIR}/pipe_tasi.sh $LIB_FIRST $LIB_LAST 
  step=4
fi
if [[ "$step" -eq 4 ]]; then 
  #mircat
  >&2 echo -ne "${blue} Step 4${NC} - Running mircat (Be patient slow step)     \t[####################     ] 80%\r"
  ${DIR}/pipe_mircat.sh $LIB_FIRST $LIB_LAST
  step=5
fi  
if [[ "$step" -eq 5 ]]; then
  >&2 echo -ne "${blue} Step 5${NC} - Counting sequences to produces matrix     \t[######################   ] 90%\r"
  ${DIR}/counts_merge.sh 
  >&2 echo -ne "${blue} Step 5${NC} - Running report                            \t[######################## ] 95%\r"
  $SCRIPTS_DIR/report.sh $LIB_FIRST $LIB_LAST ${DIR}
fi

  >&2 echo -ne "${blue} Step 5${NC} - Done, files are in workdir                \t[#########################]  100%\r"
  sleep 4
  >&2 echo "This workflow was created by Forest Biotech Lab - iBET, Portugal"
  sleep 2
  >&2 echo "Build around the UEA srna-workbench. http://srna-workbench.cmp.uea.ac.uk/the-uea-small-rna-workbench-version-3-2/" 
  sleep 2
  >&2 echo "Feedback: brunocosta@itqb.unl.pt"
  sleep 2
  >&2 echo ""
               
ok_log=${log_file/.log/:OK.log}

echo $ok_log
mv $log_file $ok_log
printf "Workdir is: "$workdir"\nInserts dir is: "$INSERTS_DIR"\nfastq_xtract.sh ran in s\nlib_cat.sh ran in ${SECONDS}s\n" > $ok_log
>&2 echo -e "${green}Finished${NC} - sRNA-workflow finished successfully."

RUN=$(( $RUN + 1 ))
sed -ri "s:(RUN=)(.*):\1${RUN}:" ${SOFT_CFG}
exit 0
