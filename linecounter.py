# this is just a script to help me keep track of my progress
# note that it only cares about files that I myself have written and also aren't throwaway files like test files or todo files
import os

def count_lines(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        return len(f.readlines())

def count_lines_in_files(files):
    total_lines = 0
    for file in files:
        total_lines += count_lines(file)
    return total_lines

def count_lines_in_directory(directory):
    total_lines = 0
    for filename in os.listdir(directory):
        if "test" not in filename:
            filepath = os.path.join(directory, filename)
            total_lines += count_lines(filepath)
    return total_lines

def count_lines_in_files_and_directories(paths):
    total_lines = 0
    for path in paths:
        if os.path.isfile(path):
            total_lines += count_lines(path)
        elif os.path.isdir(path):
            total_lines += count_lines_in_directory(path)
    return total_lines

# Example usage
paths = ["maps","units","border.py","indexer.py","keys.txt","linecounter.py","main.lua","mapgen.lua","menu.lua","movement.lua","priorityqueue.lua", "transparent.py", "README.md"]
total_lines = count_lines_in_files_and_directories(paths)
print(f'Total lines of code: {total_lines}')