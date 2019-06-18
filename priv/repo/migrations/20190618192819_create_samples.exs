defmodule Elmix.Repo.Migrations.CreateSamples do
  use Ecto.Migration

  def change do
    create table(:samples) do
      add :temperatue, :string
      add :moisture, :string
      add :cloudy, :boolean, default: false, null: false

      timestamps()
    end

  end
end
