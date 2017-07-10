defmodule TIL.Github do
  @github_url "https://api.github.com"

  def new_credential(user_info) do
    HTTPoison.start
    HTTPoison.post!(credentials_url(), credentials_body(), [{"Accept", "application/json"}], auth(user_info))
    |> match_response
  end

  defp credentials_url do
    @github_url <> "/credentials"
  end

  def credentials_body do
    Poison.encode!(%{
      "scopes": ["gist"],
      "note": "The til command line",
      "note_url":  "https://github.com/GustavoCaso/til"
    })
  end

  defp auth(user_info) do
    [hackney: [basic_auth: {user_info[:username], user_info[:password]}]]
  end

  defp match_response(response) do
    case response do
      %HTTPoison.Response{status_code: 401, body: body} ->
        body
        |> Poison.decode!
        |> check_for_unathorize_reason
      %HTTPoison.Response{status_code: 201, body: body} ->
        { :ok, body |> Poison.decode!["token"] }
    end
  end

  defp check_for_unathorize_reason(%{"message" => message, "documentation_url" => _}) do
    case Regex.match?(~r/Bad credentials/, message) do
      true -> {:error, :invalid_credentials}
      _ -> {:error, :two_factor}
    end
  end
end
