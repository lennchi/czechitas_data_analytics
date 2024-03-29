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
string.strip()
string.split()


# SETS are unordered; can only have unique values
hobbies = ["Python", "kung-fu", "Python", "Netflix"]
hobbies = set(hobbies)

hobbies.add("python")  # adding a new item to set

all_hobbies = hobbies_1 | hobbies_2  # outer join
common_hobbies = hobbies_1 & hobbies_2  # inner join
