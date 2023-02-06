defmodule Gateflow.Family.Resources.Parent do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "parents"
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
    has_many :children, Gateflow.Family.Resources.Child
  end

  code_interface do
    define_for Gateflow.Project.Resources
    define :get, action: :read, get_by: [:id]
  end
end
