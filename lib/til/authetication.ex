defmodule TIL.Authentication do
  use GenServer
  alias TIL.{GithubToken, Messages, ConfigFile}

  def create_auth_token(username, password) do
    case GithubToken.new_credential(username, password) do
      {:ok, token } ->
        ConfigFile.create(username, token)
        Messages.succesful_auth_message
      {:error, :two_factor} -> Messages.two_factor_message
      {:error, :invalid_credentials} -> Messages.invalid_credentials
    end
  end
end
