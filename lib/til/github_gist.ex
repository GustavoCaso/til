defmodule TIL.GithubGist do
  alias TIL.{Github, BasicAuth, ConfigFile}

  def create(til, opts\\[]) do
    HTTPoison.start
    HTTPoison.post!(gist_url(), gist_body(til, opts), [{"Accept", "application/json"}], BasicAuth.auth(username(), token()))
    |> parse_response
  end

  defp username, do: config_file_content()["username"]

  defp token, do: config_file_content()["token"]

  defp config_file_content, do: ConfigFile.config_file_content

  defp gist_body(content, opts) do
    Poison.encode!(%{
      "description": opts[:description] || "",
      "public": opts[:public] || true,
      "files": %{
        "file1.txt": %{
          "content": content
        }
      }
    })
  end

  defp gist_url do
    Github.url <> "/gists"
  end

  defp parse_response(%HTTPoison.Response{status_code: status_code, body: body}) do
    result = case status_code do
      x when x in 202..500 -> Poison.decode!(body)["message"]
      201 -> Poison.decode!(body)["url"]
    end
    IO.puts result
  end
end
