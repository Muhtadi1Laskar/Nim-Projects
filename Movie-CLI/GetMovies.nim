import std/[httpclient, json, strformat, strutils]

let Token: string = ""

type
    MovieData = object
        title: string
        overview: string
        releaseDate: string
        popularity: float
        originalTitle: string
        voteAverage: float
        voteCount: int

proc getMovies(url: string): JsonNode = 
    var client: HttpClient = newHttpClient()
    client.headers = newHttpHeaders({
        "Accept": "application/json",
        "Authorization": fmt"Bearer {Token}"
    })

    try:
        let response: Response = client.get(url)

        if response.code == Http200:
            return parseJson(response.body)
        else:
            echo fmt"Error: {response.code} - {response.status}"
    except HttpRequestError as e:
        echo "Http request failed: ", e.msg
    except JsonParsingError:
        echo "Failed to parse JSON"
    finally:
        client.close() 


proc getPopularMovies(): seq[MovieData] = 
    let url: string = "https://api.themoviedb.org/3/movie/popular?page=2"
    var response: JsonNode = getMovies(url)
    let results: JsonNode = response["results"]
    var data: seq[MovieData] = @[]

    for item in results:
        data.add(MovieData(
            title: item{"title"}.getStr,
            overview: item{"overview"}.getStr,
            releaseDate: item{"release_date"}.getStr,
            popularity: item{"popularity"}.getFloat,
            originalTitle: item{"original_title"}.getStr,
            voteAverage: item{"vote_average"}.getFloat,
            voteCount: item{"vote_count"}.getInt
        ))
    
    return data

proc printPopularMovies(data: seq[MovieData]) = 
    for elem in data:
        echo fmt"""
Title: {elem.title}
Overview: {elem.overview}
Release Date: {elem.releaseDate}
Popularity: {elem.popularity}
Original Title: {elem.originalTitle}
Vote Average: {elem.voteAverage}
Vote Count: {elem.voteCount}
        """

when isMainModule:
    let data: seq[MovieData] = getPopularMovies()

    printPopularMovies(data)