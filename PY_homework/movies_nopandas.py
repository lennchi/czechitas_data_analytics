import csv
import json


with open("data/netflix_titles.tsv", encoding="utf-8") as f:
    data = csv.reader(f, delimiter="\t")
    next(data)

    movies = []

    for row in data:
        title = row[2]
        directors = row[15].split(", ") if row[15] != "" else []
        cast = row[16].split(", ") if row[16] != "" else []
        genres = row[8].split(",")
        decade = int(row[5][:-1] + "0")

        movies.append(
            {
                "title": title,
                "directors": directors,
                "cast": cast,
                "genres": genres,
                "decade": decade,
            }
        )

with open("movies_alt.json", "w", encoding="utf-8") as f:
    json.dump(movies, f, ensure_ascii=False, indent=4)
