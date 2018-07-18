def output(n):
		if n<5:
			print '|'+5*'0'+(5-n)*'*'+'   '+n*'*'+'|'
		else:
			print '|'+(10-n)*'0'+'   '+(n-5)*'0'+5*'*'+'|'

def print_abacus(value):
    new_value = (10-len(str(value)))*'0' + str(value)
    for i in new_value:
        output(int(i))

        