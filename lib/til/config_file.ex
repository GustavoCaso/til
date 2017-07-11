defmodule TIL.ConfigFile do
  def create(username, token) do
    IO.puts "Creating conf file for tli"
    actual_directory = System.cwd()
    IO.puts "cd into home directory #{user_home_directory()}"
    File.cd(user_home_directory())
    IO.puts "writting auth_token into file .til"
    File.write(config_file(), config_file_content(token, username))
    File.cd(actual_directory)
  end

  def config_file_content do
    File.cd(user_home_directory())
    {:ok, content} = File.read(config_file())
    content |> Poison.decode!
  end

  def config_file? do
    File.cd(user_home_directory())
    case File.stat(config_file()) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  defp user_home_directory, do: System.user_home()

  defp config_file, do: Path.absname(".til")

  defp config_file_content(token, username) do
    %{username: username, token: token}
    |> Poison.encode!
  end
end
