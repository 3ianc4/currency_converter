defmodule CurrencyConverterWeb.UsersControllerTest do
  use CurrencyConverterWeb.ConnCase, async: true

  alias CurrencyConverter.Users

  @valid_params %{"username" => "valid_username"}
  @existing_username "takes_username"

  setup do
    params = %{username: @existing_username}
    {:ok, existing_user} = Users.create_user(params)

    {:ok, existing_user: existing_user}
  end

  describe "POST /users" do
    test "returns 200 and successfully creates a new user", %{conn: conn} do
      conn = post(conn, "/api/users", @valid_params)

      assert html_response(conn, 201) =~ "Welcome, valid_username"
    end

    test "returns 200 when user already exists", %{conn: conn, existing_user: existing_user} do
      conn = post(conn, "/api/users", %{"user_id" => existing_user.id})

      assert html_response(conn, 201) =~ "Welcome"
    end

    test "returns 422 when username is already taken", %{
      conn: conn,
      existing_user: existing_user
    } do
      conn = post(conn, "/api/users", %{username: existing_user.username})

      assert html_response(conn, 422) =~ "This username is already taken"
    end
  end
end
