defmodule CurrencyConverter.Users do
  @moduledoc """
  The users context.
  """

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo

  alias CurrencyConverter.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user()
      {:ok, %User{}}

  """
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Gets a user.
  Returns a %User{} when id is valid.
  Returns nil when user doesn't exist.

  ## Examples

      iex> get(id)
      %User{}

      iex> get(0)
      nil

  """
  def get(id), do: Repo.get(User, id)
end
