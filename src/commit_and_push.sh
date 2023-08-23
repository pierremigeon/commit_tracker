#Author: Pierre Migeon Spring 2023
#Description: add, commit, and push updates. When a separate git repository is updated, a post-commit hook transfers its commit history log to this directory and executes this script.

cd ..
#Create Summary Table for commit statistics
base="$(pwd | rev | cut -f 1 -d / | rev)_project"
file_name="$(pwd | rev | cut -f 1 -d / | rev)::$(git branch | grep \* | sed s/\*\ //).data";
header="Commit_id\tDate\tFiles\tInsert\tDelete\tSum"
id1='file'; 
id2='+'; 
id3='-';
i=$(git log --oneline | awk '{print $1}' | wc -l | sed 's/[^0-9]//g');
echo -e "Commit_num\t$header" > ./${base}/${file_name};
while : ; do
	for id in $(git log --oneline | awk '{print $1}'); do 
		array=();
		array[0]=$i
		array[1]=$id
		array[2]=$(git show -s --format=%ci $id | sed 's/\ .*//g')
		data=$(echo $(git show $id --stat | tail -n1) | tr ',' '\n');
		array[3]=$(echo $(grep "$id1" <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[4]=$(echo $(grep [$id2] <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[5]=$(echo $(grep [$id3] <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[6]=$(echo ${array[4]} + ${array[5]} | bc); 
		echo ${array[@]} | tr ' ' '\t' >> ./${base}/${file_name};
		i=$((i - 1));
	done;
	[[ $(head -n 2 ./${base}/$file_name | tail -n1 | awk '{print $1}' | grep - | echo $(wc -l)) -ne 0 ]] || break;
	[[ $(awk '{print $7}' ./${base}/$file_name | echo $(wc -w)) -ne 0 ]] || break;
done;

#create graph for commit_tracker project
#Rscript ./commit_tracker_project/graph.R 

#Create table of all projects tracked in this repo
echo -n > projects_names_list.tmp
for dir in $(ls -1t | grep _project); do 
	base_project_name=$(basename $dir _project)
	echo [$base_project_name]\(https://github.com/pierremigeon/${base_project_name}\) >> projects_names_list.tmp
	cat ./${dir}/branch_number >> projects_branches.tmp
	ls -1t ./${dir}/*data | head -1 | xargs head -2 | tail -1 | cut -f3 >> projects_dates_list.tmp
	commits_tmp=0
	commits=0
	for log in ./${dir}/*log; do
		commits_tmp=$(cat ${log} | wc -l | sed 's/[^0-9]//g')
		if [ $commits_tmp -gt $commits ]; then
			commits=$commits_tmp;
		fi
	done;
	echo $commits >> projects_commits_list.tmp
done;

paste -d '|' projects_names_list.tmp projects_dates_list.tmp projects_commits_list.tmp projects_branches.tmp | sed 's/[ ]*|/ | /g' | column -s $' ' -t > projects_summary.tmp
sort -r -k 3 projects_summary.tmp > projects_summary2.tmp
mv projects_summary2.tmp projects_summary.tmp

#Update summary table of tracked projects
python ./src/update_readme_table.py

#Generate total commit data for all combined tracked projects
cat ./*_project/*data | grep -v Commit_num | tr '\t' ' ' | tr -s ' ' | tr ' ' '\t' > totals.data
sort totals.data | uniq > totals.tmp
sort -k 3 totals.tmp > totals.data
awk '{print NR}' totals.data > totals.tmp
paste totals.tmp totals.data | cut -f 1,3-8 > totals.2.tmp
echo -e "Number\t$header" > totals.data
cat totals.2.tmp >> totals.data
python3 ./src/sparsify_totals.py

#clean up temp files
mv README.tmp README.md
rm *tmp

#Create graph of all tracked commits
Rscript ./src/graph.R 

#create log files, commit updates and push the commit tracker directory 
git log --oneline > ./${base}/$(pwd | rev | cut -f 1 -d / | rev).log
git add .
LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^0-9]//)
git commit -m "COMMIT #$LINE_NUMBER"
git push origin master
