defmodule TIL.ConfigFile do
  @system Application.get_env(:til, :system)

  def create(username, token) do
    IO.puts "Creating conf file for tli"
    actual_directory = @system.cwd()
    IO.puts "cd into home directory #{user_home_directory()}"
    File.cd(user_home_directory())
    IO.puts "writting auth_token into file .til"
    File.write(config_file(), config_file_content(token, username))
    File.cd(actual_directory)
  end

  def config_file? do
    File.cd(user_home_directory())
    File.regular?(config_file())
  end

  def username, do: config_file_content()["username"]

  def token, do: config_file_content()["token"]

  defp config_file_content do
    File.cd(user_home_directory())
    {:ok, content} = File.read(config_file())
    content |> Poison.decode!
  end

  defp user_home_directory, do: @system.user_home()

  defp config_file, do: Path.absname(".til")

  defp config_file_content(token, username) do
    %{username: username, token: token}
    |> Poison.encode!
  end
end
