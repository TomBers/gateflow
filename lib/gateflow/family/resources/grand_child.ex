defmodule Gateflow.Family.Resources.GrandChild do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "grand_children"
    repo Gateflow.Project.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :parent, Gateflow.Family.Resources.Child
  end
end
