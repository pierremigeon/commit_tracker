#add, commit, and push updates. When a separate git repository is updated, a post-commit hook transfers its commit history log to this directory and executes this script.

echo -n > projects_names_list.tmp
for dir in $(ls -1t | grep _project); do 
	echo $dir >> projects_names_list.tmp
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

paste -d '|' projects_names_list.tmp projects_dates_list.tmp projects_commits_list.tmp | sed 's/[ ]*|/ | /g' | column -s $' ' -t > projects_summary.tmp
sort -r -k 3 projects_summary.tmp > projects_summary2.tmp
mv projects_summary2.tmp projects_summary.tmp

python ./test_pyscript.py
mv README.tmp README.md
rm *tmp 
#git log --oneline > $(pwd | rev | cut -f 1 -d / | rev).log
#git add .
#LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^0-9]//)
#git commit -m "COMMIT #$LINE_NUMBER"
#git push origin master
