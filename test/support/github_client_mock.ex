defmodule TIL.Test.GithubClientMock do
  def create_token("valid_username", "valid_password") do
    %HTTPoison.Response{status_code: 201, body: "{\"token\": \"12345\"}"}
  end

  def create_token("two_factor", _) do
    %HTTPoison.Response{status_code: 401, body: "{\"message\": \"You have enable Two factor auth\", \"documentation_url\": \"yguyg\"}"}
  end

  def create_token("incorrect", _) do
    %HTTPoison.Response{status_code: 401, body: "{\"message\": \"Bad credentials\", \"documentation_url\": \"yguyg\"}"}
  end

  def create_gist("{\"public\":true,\"files\":{\"file1.txt\":{\"content\":\"creating gist\"}},\"description\":\"\"}") do
    %HTTPoison.Response{status_code: 201, body: "{\"body\": {\"url\": \"the gist has been created\"}}"}
  end

  def create_gist("{\"public\":true,\"files\":{\"file1.txt\":{\"content\":\"fail to create\"}},\"description\":\"\"}") do
    %HTTPoison.Response{status_code: 500, body: "{\"body\": {\"message\": \"The body was incorrect\"}}"}
  end
end
