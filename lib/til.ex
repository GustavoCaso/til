defmodule TIL do
  alias TIL.{Authentication, ConfigFile, Messages, GithubGist}

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    options = OptionParser.parse(args, switches: switches(), aliases: aliases())
    case options do
      { [help: true], _, _ } -> [:help]
      { [login: true], _, _ } -> [:login]
      { [auth_token: token], _, _ } -> [:auth_token, token]
      { [description: description], [til], _} -> [:create, til, [description: description]]
      { [public: public], [til], _} -> [:create, til, [public: public]]
      { [description: description, public: public], [til], _} -> [:create, til, [description: description, public: public]]
      { [], [til], [] } -> [:create, til, []]
    end
  end

  def process([:help]) do
    Messages.help_message
  end

  def process([:login]) do
    IO.puts "Obtaining OAuth2 access_token from github."
    username = gets "Github Username: "
    password = gets "password: "
    Authentication.create_auth_token(username, password)
  end

  def process([:auth_token, token]) do
    username = gets "Github Username: "
    ConfigFile.create(username, token)
  end

  def process([:create, til, options]) do
    case ConfigFile.config_file? do
      true -> GithubGist.create(til, options)
      false -> Messages.missing_token
    end
  end

  defp gets(text) do
    IO.gets(text)
    |> String.strip
  end

  defp switches do
    [
      help: :boolean,
      login: :boolean,
      description: :string,
      public: :boolean,
      auth_token: :string
    ]
  end

  defp aliases do
    [
      h: :help,
      d: :description,
      p: :public
    ]
  end
end
