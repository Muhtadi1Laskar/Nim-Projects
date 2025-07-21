import std/[httpclient, json, strformat, strutils]

const
  GitHubAPI: string = "https://api.github.com/users/{name}/repos"
  Token: string = ""

type 
    GithubRepo = object
        name: string
        fullName: string
        description: string
        language: string

proc fetchRepos(username: string): seq[GithubRepo] = 
    var client: HttpClient = newHttpClient()
    client.headers = newHttpHeaders({
        "Authorization": fmt"Bearer {Token}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "Nim-GitHub-Client"  # GitHub requires User-Agent
    })

    try:
        let url: string = GitHubAPI.replace("{name}", username)
        let response: Response = client.get(url)

        if response.code == Http200:
            let data: JsonNode = parseJson(response.body)

            for repo in data:
                result.add(GithubRepo(
                    name: repo{"name"}.getStr,
                    full_name: repo{"full_name"}.getStr,
                    description: repo{"description"}.getStr("No description"),
                    language: repo{"language"}.getStr("Unknown")
                ))
        else:
            echo fmt"Error {response.code} - {response.status}"
    except HttpRequestError as e:
        echo "HTTP request failed: ", e.msg
    except JsonParsingError:
        echo "Failed to parse JSON response"
    finally:
        client.close()




 
when isMainModule:
    echo "Enter Github username: "

    let username: string = readLine(stdin).strip()
    let repos: seq[GithubRepo] = fetchRepos(username)

    for repo in repos:
        echo fmt"""
Repository: {repo.name}
Full Name: {repo.full_name}
Description: {repo.description}
Language: {repo.language}
"""