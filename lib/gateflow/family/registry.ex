defmodule Gateflow.Family.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Gateflow.Family.Resources.Parent
    entry Gateflow.Family.Resources.Child
    entry Gateflow.Family.Resources.GrandChild
  end
end
