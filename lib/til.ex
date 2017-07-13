defmodule TIL do
  alias TIL.{GithubToken, ConfigFile, Messages, GithubGist}

  def main(args) do
    args |> parse_args |> process
  end

  def parse_args(args) do
    options = OptionParser.parse(args, switches: switches(), aliases: aliases())
    case options do
      { [help: true], _, _ } -> [:help]
      { [login: true], _, _ } -> [:login]
      { [auth_token: token], _, _ } -> [:auth_token, token]
      { options, [til], _} -> [:create, til, options]
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
    case GithubToken.new_credential(username, password) do
      {:ok, token } ->
        ConfigFile.create(username, token)
        Messages.succesful_auth_message
      {:error, :two_factor} -> Messages.two_factor_message
      {:error, :invalid_credentials} -> Messages.invalid_credentials
    end
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
      file_name: :string,
      auth_token: :string
    ]
  end

  defp aliases do
    [
      h: :help,
      d: :description,
      f: :file_name,
      p: :public
    ]
  end
end
