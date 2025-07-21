import std/[httpclient, json, strformat, strutils]

let Token: string = ""

type
    PopularMovie = object
        title: string
        overview: string
        releaseData: string
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


proc getPopularMovies(): seq[PopularMovie] = 
    let url: string = "https://api.themoviedb.org/3/movie/popular?page=1"
    var response: JsonNode = getMovies(url)
    let results: JsonNode = response["results"]
    var data: seq[PopularMovie] = @[]

    for item in results:
        echo item
        data.add(PopularMovie(
            title: item{"title"}.getStr,
            overview: item{"overview"}.getStr,
            popularity: item{"popularity"}.getFloat,
            originalTitle: item{"original_title"}.getStr,
            voteAverage: item{"vote_average"}.getFloat,
            voteCount: item{"vote_count"}.getInt
        ))
    
    return data

when isMainModule:
    let data: seq[PopularMovie] = getPopularMovies()

    echo data