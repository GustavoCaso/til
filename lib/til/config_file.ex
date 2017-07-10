defmodule TIL.ConfigFile do
  def create(token) do
    IO.puts "Creating conf file for tli"
    actual_directory = System.cwd()
    user_home_directory = System.user_home()
    IO.puts "cd into home directory #{user_home_directory}"
    File.cd(user_home_directory)
    IO.puts "writting auth_token into file .til"
    File.write(Path.absname(".til"), String.strip(token))
    File.cd(actual_directory)
  end

  def token do
    user_home_directory = System.user_home()
    File.cd(user_home_directory)
    {:ok, token} = File.read(Path.absname(".til"))
    token
  end
end
