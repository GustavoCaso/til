defmodule TilTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  def assert_file(file, function) do
    assert File.regular?(file), "Expected #{file} to exist, but it doesn't"
    function.(File.read!(file))
    :ok = File.rm(file)
  end

  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

  defp run(args) do
    TIL.parse_args(args)
  end

  describe "help" do
    test "displays help message" do
      capture_io(fn ->
        TIL.main(["-h"])
      end) =~ "TIL (Today I Learn)"
    end
  end

  describe "login" do
    test "creates config file" do
      capture_io([input: "valid_username\nvalid_password"], fn ->
        TIL.main(["--login"])
        assert_file ".til", fn(file) ->
          assert file =~ "{\"username\":\"valid_username\",\"token\":\"12345\"}"
        end
      end) =~ "You have create a custom auth token"
    end

    test "when user has enabled two factor auth" do
      capture_io([input: "two_factor\nvalid_password"], fn ->
        TIL.main(["--login"])
        refute_file ".til"
      end) =~ "You have activated Two factor"
    end

    test "bad credentials" do
      capture_io([input: "incorrect\nvalid_password"], fn ->
        TIL.main(["--login"])
        refute_file ".til"
      end) =~ "The credentials you have provided are invalid"
    end
  end

  describe "auth-token" do
    test "creates config file" do
      capture_io([input: "gustavo"], fn ->
        TIL.main(["--auth-token", "udywguwi7787"])
        assert_file ".til", fn(file) ->
          assert file =~ "{\"username\":\"gustavo\",\"token\":\"udywguwi7787\"}"
        end
      end)
    end
  end

  describe "create TIL" do
    test "when existing config file" do
      file = Path.absname(".til")
      File.write(file, "{\"username\":\"gustavo\",\"token\":\"udywguwi7787\"}")
      capture_io(fn ->
        TIL.main(["creating gist"])
      end) =~ "the gist has been created"
      :ok = File.rm(file)
    end

    test "fail to create gist" do
      file = Path.absname(".til")
      File.write(file, "{\"username\":\"gustavo\",\"token\":\"udywguwi7787\"}")
      capture_io(fn ->
        TIL.main(["fail to create"])
      end) =~ "The body was incorrect"
      :ok = File.rm(file)
    end

    test "when non existing config file" do
      capture_io(fn ->
        TIL.main(["creating gist"])
      end) =~ "For creating a TIL entry you have"
    end

    test "multiple options" do
      assert run(["--description", "hello_world", "--file-name", "john.ex", "gist with multiple options"]) ==
        [:create, "gist with multiple options", [description: "hello_world", file_name: "john.ex"]]
    end

    test "public options" do
      assert run(["--public", "gist with multiple options"]) ==
        [:create, "gist with multiple options", [public: true]]
    end

    test "no public options" do
      assert run(["--no-public", "gist with multiple options"]) ==
        [:create, "gist with multiple options", [public: false]]
    end
  end
end
