#add, commit, and push updates. When a separate git repository is updated, a post-commit hook transfers its commit history log to this directory and executes this script.

git add .
LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^1-9]//)
git commit -m "COMMIT #$LINE_NUMBER"
git push origin master
