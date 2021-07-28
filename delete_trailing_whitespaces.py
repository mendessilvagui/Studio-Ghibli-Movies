import os
import fileinput


def main():
	for root, dirs, filenames in os.walk('Studio Ghibli Movies'):
	    path = root.split(os.sep)
	    for filename in filenames:
	    	file_path = os.path.join(root, filename)
	    	if file_path.endswith('.swift'):
	    		with fileinput.input(file_path, inplace=True) as file:
	    			for line in file:
	    				new_line = line.rstrip()
	    				print(new_line)


if __name__ == '__main__':
	main()
