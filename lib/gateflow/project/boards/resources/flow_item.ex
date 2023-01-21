defmodule Gateflow.Project.Resources.FlowItem do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "flowitems"
    repo Gateflow.Project.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    update :set_to_blocked do
      accept []
      change set_attribute(:state, :blocked)
    end

    update :add_parent do
      accept []

      argument :parent_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:parent_id, :parents, type: :append)
    end
  end

  attributes do
    uuid_primary_key :id
    uuid_primary_key :flow_item_id, primary_key?: false

    attribute :title, :string

    attribute :state, :atom do
      constraints one_of: [:blocked, :not_blocked]

      default :not_blocked
      allow_nil? false
    end
  end

  relationships do
    belongs_to :board, Gateflow.Project.Resources.Board
    has_many :parents, Gateflow.Project.Resources.FlowItem
  end
end
