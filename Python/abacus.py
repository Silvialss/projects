def output(n):
	if n < 5:
		print '|' + 5 * '0' + (5-n) * '*' + '   ' + n * '*' + '|'
	else:
		print '|' + (10 - n) * '0' + '   ' + (n-5) * '0' + 5 * '*' + '|'

def print_abacus(inputValue):
	value = int(inputValue)
	print value
	n = 0
	while n < 10:
		ten = (10 - len(str(value))) * '0' + str(value)
		output(int(ten[n:n+1]))
		n = n + 1
		if n >= 10:
			break



# def print_abacus_three_line(value):
# 	value = 9999999999 - value
	
# 	while value > 0:
# 		rowValue = (value % 10 + 1) % 10
# 		value = value / 10
# 		if rowValue < 5:
# 			print '|' + 5 * '0' + (5 - rowValue) * '*' + '   ' + rowValue * '*'  + '|'
# 		else:
# 			print '|' + (10 - rowValue) * '0' + '   ' + (rowValue - 5) * '0' + 5 * '*'  + '|'

def print_abacus_three_line(value):
	for i in '0' * (10 - len(str(value))) + str(value):
		if int(i) < 5:
		  print '|' + 5 * '0' + (5 - int(i)) * '*' + '   ' + int(i) * '*'  + '|'
		else:
			print '|' + (10 - int(i)) * '0' + '   ' + (int(i) - 5) * '0' + 5 * '*'  + '|'


def print_abacus_three_line(value):
	numberOfZeros = (10 - len(str(value)))
	stringifiedValue = '0' * numberOfZeros + str(value)

	for i in stringifiedValue:
		digit = int(i)

		if digit < 5:
			left = 5 * '0' + (5 - digit) * '*'
			right = digit * '*'
		else:
			left = (10 - digit) * '0'
			right = (digit - 5) * '0' + 5 * '*'

		print '|' + left + '   ' + right + '|'


print_abacus_three_line(456)

# print_abacus(0)
# print_abacus(10)
# print_abacus(123)
# print_abacus(123456)

# >>> (1234 / 1000000000) % 10
# 0
# >>> (1234 / 100000000) % 10
# 0
# >>> (1234 / 1000) % 10
# 1
# >>> (1234 / 100) % 10
# 2
# >>> (1234 / 10) % 10
# 3
# >>> (1234 / 1) % 10
# 4
# >>>
