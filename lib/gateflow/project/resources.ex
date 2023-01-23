defmodule Gateflow.Project.Resources do
  use Ash.Api, extensions: [AshAdmin.Api]

  resources do
    registry Gateflow.Project.Registry
  end

  admin do
    show?(true)
  end
end
