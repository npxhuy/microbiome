# Run in *bracken_filtered* directory.
# 1. Store all files names in an array
# 2. Run a nested for loop to iterate over all possible combinations of two files in the files array. The outer loop iterates over the indices of the first file in each pair, while the inner loop iterates over the indices of the second file in each pair. The range of the inner loop starts from the index of the outer loop plus one to avoid duplicate pairs.
# 2.1 For each pair of files, prints them out on a single line separated by a space. The filenames are accessed using the array indices i and j, which correspond to the indices of the first and second files in each pair, respectively. The ${files[i]} and ${files[j]} syntax retrieves the filenames stored in the files array at the specified indices.
# 2.2 Break down of the for loop:
# 2.2.1 'for' is the keyword used to indicate the start of the loop.
# 2.2.2 '((' indicates that the loop uses C-style syntax.
# 2.2.3 'i=0' initializes a variable called 'i' to zero, which will be used to track the current index in the loop.
# 2.2.4 'i<${#files[@]}' sets the condition that the loop will continue as long as the value of 'i' is less than the number of elements in the 'files' array.
# 2.2.5 'i++' is the operation that increments the value of i by one after each iteration of the loop.
# 2.2.6 '))' indicates the end of the loop.
# 3. Save the printed pairs into a file call 'combination.txt'
files=($(ls)) ;for (( i=0; i<${#files[@]}; i++ )); do for (( j=i+1; j<${#files[@]}; j++ )); do echo "${files[i]} ${files[j]}"; done ; done > combination.txt