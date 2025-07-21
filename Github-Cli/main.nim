import std/[httpclient, json, strformat, strutils]

const
  GitHubAPI = "https://api.github.com/users/{name}/repos"
  Token = ""

type
    GitHubRepo = object
        name: string
        full_name: string
        description: string
        language: string

type
    GitHubEvent = object
        CreatedAt: string
        CommitURL: string
        Message: string
        Author: string
        Email: string


proc makeAPICall(url: string): JsonNode = 
    var client: HttpClient = newHttpClient()

    client.headers = newHttpHeaders({
        "Authorization": fmt"Bearer {Token}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "Nim-GitHub-Client"
    })

    try:
        let response: Response = client.get(url)

        if response.code == Http200:
            return parseJson(response.body)
        else:
            echo fmt"Error: {response.code} - {response.status}"
    except HttpRequestError as e:
        echo "HTTP request failed: ", e.msg
    except JsonParsingError:
        echo "Failed to parse JSON response"
    finally:
        client.close() 

proc fetchAccountEvent(name: string): seq[GitHubEvent] = 
    var commits: seq[GitHubEvent] = @[]
    let url: string = "https://api.github.com/users/{name}/events"
    let fullURL: string = url.replace("{name}", name)
    var responseBody: JsonNode = makeAPICall(fullURL)

    for node in responseBody:
        commits.add(GitHubEvent(
            CreatedAt: node{"created_at"}.getStr,
            CommitURL: node{"payload"}{"commits"}[0]{"url"}.getStr,
            Message: node{"payload"}{"commits"}[0]{"message"}.getStr,
            Email: node{"payload"}{"commits"}[0]{"author"}{"email"}.getStr,
            Author: node{"payload"}{"commits"}[0]{"author"}{"name"}.getStr,
        ))
    return commits

proc printEvents(data: seq[GitHubEvent]) = 
    for elem in data:
        echo fmt"""
        Creation Date: {elem.CreatedAt}
        Commit URL: {elem.CommitURL}
        Message: {elem.Message}
        Email: {elem.Email}
        Author: {elem.Author}
        """


proc fetchRepos*(username: string): seq[GitHubRepo] =
    let url: string = GitHubAPI.replace("{name}", username)
    let response: JsonNode = makeAPICall(url)

    for node in response:
        result.add(GitHubRepo(
          name: node{"name"}.getStr,
          full_name: node{"full_name"}.getStr,
          description: node{"description"}.getStr("No description"),
          language: node{"language"}.getStr("Unknown")
        ))


when isMainModule:
    echo "Enter GitHub username: "
    let username = readLine(stdin).strip()
  
    let repos: seq[GitHubRepo] = fetchRepos(username)
    let events: seq[GitHubEvent] = fetchAccountEvent(username)

    printEvents(events)
  
    for repo in repos:
        echo fmt"""
# Repository: {repo.name}
# Full Name: {repo.full_name}
# Description: {repo.description}
# Language: {repo.language}
 """
