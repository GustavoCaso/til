defmodule TIL.GithubGist do
  @github_client Application.get_env(:til, :github_client)

  def create(til, opts\\[]) do
    @github_client.create_gist(gist_body(til, opts))
    |> parse_response
  end

  def gist_body(content, opts) do
    Poison.encode!(%{
      "description": opts[:description] || "",
      "public": Keyword.get(opts, :public, true),
      "files": %{} |> Map.put(opts[:file_name] || "file1.txt", %{ "content": content  })
    })
  end

  defp parse_response(%HTTPoison.Response{status_code: status_code, body: body}) do
    result = case status_code do
      x when x in 202..500 -> Poison.decode!(body)["message"]
      201 -> Poison.decode!(body)["url"]
    end
    IO.puts result
  end
end
