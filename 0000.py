## Conversion from binary
## Math and Statistics imports
## Cleaning up strings with split() and strip()
## Sets
## get()


# Conversion from binary
text = "1001"
number = int(text, 2)  # 2 for binary


# Math and Stats
import math
import statistics

math.ceil()  # round up
math.floor()  # round down
statistics.mean()
statistics.mode()


# Cleaning up strings
string = "jh a sasdf7"
string.strip()  # removes leading and trailing whitespaces; can specify chars to remove in ()
string.split()  # splits string into list items; optional: (sep=delimiter, maxsplit=max_num_of_splits_to_perform)


# SETS are unordered; can only have unique values
hobbies = ["Python", "kung-fu", "Python", "Netflix"]
hobbies = set(hobbies)

hobbies.add("python")  # adding a new item to set

all_hobbies = hobbies_1 | hobbies_2  # outer join (all of both)
common_hobbies = hobbies_1 & hobbies_2  # inner join (overlap)


# GET METHOD =  defense against KeyError
# this won't work if no such key in dict
insurance_number = person("insurance_card")

# this will work:
insurance_number = person.get(
    "insurance_card", "Naaaah"
)  # the second arg is what is returned if key not found
