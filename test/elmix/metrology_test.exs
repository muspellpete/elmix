defmodule Elmix.MetrologyTest do
  use Elmix.DataCase

  alias Elmix.Metrology

  describe "samples" do
    alias Elmix.Metrology.Weather

    @valid_attrs %{cloudy: true, moisture: "some moisture", temperatue: "some temperatue"}
    @update_attrs %{
      cloudy: false,
      moisture: "some updated moisture",
      temperatue: "some updated temperatue"
    }
    @invalid_attrs %{cloudy: nil, moisture: nil, temperatue: nil}

    def weather_fixture(attrs \\ %{}) do
      {:ok, weather} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Metrology.create_weather()

      weather
    end

    test "list_samples/0 returns all samples" do
      weather = weather_fixture()
      assert Metrology.list_samples() == [weather]
    end

    test "get_weather!/1 returns the weather with given id" do
      weather = weather_fixture()
      assert Metrology.get_weather!(weather.id) == weather
    end

    test "create_weather/1 with valid data creates a weather" do
      assert {:ok, %Weather{} = weather} = Metrology.create_weather(@valid_attrs)
      assert weather.cloudy == true
      assert weather.moisture == "some moisture"
      assert weather.temperatue == "some temperatue"
    end

    test "create_weather/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrology.create_weather(@invalid_attrs)
    end

    test "update_weather/2 with valid data updates the weather" do
      weather = weather_fixture()
      assert {:ok, %Weather{} = weather} = Metrology.update_weather(weather, @update_attrs)
      assert weather.cloudy == false
      assert weather.moisture == "some updated moisture"
      assert weather.temperatue == "some updated temperatue"
    end

    test "update_weather/2 with invalid data returns error changeset" do
      weather = weather_fixture()
      assert {:error, %Ecto.Changeset{}} = Metrology.update_weather(weather, @invalid_attrs)
      assert weather == Metrology.get_weather!(weather.id)
    end

    test "delete_weather/1 deletes the weather" do
      weather = weather_fixture()
      assert {:ok, %Weather{}} = Metrology.delete_weather(weather)
      assert_raise Ecto.NoResultsError, fn -> Metrology.get_weather!(weather.id) end
    end

    test "change_weather/1 returns a weather changeset" do
      weather = weather_fixture()
      assert %Ecto.Changeset{} = Metrology.change_weather(weather)
    end
  end
end
