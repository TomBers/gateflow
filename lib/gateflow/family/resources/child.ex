defmodule Gateflow.Family.Resources.Child do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "children"
    repo Gateflow.Project.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    uuid_primary_key :child_id, primary_key?: false

    attribute :name, :string

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :parent, Gateflow.Family.Resources.Parent
    has_many :children, Gateflow.Family.Resources.Child
  end
end
