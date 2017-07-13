defmodule TIL.GithubClient do
  @github_url "https://api.github.com"
  alias TIL.ConfigFile
  HTTPoison.start

  def create_token(username, password) do
    HTTPoison.post!(credentials_url(), credentials_body(), [{"Accept", "application/json"}], auth(username, password))
  end

  def create_gist(gist_body) do
    HTTPoison.post!(gist_url(), gist_body, [{"Accept", "application/json"}], auth(ConfigFile.username(), ConfigFile.token()))
  end

  defp auth(username, password) do
    [hackney: [basic_auth: {username, password}]]
  end

  defp credentials_url do
    @github_url <> "/credentials"
  end

  defp gist_url do
    @github_url <> "/gists"
  end

  defp credentials_body do
    Poison.encode!(%{
      "scopes": ["gist"],
      "note": "The til command line",
      "note_url":  "https://github.com/GustavoCaso/til"
    })
  end
end
