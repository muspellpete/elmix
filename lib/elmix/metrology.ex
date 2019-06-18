defmodule Elmix.Metrology do
  @moduledoc """
  The Metrology context.
  """

  import Ecto.Query, warn: false
  alias Elmix.Repo

  alias Elmix.Metrology.Weather

  @doc """
  Returns the list of samples.

  ## Examples

      iex> list_samples()
      [%Weather{}, ...]

  """
  def list_samples do
    Repo.all(Weather)
  end

  @doc """
  Gets a single weather.

  Raises `Ecto.NoResultsError` if the Weather does not exist.

  ## Examples

      iex> get_weather!(123)
      %Weather{}

      iex> get_weather!(456)
      ** (Ecto.NoResultsError)

  """
  def get_weather!(id), do: Repo.get!(Weather, id)

  @doc """
  Creates a weather.

  ## Examples

      iex> create_weather(%{field: value})
      {:ok, %Weather{}}

      iex> create_weather(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_weather(attrs \\ %{}) do
    %Weather{}
    |> Weather.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a weather.

  ## Examples

      iex> update_weather(weather, %{field: new_value})
      {:ok, %Weather{}}

      iex> update_weather(weather, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_weather(%Weather{} = weather, attrs) do
    weather
    |> Weather.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Weather.

  ## Examples

      iex> delete_weather(weather)
      {:ok, %Weather{}}

      iex> delete_weather(weather)
      {:error, %Ecto.Changeset{}}

  """
  def delete_weather(%Weather{} = weather) do
    Repo.delete(weather)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weather changes.

  ## Examples

      iex> change_weather(weather)
      %Ecto.Changeset{source: %Weather{}}

  """
  def change_weather(%Weather{} = weather) do
    Weather.changeset(weather, %{})
  end
end
