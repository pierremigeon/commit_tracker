#add, commit, and push updates. When a separate git repository is updated, a post-commit hook transfers its commit history log to this directory and executes this script.

cd ..
#Create Summary Table for commit statistics
base="$(pwd | rev | cut -f 1 -d / | rev)_project"
file_name="$(pwd | rev | cut -f 1 -d / | rev)::$(git branch | grep \* | sed s/\*\ //).data";
header="Commit_id\tDate\t\tFiles\tInsert\tDelete\tSum"
id1='file'; 
id2='+'; 
id3='-';
i=$(git log --oneline | awk '{print $1}' | wc -l | sed 's/[^0-9]//g');
echo -e "Commit_num\t$header" > ./${base}/${file_name};
while : ; do
	for id in $(git log --oneline | awk '{print $1}'); do 
		data=$(echo $(git show $id --stat | tail -n1) | tr ',' '\n');
		echo -ne $i "\t\t" >> ./${base}/${file_name};
		echo -ne "$id\t\t" >> ./${base}/${file_name};
		echo -ne $(git show -s --format=%ci $id | sed 's/\ .*//g') "\t" >> ./${base}/${file_name};
		array=();
		array[0]=$(echo $(grep "$id1" <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[1]=$(echo $(grep [$id2] <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[2]=$(echo $(grep [$id3] <<< "$data" || echo 0) | sed 's/[^0-9]//g');
		array[3]=$(echo ${array[1]} + ${array[2]} | bc); 
		echo ${array[@]} | tr ' ' '\t' >> ./${base}/${file_name};
		i=$((i - 1));
	done;
	[[ $(head -n 2 ./${base}/$file_name | tail -n1 | awk '{print $1}' | grep - | echo $(wc -l)) -ne 0 ]] || break;
	[[ $(awk '{print $7}' ./${base}/$file_name | echo $(wc -w)) -ne 0 ]] || break;
done;

#create graph for commit_tracker project
Rscript ./commit_tracker_project/graph.R

#Create graph of all tracked commits
Rscript ./src/graph.R

echo -n > projects_names_list.tmp
for dir in $(ls -1t | grep _project); do 
	base_project_name=$(basename $dir _project)
	echo $base_project_name >> projects_names_list.tmp
	cat ./${dir}/branch_number >> projects_branches.tmp
	head -2 ./${dir}/*data | tail -1 | cut -f5 >> projects_dates_list.tmp
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
cat ./*_project/*data | grep -v Commit_num > totals.data
sort totals.data | uniq > totals.tmp
sort -k 3 totals.tmp > totals.data
awk '{print NR}' totals.data > totals.tmp
paste totals.tmp totals.data | cut -f1,4-10 > totals.2.tmp
echo -e "Number\t$header" > totals.data
cat totals.2.tmp >> totals.data

mv README.tmp README.md
rm *tmp
git log --oneline > ./${base}/$(pwd | rev | cut -f 1 -d / | rev).log
git add .
LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^0-9]//)
git commit -m "COMMIT #$LINE_NUMBER"
git push origin master
