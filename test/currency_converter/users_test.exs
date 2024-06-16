defmodule CurrencyConverter.UsersTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Users
  alias CurrencyConverter.User

  describe "users" do
    test "create_user/0 creates a user" do
      assert {:ok, %User{id: _id, username: "username_test"}} =
               Users.create_user(%{"username" => "username_test"})
    end
  end
end
