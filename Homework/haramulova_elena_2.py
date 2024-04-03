import json
import pandas as pd


# Read data from the source file into a pd df, handle nans
df = pd.read_csv(
    "./data/netflix_titles.tsv",
    encoding="utf-8",
    delimiter="\t",
    keep_default_na=False,
)

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

# Convert strings for directors/cast into lists
df["directors"] = df["directors"].str.split(",")
df["cast"] = df["cast"].str.split(",")

# Convert df rows into dicts
movies = [row.to_dict() for i, row in df.iterrows()]

# Change years to decades
for movie in movies:
    year_str = str(movie["decade"])
    movie["decade"] = year_str[:-1] + "0"

# Replace [""] with [] for directors/cast
movies = [
    {key: [] if value == [""] else value for key, value in movie.items()}
    for movie in movies
]

# Write to a new .json file
with open("homework/movies.json", "w", encoding="utf-8") as f:
    json.dump(movies, f, indent=4)
