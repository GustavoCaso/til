defmodule GithubGistTest do
  use ExUnit.Case

  describe "gist_body" do
    test "without options" do
      assert TIL.GithubGist.gist_body("hello world", []) ==
        "{\"public\":true,\"files\":{\"file1.txt\":{\"content\":\"hello world\"}},\"description\":\"\"}"
    end

    test "description options" do
      assert TIL.GithubGist.gist_body("hello world", [description: "Custom description"]) ==
        "{\"public\":true,\"files\":{\"file1.txt\":{\"content\":\"hello world\"}},\"description\":\"Custom description\"}"
    end

    test "public options" do
      assert TIL.GithubGist.gist_body("hello world", [public: false]) ==
        "{\"public\":false,\"files\":{\"file1.txt\":{\"content\":\"hello world\"}},\"description\":\"\"}"
    end

    test "file name options" do
      assert TIL.GithubGist.gist_body("hello world", [file_name: "test.ex"]) ==
        "{\"public\":true,\"files\":{\"test.ex\":{\"content\":\"hello world\"}},\"description\":\"\"}"
    end
  end
end
