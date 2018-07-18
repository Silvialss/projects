common_month_days = [31,28,31,30,31,30,31,31,30,31,30,31]
leap_month_days = [31,29,31,30,31,30,31,31,30,31,30,31]


def common(year):
	if year %4 != 0:
		return True
	else:
		if year % 100 != 0:
			return False
		else:
			if year % 400 != 0:
				return True
			else:
				return False


def days_past(year,month,day):
	m = 1
	days = 0
	if common(year) is True:
		while m < month:
			single_month_days = common_month_days[m-1]
			days = single_month_days + days
			m = m + 1
		return days + day
	else:
		while m < month:
			single_month_days = leap_month_days[m-1]
			days = single_month_days + days
			m = m + 1
		return days + day

def days_between(year1,year2):
	days = 0
	for i in range(year1+1,year2):
		if common(i) is True:
			days = days + 365
		else:
			days = days + 366
	return days

def daysBetweenDates(year1,month1,day1,year2,month2,day2):
	if year1 == year2:
		return days_past(year2,month2,day2) - days_past(year1,month1,day1)
	else:
		if common(year1) is True:
			days_birth = 365 - days_past(year1,month1,day1)
		else:
			days_birth = 366 - days_past(year1,month1,day1)
		this_year = days_past(year2,month2,day2)
		return days_birth + this_year + days_between(year1,year2)
print daysBetweenDates(2011,1,1,2018,1,2)
