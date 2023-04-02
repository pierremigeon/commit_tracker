
### Commit tracker
This is repo is strictly for the purpose of tracking commits, so that I can get those sweet sweet green boxes on my github profile when I'm making commits to forked repos. Full disclosure, this directory is updated for any commits that I make, even without pushing those commits to this remote. It's still a measure of my productivity, but it's definitely not completely consistent with github's standard for this metric. It's actually a broader measure, as it tracks every commit I make regardless of whether or not the github account repositories are current.

I've done a bit of mucking about trying to get additional and/or superior metrics for productivity here as well. It's not very meaningful at this point. I've just grabbed the number of deletions and insertions from the git logs and used them. And did a bit of rough graphing to get some R practice. In some cases, massive testing/output files confound measures of my actual productivity in terms of lines of code written for commits. In the future I hope to exclude these files from my productivity measures, and also determine the number of characters per commit as a better unit of measure.

#### files follow this format:
```
#log files containing commit messages:
ProjectName::BranchName.log

#data files containing file/insertion/deletion information for each commit:
ProjectName::BranchName.data
```
#### Projects Currently Tracked in this repo:

[comment]: # (This is where the table goes)

Project Name | Last Updated | # of Commits | # of Branches
:---|:---|:---|:---
|                                        2023-02-03  |           67   |    8
|                                        2023-04-02  |           48   |    1
|                                        2023-01-27  |           36   |    2
|                                        2023-01-27  |           15   |    2
|                                        2023-04-01  |           102  |    1
minishell_project                        |           2023-04-01  |    47   |  5
commit_tracker_project                   |           2023-03-29  |    102  |  5
test_non-fastforward_merge-push_project  |           2023-02-03  |    67   |  5
FASTQ_examiner_project                   |           2023-01-27  |    36   |  5
ft_printf_project                        |           2023-01-27  |    15   |  5

[comment]: # (This is where the table ends)

![test_image](https://github.com/pierremigeon/commit_tracker/blob/master/totals_lineplot.png)

</br>

<p align="center">
  <img width="460" height="300" src="https://cdn.shopify.com/s/files/1/0502/6417/products/ScreenShot2020-04-30at10.11.38PM_4472x.png?v=1588308646">
</p>

*another green-ish square...*

I believe that by tracking my daily adherance to some minimal output metric it will be easier for me to maintain a consistent programming habit. This will also promote a more strictly atomic commit format for my work by encouraging smaller more incremental units of work output.
