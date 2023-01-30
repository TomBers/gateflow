defmodule Gateflow.Project.Resources.Board do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "boards"
    repo Gateflow.Project.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    update :add_flow_item do
      accept []

      argument :flow_item_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:flow_item_id, :flow_items, type: :append)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string

    create_timestamp :inserted_at
  end

  relationships do
    has_many :flow_items, Gateflow.Project.Resources.FlowItem
  end
end
