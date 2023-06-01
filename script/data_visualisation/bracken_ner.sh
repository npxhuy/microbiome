# Run the code in bracken_filtered folder
# Clean the file
# A new directory outside the folder that has the bracken_filtered results must be made, for demonstration I name it "new_bracken_folder"
ls | while read file; do cat $file | cut -f 1,6 > ../new_bracken_folder/$file; done