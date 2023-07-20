#/bin/bash
#$ -q UI-HM
#$ -N mWReads
#$ -cwd
#$ -pe smp 56
#$ -o l.$JOB_NAME.$JOB_ID.log
#$ -j y

#Grab raw sequences (unzip them and store in rawSequences)

# Create directory to store raw sequences (unzipped)
mkdir -p rawSequences

# Change to the directory containing the zip files
## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
cd /nfsscratch/YOURUSERNAME/data

#Find all .fq.gz files in the current directory 
find . -name "*.fq.gz" -type f | while read -r file; do
    # Extract the base filename without the extension
    base_filename=$(basename "$file" .fq.gz)
    
    # Extract the prefix and suffix parts of the filename
    prefix="${base_filename%_*}"
    suffix="${base_filename#*_}"
    
    # Create the output directory if it doesn't exist
    output_dir="/nfsscratch/YOURUSERNAME/rawSequences/$prefix"
    mkdir -p "$output_dir"
   
    # Determine the output filename based on the suffix
    output_file="$output_dir/$prefix"_"$suffix.fq"
    
    # Unzip the file and save the sequences to the output file
    gunzip -c "$file" > "$output_file"
done

#Clean the Sequences (store in /nfsscratch/..-mWPipeline/read_qc)
## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
samples_path="/nfsscratch/YOURUSERNAME/rawSequences"

project=$(basename "$samples_path")-mwPipeline
scratch=/nfsscratch/$project
qc=$scratch/read_qc

mkdir $scratch

samples=$(basename -s _1.fq -a "$samples_path"/*_1.fq)

## CHANGE TO YOUR OWN PATH TO MINICONDA ##
source /Users/YOURUSERNAME/miniconda3/bin/activate
conda activate metawrap-env

mkdir $qc
#Access the subdirectories within the parent directories
output_file="$output_dir/$prefix"_"$suffix.fq"
for dir in "$samples_path"/*/; do
    cd "$dir"
    prefix=$(basename "$dir")
    forward="${prefix}_1.fq"
    reverse="${prefix}_2.fq"
    
    # Reset the samples variable for the current directory
    samples=$(basename -s _1.fq -a "$forward")

    for s in $samples; do
        mkdir -p "$qc/$s"
        metawrap read_qc -1 "$forward" -2 "$reverse" -o "$qc/$s"
    done
    
    cd ..
done

#Loop Grab Host_Reads and Rename them
# Specify the directory
## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
base_dir="/nfsscratch/rawSequences-mwPipeline/read_qc"
dest_dir="/nfsscratch/YOURUSERNAME/hostSequences"

# Loop through the directories
for dir in "$base_dir"/*/; do
	# Extract the directory name
  	dirname=$(basename "$dir")

  	# Check if the directory name has any file extension
  	if [[ "$dirname" == *.* ]]; then
    		continue
  	fi

  	# Get the third and fourth elements in the directory
	elements=("$dir"/*)
	third_ele="${elements[2]}"
	forth_ele="${elements[3]}" 

	echo "Third element: $third_ele"
	echo "Fourth element: $forth_ele"
	
	# Check if the files are present in the directory
    	if [[ ! -f "$third_ele" || ! -f "$forth_ele" ]]; then
        	echo "host_reads files not found in $dirname. Moving to the next directory."
        	continue
    	fi

    	# Extract the suffix from the original filenames
    	suffix1="${third_ele##*_}"
    	suffix2="${forth_ele##*_}"

    	# Remove "host_reads" from the filenames
    	new_name1="${dirname}_${suffix1/host_reads/}"
    	new_name2="${dirname}_${suffix2/host_reads/}"

    	echo "New name one: $new_name1"
    	echo "New name two: $new_name2"

    	# Create the directory if it doesn't exist
    	mkdir -p "$dest_dir/$dirname"

    	# Move the renamed files into the directory
    	mv "$third_ele" "$dest_dir/$dirname/$new_name1"
    	mv "$forth_ele" "$dest_dir/$dirname/$new_name2"

	cd .. || exit
done
#Loop for HLAMiner
## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
base_Directory="/nfsscratch/YOURUSERNAME/hostSequences"
#Iterate over subdirectories
for subdir in "$base_Directory"/*/; do
	cd "$subdir" || continue

	fastq_files=(./*.fastq)

    	# Check if there are two fastq files (_1 & _2)
	# -lt: A comparison operator that checks if the left operand (amount of fastq_files) is less than the right operand(2)
    	if [[ ${#fastq_files[@]} -lt 2 ]]; then
        	echo "Cannot find fastq files"
        	cd ..
        	continue
    	fi
	#Get the fastq files
	elements=("$subdir"/*)
	file1="${elements[0]}"
	file2="${elements[1]}"

	echo "File one $file1"
	echo "File two $file2"
	#Replace the file paths in HLAMiner
 	## CHANGE TO YOUR OWN PATH TO MINICONDA ##
	source ~/miniconda3/bin/activate
	conda activate HLAMiner01
	cd /Users/YOURUSERNAME/HLAminer-1.4/HLAminer_v1.4/bin

	command1="~/miniconda3/envs/HLAMiner01/bin/bwa aln -e 0 -o 0 ../database/HLA-I_II_GEN.fasta $(realpath "$file1") > aln_test.1.sai"
    	command2="~/miniconda3/envs/HLAMiner01/bin/bwa aln -e 0 -o 0 ../database/HLA-I_II_GEN.fasta $(realpath "$file2") > aln_test.2.sai"
    	command3="~/miniconda3/envs/HLAMiner01/bin/bwa sampe -o 1000 ../database/HLA-I_II_GEN.fasta aln_test.1.sai aln_test.2.sai $(realpath "$file1") $(realpath "$file2") > aln.sam"

	echo "Pathway to file1 $(realpath "$file1")"
	echo "Pathway to file2 $(realpath "$file2")"
	echo "Running bwa"
	eval "$command1"
	eval "$command2"
	eval "$command3" 

	#Renaming .csv and .log files and put them into their desired dir
        subdir_name=$(basename "$subdir")

	#Predict HLA
	echo "Predicting HLA..."
	../bin/HLAminer.pl -a aln.sam -h ../database/HLA-I_II_GEN.fasta -s 500 -l "$subdir_name" "$subdir_name"

	# Create the directory for CSV files
 	## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
	csv_directory="/nfsscratch/YOURUSERNAME/HLACSV_File"

	# Create the directory for log files
 	## CHANGE DIRECTORY BASED ON YOU FILE LOCATION ##
	log_directory="/nfsscratch/YOURUSERNAME/HLALOG_File"

	#Make directory for both csv and log
	mkdir -p "$csv_directory"
	mkdir -p "$log_directory"

	# Move the CSV file
	mv "HLAminer_HPRA_$subdir_name.csv" "${csv_directory}/${subdir_name}.csv"

	# Move the log file to HLALog_Files directory
	mv "HLAminer_HPRA_$subdir_name.log" "${log_directory}/${subdir_name}.log"

	#Move back one directory
	cd ..
done 
