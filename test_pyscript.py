#!/usr/bin python3

readme_in = open('./README.md', 'r')
readme_out = open('./README.tmp', 'w')
projects_list = open('./projects_summary.tmp', 'r')

for line in readme_in:
	if "[comment]:" in line:
		readme_out.write(line)
		readme_out.write("Project Name | Last Updated | Number of Commits\n:---|:---|:---\n")
		for i in projects_list:
			readme_out.write(i)
	else: 
		readme_out.write(line)
