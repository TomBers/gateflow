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

    update :set_to_not_blocked do
      accept []
      change set_attribute(:state, :not_blocked)
    end

    update :add_child do
      accept []

      argument :child_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:child_id, :children, type: :append)
    end
  end

  attributes do
    uuid_primary_key :id

    # This is the id of the parent a little confusing due to the default naming, but I am not sure how to change it at the moment
    uuid_primary_key :flow_item_id, primary_key?: false

    attribute :title, :string

    attribute :state, :atom do
      constraints one_of: [:blocked, :not_blocked]

      default :not_blocked
      allow_nil? false
    end

    attribute :is_root, :boolean, default: false

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :board, Gateflow.Project.Resources.Board
    # See https://ash-hq.org/docs/dsl/ash/2.5.7/resource/relationships/has_many
    has_many :children, Gateflow.Project.Resources.FlowItem
  end

  # code_interface do
  #   define_for Resources

  #   define :add_child, args: [:child_id]
  # end
end
