import csv
import re 

file = open('test.csv','r')
read = csv.reader(file)
newfile = open('alldata.csv','w')
writer = csv.writer(newfile)

for row in read:
	row[2] = re.sub('<[a-zA-Z0-9\s"_=/]*>','',row[2])

	if row[3] == []:
			row[3] = "0"
	else:
		row[3] = re.sub('\D','',row[3])
	writer.writerow(row)
	



		

	

