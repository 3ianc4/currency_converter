defmodule CurrencyConverter.Users do
  @moduledoc """
  The users context.
  """

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo

  alias CurrencyConverter.User

  @doc """
  Creates a user or returns an existing one.

  ## Parameters

    - params: A map containing user parameters, which can include `username` or `user_id`.

  ## Returns

    - {:ok, %User{}} on success.
    - {:error, %Ecto.Changeset{}} on failure when username is already taken.
    - {:error, :not_found} on failure when user_id is not found.

  ## Examples

      iex> create_user(%{"username" => "new_user"})
      {:ok, %User{}}

      iex> create_user(%{"user_id" => "existing_user_uuid"})
      {:ok, %User{}}
  """
  def create_user(%{"user_id" => user_id} = _params) do
    case get_user(user_id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Gets a user by ID.

  ## Parameters

    - id: The user ID.

  ## Returns

    - %User{} if the user is found.
    - nil if the user does not exist.

  ## Examples

      iex> get_user("valid_user_id")
      %User{}

      iex> get_user("invalid_user_id")
      nil
  """
  def get_user(id), do: Repo.get(User, id)
end
