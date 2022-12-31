#add, commit, and push updates. The directory is 

git add .
LINE_NUMBER=$(git log --oneline | wc -l | sed s/.*[^1-9]//)
git commit -m "COMMIT #$LINE_NUMBER"
git push origin master
