defmodule Gateflow.Project.Resources do
  use Ash.Api

  resources do
    registry Gateflow.Project.Registry
  end
end
