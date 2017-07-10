defmodule TIL do
  alias TIL.{Authentication, ConfigFile}

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
    Authentication.start_link(username, password)
    Authentication.create_auth_token
  end

  def process([:auth_token, token]) do
    ConfigFile.create(token)
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
  #
  # defp gist_url do
  #   @github_url <> "/gists"
  # end

  defp gets(text) do
    IO.gets(text)
    |> String.strip
  end
end
