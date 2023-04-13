NUM_BRANCH=$(git branch | wc -l | sed 's/ //g') 
NUM_MERGED=$(git branch --merged master | wc -l | sed 's/ //g')
PERCENT_MERGED=$(printf '%0.f%%\n' $(echo "$NUM_MERGED * 100 / $NUM_BRANCH" | bc -l))
echo -e $NUM_BRANCH\|$NUM_MERGED "\t" \($PERCENT_MERGED\) > ./branch_number
