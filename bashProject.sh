`#!/bin/bash`
function main (){
echo ""
read -p $' Welcome to Linux !
	  
	Thank you for choosing our service. please select the number of option from the menu to proceed:
	
	1- File management.
	2- System monitoring.
	3- System metrices Report.
	4- Exit.

	Your satisfaction is our priority Enjoy your experience !
       
	' choice
	check
}	
function getType (){
while true ; do
	read -p $' Choose the type 
       		
		f- File.
		d- Directory. ' Type
	Type=${Type,,}
	if [[ $Type =~ ^[fd]+$ ]]; then
		return 0
	else 
		echo "Choose a correct type ( f for file OR d for directory)"

	fi
done
}
function confirmation(){
	read -p $'Are you sure you want to do this operation
		    1- Yes
		    2- NO ' ans
	if [[ $ans -eq 1 ]]; then
		return 0
	elif [[ $ans -eq 2 ]]; then
		operation
	else
		echo "Please enter a valid choice "
		confirmation
	fi
}
function checkPath(){
	if [[ ! -e "$path" ]]; then
		read -p 'please enter a correct path' path
		checkpath
	else 

		return 0
	fi

}
function checkExistance(){
	read -p $'Enter the name of file/directory you want to do the operation on 
		( file extention is required if the type is file )' name
	if [[ ! -e "$name"  ]]; then
	       echo "File/Directory does not exist. please try again"
	       checkExistance
	else
 		return 0		
	fi
}

function checkProcess(){
	if [[ $? -eq 0 ]]; then
		echo "Operation done successfully !"
		return 0
	else
		echo "operation faild "
		return 0
	fi
}
function checkNum (){
	funOp="$1"
	num1="$2"
	num2="$3"
	
	if [[ $funOp =~ ^[$num1-$num2]+$ ]]; then
		return 0
	else 
		read -p $'Please enter a valid option between ${num1} to ${num2}' funOp
		return 0
	fi
}

function disk_usage(){
	echo "Disk space statistics :
-------------------------------------"
        df -h | awk '{print""}{printf "%-20s %-10s %-10s %-10s\n", $1,$2,$3,$4}'
       system_monitoring       
}

function memory_usage (){
	total_mem=$(free -m | awk '/^Mem:/{print $2}')
	used_mem=$(free -m | awk '/^Mem:/{print $3}')
	free_mem=$(free -m | awk '/^Mem:/{print $4}')
	echo -e "Memory usage statistics :\n
-------------------------------------\n"
	echo "Total memory : ${total_mem} MB"
	echo "Used memory  : ${used_mem} MB"
	echo "Free memoey  : ${free_mem} MB"
	echo ""
	system_monitoring
}

function cpu_usage (){
	echo -e "System current CPU usage percentage :\n 
-------------------------------------------------------- \n"
cpu_use=$(top -bn1 | sed -n '3s/id/%/p' | awk -F "," '{print $4}')
	echo "CPU : ${cpu_use}"
	system_monitoring
}

function info_display(){
	echo -e "\nSystem informaion display for basic system information\n
------------------------------------------------------------\n"
	ops=$(uname -o)
	host_name=$(hostname)
	UpTime=$(uptime -p)
	current_Time=$(date)
	echo -e "Operating system : ${ops}"
	echo -e "\nHostname : ${host_name}" 
	echo -e "\nUptime : ${UpTime}"
	echo -e "\nCurrent date : ${current_Time}"
	system_monitoring
}

function system_monitoring(){
	echo ""
	read -p $'Welcome to System Monitoring section . Enter your choice
		 1- System information display.
		 2- CPU usage monitoring.
		 3- Memory usage monitoring.
		 4- Disk space monitoring.
		 5- main menu ' sysOp
	checkNum "$sysOp" "1" "5"
	sysOp="$funOp"
	case $sysOp in 
		1)
			info_display
			;;
		2)
			cpu_usage
			;;
		3)
			memory_usage
			;;
		4)
			disk_usage
			;;
		5)
			main
	esac
}

function backup (){
	checkExistance
	read -p $'Enter the name of the backup with .tar extension ' Bname
	if [[ "$Bname" == *.tar ]]; then
		tar -czvf "$Bname" "$name"
		checkProcess
		backup_restore
	else 
		"The file name must end with .tar extention "
		backup
	fi
}

function restore(){
	read -p $'Enter the backup name to restore with .tar extension' Rname
	if [[ ! "$Rname" == *.tar ]]; then
		echo "No such backup found "
		restore
	else	
		read -p $'Enter the destination to restore the files in' path
		checkPath
		tar -xzvf "$Rname" -C "$path"
		checkProcess
		backup_restore
	fi
}

function backup_restore(){
	echo ""
	read -p $'Welcome to backup and restoring section !.Enter your choice 
		1- Backup
		2- Restore
	        3- Return to the main menu ' BRop
	checkNum "$BRop" "1" "3"
	BRop="$funOp"
	case $BRop in 
		1)	backup
			;;
		2)
			restore
			;;
		3)
			main
	esac
}
function searchCheck(){
	if [[ -z "$result" ]]; then
		echo "no files found. Make sure you follow search requirments"
		search
	else
		echo "$result"
		search
	fi
}
function search (){
	echo ""
	read -p $'Welcome to search section !. 
       
		How would you like to do your search ?

		
		1- Search by file name
		2- Search by file size
		3- Search by file type
		4- Search by file extension
		5- Search by modification time	
		6- Return to the main menu 
		' searchOp

	checkNum "$searchOp" "1" "6"
	searchOp="$funOp"
	if [[ $searchOp -eq 6 ]];then
		main
	fi
	read -p $'Enter the search path ' path
	checkPath
	echo ""
	case $searchOp in 
		
		1)
			read -p $'Enter file name' fileName
			result=$(find "$path" -name "$fileName" 2>/dev/null)
			;;
		2)
			read -p $'Enter file size criteria ( +100M for files larger than 100MB , -50k for files smaller than 50KB ,
		                                        	60G for files exactly with size 60GB )
			         [+/- / ] [k/M/G] size options are required' fileSize
			result=$(find "$path" -size "$fileSize" 2>/dev/null)
			;;
		3)	
			getType
			result=$(find "$path" -type "$Type" 2>/dev/null)
			;;
		4)
			read -p $'Enter file extension (e.g , *.txt , *.sh ...)' fileExt
			result=$(find "$path" -name "$fileExt" 2>/dev/null)
			;;
		5)
			read -p $'Enter modification time (-7 for files modified withen last 7 days ago
		       					  +5 for filed modified more than 5 days ago
							  9 for files modified exactly 9 days ago  )
				[+/-/ ] [number] modification options are required ) ' fileMod
		        result=$(find "$path" -mtime "$fileMod" 2>/dev/null)
			
	esac	
	searchCheck
}

function permission (){
	echo ""
	read -p $'Welcome to permissions management section ! .
       		please choose an option to continue.
			1- Change file/directory permissions
			2- change file/directory ownership
			3- Return to the main menu' chOption
			checkNum "$chOption" "1" "3"
			chOption="$funOp"
			case $chOption in 
				1)
					chMod
					;;
				2)
					chOwn
					;;
				3)
					main
			esac
}
function chMod(){
		echo ""
		read -p $'Choose a permisson mode 
				1- Symbolic mode (e.g, rwx )
				2- Numeric octal notation (e.g, 755 )
				3- Back to permission managment menu	
				' pMod
		checkNum "$pMod" "1" "2"
		pMod="$funOp"
		checkExistance
		case $pMod in 	
			1)
				read -p $'Enter the new permessions in Symbols for user , group and others
				(e.g, r= read w = write x= execute ==> u=rwx,g=wx,o=rw )' perOp
				if [[ $perOp =~ ^([ugo]*[+-=]([rwx]*,?)*,?)*$ ]]; then
					sudo chmod "$perOp" "$name"
					checkProcess
				else 
					echo "invalid permission . please try again"
					chMod
				fi
					;;

			2)
				read -p $'Enter the new permissions in octal notaion 
				 read = 4 , write = 2 , execute = 1 (e.g, 755 ==>rwxr-xr-x)' perOp
				if [[ $perOp =~ ^[0-9]+$ ]];then
					 sudo chmod "$perOp" "$name"
					 checkProcess
				else
					echo "invalid permission . please try again"
					chMod
				fi
				;;

			3)
				permission

		 esac
}
function checkUser(){
	read -p $'Enter the name of the new owner ' owner
	if id "$owner" &>/dev/null ; then
		return 0
	else
		echo "User not found"
		chOwn
	fi
}
function checkGroup(){
	read -p $'Enter the name of the new group ' group
	if getent group "$group" &>/dev/null ; then
		return 0
	else 
		echo "Group not found"
		chOwn
	fi
}
function chOwn() {
		echo ""
 		 read -p $'Choose an ownership’s change option 
			1- Change User ownership only.
			2- Change Group ownership only.
			3- Change user and group ownership.
		        4- Return to permissions management
			' ownOp
		checkNum "$ownOp" "1" "4" 
		ownOp="$funOp"
		checkExistance
		case $ownOp in
			1)
				
				if  checkUser ; then
					sudo chown "$owner" "$name"
				fi
					;;
			2)
			
				if checkGroup ; then
					sudo chown "$group" "$name"
				fi
					;;
			3)		
				if checkUser && checkGroup ; then
					sudo chown "$owner":"$group" "$name"
				fi
					;;
			4) 
				permission
		esac

}

function delete (){
	checkExistance
	confirmation
	rm -r "$name"
	checkProcess
	operation
}

function rename (){
	checkExistance
	read -p $'Enter the new name' newName
	confirmation
	mv "$name" "$newName"
	checkProcess
	operation
}

function move (){
	checkExistance
	read -p $'Enter the destination ' path
	checkPath
	mv "$name" "$path"
        checkProcess
	operation	
}

function copy () {
	getType
	checkExistance 
	read -p $'Enter the name of copied file/directory  ' cpdName
	if [[ $Type -eq "f" ]]; then
		cp "$name" "$cpdName"
	else
		cp -r "$name" "$cpdName"
	fi
	checkProcess
	operation
}
function create (){

	getType
	read -p $'Enter the name ( file extension is required in case of creating files ) ' name
	read -p $'Enter the target location' path
	checkPath
	if [[ $Type -eq "f" ]]; then
		touch "$path/$name"
	else 
		mkdir "$path/$name"
	fi
	checkProcess
	operation
}

function operation (){
	echo ""	
	read -p $'which operation do you want ?
		
		1- create file/directory
		2- copy file/directory
		3- Move file/directory
		4- Rename file/directory
		5- Delete file/directory
		6- Return to the main menu' opChoice
	checkNum "$opChoice" "1" "6"
	opChoice="$funOp"
		case $opChoice in 
			1)
			       	create
			         ;;
			2)
			       	copy
			    ;;
			3)
			       	move
		            ;;
			4)
			       	rename
			   ;;
			5)
			       	delete
				;;
			6) 
				main
		   esac
}
function fileManagement () {
	echo ""
	read -p $'Welcome to file management section .
		 which service do need ?
		 
		 1- file operations
		 2- file searching
		 3- backup or restore
		 4- permission management
		 5- Retrun to the main menu ' serviceOp
	checkNum "$serviceOp" "1" "5"
	serviceOp="$funOp"
		case $serviceOp in 
			1)
			       	operation
				;;
			2)
			       	search
				;;
			3)
			       	backup_restore
				;;
			4)
			       	permission
				;;
			5)	main

		esac
}
function check (){
 checkNum "$choice" "1" "4"
 choice="$funOp"

	 case $choice in
		 1)
			 fileManagement
			 ;;
		 2)
			 system_monitoring
			 ;;
		 3)
			 systemReport
			 ;;
		4)
			exit
	       	esac
}
function systemReport(){

read -p $'Enter the path where the system metrics report should be save (e.g, /path/to/report.txt \n' path
reportfile="$path"
if checkPath ; then
	echo -e "Report of System Metrics \n 
---------------------------------------------------------------	" >> "$reportfile"
	printf "%-20s %-5s %-20s\n" "HostName" "|" "$(hostname)" >> "$reportfile"
	printf "%-20s %-5s %-20s\n" "Kernel version" "|" "$(uname -o)" >> "$reportfile"
	printf "%-20s %-5s %-20s\n" "UpTime" "|" "$(uptime -p)" >> "$reportfile"
	printf "%-20s %-5s %-20s\n" "Current date" "|" "$(date)" >> "$reportfile"
	free -m | awk '/^Mem:/{printf "%-20s %-5s %-20s\n","Total Memory in MB","|",$2; printf "%-20s %-5s %-20s\n","Used Memory in MB","|",$3; 
	printf "%-20s %-5s %-20s\n","Free Memory in MB","|",$4}' >> "$reportfile"
	df -h --total | awk 'NR==11 {printf "%-20s %-5s %-20s\n","Total Disk Size","|",$2; printf "%-20s %-5s %-20s\n","Used Disk","|",$3;
	printf "%-20s %-5s %-20s\n","Free Disk","|",$4; printf "%-20s %-5s %-20s\n","Disk usage %","|",$5}' >> "$reportfile"
	lscpu | awk 'NR==8 {printf "%-20s %-5s %-20s\n","CPU Model Name","|",$2}; NR==12 {printf "%-20s %-5s %-20s\n","CPU Core","|",$2};
	NR==15 {printf "%-20s %-5s %-20s\n","CPU Speed in MHz","|",$2}' >> "$reportfile"
	top -bn1 | sed -n '3s/id/%/p' | awk -F "," '{printf "%-20s %-5s %-20s\n","CPU Usage in %","|", $4}' >> "$reportfile"
	hostname -I | awk '{printf "%-20s %-5s %-20s\n","IP Address","|",$1}' >> "$reportfile"
else 
	echo "Could not reach the file"
	main
fi
checkProcess
main
}
main
