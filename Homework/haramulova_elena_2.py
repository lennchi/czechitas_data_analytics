import json
import pandas as pd
from pprint import pprint


# Read data from the source file into a pd df
df = pd.read_csv("./data/netflix_titles.tsv", delimiter="\t")

# # Fetch column headers as a list so I don't have to copy/type them out one by one later :D
# headers = df.columns.tolist()
# print(headers)

# Drop columns we don't need
df = df.drop(
    [
        "TCONST",
        "TITLETYPE",
        "ORIGINALTITLE",
        "ISADULT",
        "ENDYEAR",
        "RUNTIMEMINUTES",
        "AVERAGERATING",
        "NUMVOTES",
        "TITLETYPE_NEW",
        "SHOW_ID",
        "TYPE",
        "TITLE",
        "COUNTRY",
        "DATE_ADDED",
        "RELEASE_YEAR",
        "RATING",
        "DURATION",
        "LISTED_IN",
        "DESCRIPTION",
    ],
    axis=1,
)

# Rename headers as per assignment
new_headers = {
    "PRIMARYTITLE": "title",
    "DIRECTOR": "directors",
    "CAST": "cast",
    "GENRES": "genres",
    "STARTYEAR": "decade",
}
df = df.rename(columns=new_headers)

# Reorder columns as per assignment
df = df[["title", "directors", "cast", "genres", "decade"]]

# Convert df rows into dicts
movies = [row.to_dict() for header, row in df.iterrows()]

pprint(movies)
