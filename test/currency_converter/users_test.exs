defmodule CurrencyConverter.UsersTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Users
  alias CurrencyConverter.User

  describe "users" do
    test "create_user/0 creates a user" do
      assert {:ok, %User{id: _id}} = Users.create_user(%{})
    end
  end
end
