import json


# Open source file
with open("./data/alice.txt", encoding="utf-8") as f:
    text = f.read()

    # Remove all spaces and new line chars
    text = text.replace(" ", "").replace("\n", "")

    # Make all chars lowercase
    text = text.lower()

# Create a dict with chars and their number of occurences
char_dict = {}
for char in text:
    if char in char_dict:
        char_dict[char] += 1
    else:
        char_dict[char] = 1

# Alphabetize the dict by key
sorted_dict = dict(sorted(char_dict.items()))

# Write the sorted dict to a new .json file
with open("ukol1_output.json", "w", encoding="utf-8") as f:
    json.dump(sorted_dict, f, indent=4)
