import json
import pandas as pd


# Read data from the source file into a pd df, handle nans
df = pd.read_csv(
    "./data/netflix_titles.tsv",
    encoding="utf-8",
    delimiter="\t",
    keep_default_na=False,
)

# Only leave the columns we need in the df
df = df[["PRIMARYTITLE", "DIRECTOR", "CAST", "GENRES", "STARTYEAR"]].copy()

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
df["genres"] = df["genres"].str.split(",")

# Convert df rows into dicts
movies = [row.to_dict() for i, row in df.iterrows()]

# Change years to decades and cast to int
for movie in movies:
    year_str = str(movie["decade"])
    movie["decade"] = int(year_str[:-1] + "0")
    # print(type(movie["decade"]))

# Replace [""] with [] for directors/cast
movies = [
    {key: [] if value == [""] else value for key, value in movie.items()}
    for movie in movies
]

# Write to a new .json file
with open("PY_homework/movies.json", "w", encoding="utf-8") as f:
    json.dump(movies, f, ensure_ascii=False, indent=4)
