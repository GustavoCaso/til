defmodule TIL.BasicAuth do
  def auth(username, password) do
    [hackney: [basic_auth: {username, password}]]
  end
end
