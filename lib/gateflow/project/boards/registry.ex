defmodule Gateflow.Project.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Gateflow.Project.Resources.Board
    entry Gateflow.Project.Resources.FlowItem
  end
end
