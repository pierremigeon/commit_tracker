#!/usr/bin python3

readme_in = open('./README.md', 'r')
readme_out = open('./README.tmp', 'w')
projects_list = open('./projects_summary.tmp', 'r')

x = 0
for line in readme_in:
	if "[comment]:" in line:
		readme_out.write(line)
		if x == 0:
			readme_out.write("\nProject Name | Last Updated | # Commits | # Branches | Branches Merged\n:---|:---:|:---:|:---:|:---:\n")
		for i in projects_list:
			readme_out.write(i)
		if x == 0:
			readme_out.write("\n");
			x = 1
		else:
			x = 0
	elif x == 0:
		readme_out.write(line)
