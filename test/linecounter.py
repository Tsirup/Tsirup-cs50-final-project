import os

folder_path = input("Enter the path to the folder to count lines of code: ")
total_count = 0

for dirpath, dirnames, filenames in os.walk(folder_path):
    for filename in filenames:
        file_path = os.path.join(dirpath, filename)
        with open(file_path, 'r') as file:
            count = 0
            for line in file:
                count += 1
            total_count += count
            print(f"Found {count} lines of code in file: {file_path}")

print(f"\nTotal lines of code found in {folder_path}: {total_count}")