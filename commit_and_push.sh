#add, commit, and push updates. When a separate git repository is updated, a post-commit hook transfers its commit history log to this directory and executes this script.

git log --oneline > $(pwd | rev | cut -f 1 -d / | rev)test.log
git add .
LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^1-9]//)
if [$(echo $LINE_NUMBER | wc -c) -eq 1 ];
	then LINE_NUMBER=" Local Changes";
fi 
echo $LINE_NUMBER
git commit -m "COMMIT #$LINE_NUMBER"
git push origin master
