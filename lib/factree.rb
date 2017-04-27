module Factree
  autoload :Aggregate, "factree/aggregate"
  autoload :Conclusion, "factree/conclusion"
  autoload :DSL, "factree/dsl"
  autoload :Facts, "factree/facts"
  autoload :FactsSpy, "factree/facts_spy"
  autoload :Path, "factree/path"
  autoload :Pathfinder, "factree/pathfinder"
  autoload :VERSION, "factree/version"

  extend DSL
end
