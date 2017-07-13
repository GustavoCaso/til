defmodule TIL.GithubToken do
  @github_client Application.get_env(:til, :github_client)

  def new_credential(username, password) do
    @github_client.create_token(username, password)
    |> match_response
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
