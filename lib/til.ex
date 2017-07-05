defmodule TIL do
  @github_url "https://api.github.com"
  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean, login: :boolean, create: :string, auth_token: :string], aliases: [h: :help])
    case options do
      { [help: true], _, _ } -> [:help]
      { [login: true], _, _ } -> [:login]
      { [auth_token: token], _, _ } -> [:auth_token, token]
      { [create: til], _, _ } -> [:create, til]
    end
  end

  def process([:login]) do
    IO.puts "Obtaining OAuth2 access_token from github."
    username = gets "Github Username: "
    password = gets "password: "
    HTTPoison.start
    HTTPoison.post!(credentials_url(), body(), [{"Accept", "application/json"}], auth(username, password))
    |> IO.inspect
    |> parse_response
  end

  def process([:auth_token, token]) do
    IO.puts "Creating conf file for tli"
    actual_directory = System.cwd()
    user_home_directory = System.user_home()
    IO.puts "cd into home directory #{user_home_directory}"
    File.cd(user_home_directory)
    IO.puts "writting auth_token into file .til"
    File.write(Path.absname(".til"), String.strip(token))
    File.cd(actual_directory)
  end

  def process([:create, _]) do
    IO.puts "Creating gists"
    username = gets "Github Username: "
    HTTPoison.start
    HTTPoison.post!(gist_url(), gist_body(), [{"Accept", "application/json"}], auth(username, token()))
    |> IO.inspect
    |> parse_response
  end

  defp parse_response(response) do
    case response do
      %HTTPoison.Response{status_code: 401, body: body} ->
        parse_unauthorize_body(body)
      %HTTPoison.Response{status_code: 201, body: body} ->
        parse_body(body)
    end
  end

  defp parse_unauthorize_body(body) do
    body
    |> Poison.decode!
    |> lookup_body
  end

  defp parse_body(body) do
    IO.inspect body
  end

  defp lookup_body(%{"message" => message, "documentation_url" => _}) do
    case Regex.match?(~r/Bad credentials/, message) do
      true -> IO.warn "Invalid Credentials"
      _ -> ask_to_create_auth_token()
    end
  end

  def ask_to_create_auth_token do
    IO.puts """
      You have activated Two factor Authentication, please go to your setting in Github
      and create a specific token to use with this application

      Once you have it please use the command `tli --auth-token {your_token}` to save it
    """
  end

  def body do
    Poison.encode!(%{
      "scopes": ["gist"],
      "note": "The til command line",
      "note_url":  "https://github.com/GustavoCaso/til"
    })
  end

  def gist_body do
    Poison.encode!(%{
      "description": "description of the gists",
      "public": true,
      "files": %{
        "file1.txt": %{
          "content": "String file contents"
        }
      }
    })
  end

  def token do
    user_home_directory = System.user_home()
    File.cd(user_home_directory)
    {:ok, token} = File.read(Path.absname(".til"))
    token
  end

  defp credentials_url do
    @github_url <> "/credentials"
  end

  defp gist_url do
    @github_url <> "/gists"
  end

  defp auth(username, password) do
    [hackney: [basic_auth: {username, password}]]
  end

  defp gets(text) do
    IO.gets(text)
    |> String.strip
  end
end
