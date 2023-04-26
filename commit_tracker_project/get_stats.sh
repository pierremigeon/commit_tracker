#!/bin/bash

NUM_BRANCH=$(git branch | wc -l | sed 's/ //g') 
NUM_MERGED=$(git branch --merged master | wc -l | sed 's/ //g')
PERCENT_MERGED=$(printf '%0.f%%\n' $(echo "$NUM_MERGED * 100 / $NUM_BRANCH" | bc -l))
echo $NUM_BRANCH\|$PERCENT_MERGED \($NUM_MERGED/$NUM_BRANCH\) > ./branch_number
