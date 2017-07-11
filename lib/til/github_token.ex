defmodule TIL.GithubToken do
  alias TIL.{Github, BasicAuth}

  def new_credential(username, password) do
    HTTPoison.start
    HTTPoison.post!(credentials_url(), credentials_body(), [{"Accept", "application/json"}], BasicAuth.auth(username, password))
    |> match_response
  end

  defp credentials_url do
    Github.url <> "/credentials"
  end

  defp credentials_body do
    Poison.encode!(%{
      "scopes": ["gist"],
      "note": "The til command line",
      "note_url":  "https://github.com/GustavoCaso/til"
    })
  end

  defp match_response(response) do
    case response do
      %HTTPoison.Response{status_code: 401, body: body} ->
        body
        |> Poison.decode!
        |> check_for_unathorize_reason
      %HTTPoison.Response{status_code: 201, body: body} ->
        { :ok, Poison.decode!(body)["token"] }
    end
  end

  defp check_for_unathorize_reason(%{"message" => message, "documentation_url" => _}) do
    case Regex.match?(~r/Bad credentials/, message) do
      true -> {:error, :invalid_credentials}
      _ -> {:error, :two_factor}
    end
  end
end
