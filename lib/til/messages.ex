defmodule TIL.Messages do
  def help_message do
    IO.puts """
    """
  end

  def invalid_credentials do
    IO.puts """
      The credentials you have provided are invalid.
    """
  end

  def succesful_auth_message do
    IO.puts """
      You have create a custom auth token to use with this application

      Now you can create gist by using the comand `til --create {file_name | text}`
    """
  end

  def two_factor_message do
    IO.puts """
      You have activated Two factor Authentication, please go to your setting in Github
      and create a specific token to use with this application

      Once you have it please use the command `til --auth-token {your_token}` to save it
    """
  end

  def missing_token do
    IO.puts """
      For creating a TIL entry you have to previously create and auth_token for this application
      You have two options:
        - `til --login` will prompt for your Github username and password
        - `til --auth-token {your_token} if you want to create them yourself in the Github website`
    """
  end
end
