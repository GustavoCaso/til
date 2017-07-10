defmodule TIL.Authentication do
  use GenServer
  alias TIL.{Github, Messages, ConfigFile}

  def start_link(username, password) do
    GenServer.start_link(__MODULE__, %{username: username, password: password}, name: __MODULE__)
  end

  def create_auth_token do
    GenServer.call(__MODULE__, :create_auth_token)
  end

  def handle_call(:create_auth_token, _from, user_info) do
    case Github.new_credential(user_info) do
      {:ok, token } ->
        ConfigFile.create(token)
        {:reply, Messages.succesful_auth_message, user_info }
      {:error, :two_factor} -> {:reply, Messages.two_factor_message, user_info }
      {:error, :invalid_credentials} -> {:reply, Messages.invalid_credentials, user_info}
    end
  end
end
