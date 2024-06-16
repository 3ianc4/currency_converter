defmodule CurrencyConverterWeb.UsersController do
  use CurrencyConverterWeb, :controller
  alias CurrencyConverter.Users

  def create(conn, params) do
    case Users.create_user(params) do
      {:ok, user} ->
      conn
      |> put_status(:created)
      |> render(:created, user: user, layout: false)
      
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:user_taken, layout: false)
    end
  end
end
