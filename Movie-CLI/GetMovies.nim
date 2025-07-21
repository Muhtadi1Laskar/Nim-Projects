import std/[os, httpclient, json, strformat, strutils, strformat]

let 
    Token: string = ""
    BASEURL: string = "https://api.themoviedb.org/3/movie/{type}?page={p}"
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

proc getPopularMovies(url: string): seq[MovieData] = 
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

-------------------------------
        """

proc buildURL(movieType: string, page: int): string = 
    let endpoint = case movieType.toLowerAscii()
    of "playing": "now_playing"
    of "popular": "popular"
    of "top-rated": "top_rated"
    of "upcoming": "upcoming"
    else: ""

    if endpoint == "":
        raise newException(ValueError, "Invalid movie type: " & movieType)

    result = BASEURL
        .replace("{type}", endpoint)
        .replace("{p}", $page)

proc fetchMovies(movieType: string, page: int) = 
    var formattedStr: string = toLowerAscii(movieType)
    var url: string = buildURL(movieType, page)
    let data: seq[MovieData] = getPopularMovies(url)
    printPopularMovies(data)

when isMainModule:
    let 
        args: seq[string] = commandLineParams()
    
    if paramCount() == 0:
        quit(1)
    
    let command: string = paramStr(1)

    if paramCount() < 2:
        echo "Error: Not enough param"
        quit(1)
    
    let page: int = parseInt(paramStr(2))
    
    fetchMovies(command, page)