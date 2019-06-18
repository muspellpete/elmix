defmodule Elmix.Repo.Migrations.CreateSamples do
  use Ecto.Migration

  def change do
    create table(:samples) do
     add :temperatue, :integer
     add :moisture, :integer
     add :cloudy, :boolean, default: false, null: false
    
     timestamps()
    end

  end
end
