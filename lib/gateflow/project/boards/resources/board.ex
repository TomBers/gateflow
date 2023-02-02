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

  code_interface do
    define_for Gateflow.Project.Resources
    define :get, action: :read, get_by: [:id]
  end

  aggregates do
    count :num_blocked, :flow_items do
      filter expr(state == :blocked)
    end

    count :num_not_blocked, :flow_items do
      filter expr(state == :not_blocked)
    end
  end

  calculations do
    calculate :nick_name, :string, expr(name <> "_board")
    calculate :test_length, :integer, expr(length([1, 2, 3]))
  end
end
