defmodule DynamoQuery do
  alias ExAws.Dynamo
  alias DynamoQuery.Actions.{Meta, Data}
  require Logger

  @attr_expr "_expression"

  def start(_type, _args) do
    IO.puts "starting"
    #desc = Dynamo.describe_table("wwd_dev_bz_administrators") |> ExAws.request!
    #desc = Meta.get_primary_key("bz_administrators")
    #dos = Meta.get_global_indexes("bz_administrators")
    {:ok, pid} = Data.start_link
    data = Dynamo.query(
      "wwd_dev_bz_administrators",
      limit: 1,
      expression_attribute_names: %{"#_id" => "_id", "#profile" => "profile"},
      expression_attribute_values: [_id: "54481b094369d9cea9535955", profile_expression: "Developer"],
      key_condition_expression: "#_id = :_id",
      filter_expression:  "#profile = :profile_expression"
    ) |> ExAws.request!
    
    query(pid, "wwd_dev_bz_administrators")
    add_key_condition(pid, "_id", "54481b094369d9cea9535955")
    add_filter(pid, "profile", "Developer")
    #data = get_struct(pid)

    IO.inspect data

    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end

  def query(pid, table_name) do
    Data.add(pid, "table_name", table_name)
  end
  
  def add_key_condition(pid, field, value) do
    with_expr = field <> @attr_expr
    Data.add(pid, "key_condition_expression", "#" <> field <> " = :" <> with_expr)
    Data.add(pid, "expression_attribute_values", ["#{with_expr}": value])
    Data.add(pid, "expression_attribute_names", %{"#" <> field => field})
  end

  def add_filter(pid, field, value, comparison \\ "=", operator \\ "and") do
    with_expr = field <> @attr_expr
    
    if !Data.has_key(pid, "filter_expression") do
      Data.add(pid, "filter_expression", "#" <> field <> " #{comparison} :" <> field <> @attr_expr)
    else
      old_filter = Data.get(pid, "filter_expression")
      new_filter = old_filter <> " operator " <> "#" <> field <> " = :" <> field <> @attr_expr
      Data.update(pid, "filter_expression", new_filter)
    end

    if Data.has_key(pid, "expression_attribute_values") == false do
      Data.add(pid, "expression_attribute_values", ["#{with_expr}": value])
    else
      old_list = Data.get(pid, "expression_attribute_values")
      new_list = old_list ++ ["#{with_expr}": value]
      Data.update(pid, "expression_attribute_values", new_list)
    end

    if Data.has_key(pid, "expression_attribute_names") == false do
      Data.add(pid, "expression_attribute_names", %{"#" <> field => field})
    else
      old_map = Data.get(pid, "expression_attribute_names")
      new_map = Map.merge(old_map, %{"#" <> field => field})
      Data.update(pid, "expression_attribute_names", new_map)
    end
  end

  def count(pid) do
    Data.add(pid, "select", :count)
  end

  def sort(pid, sort) do
    accending =
      case sort do
        true -> 1
        1 -> 1
        _ -> 0 
      end
    Data.add(pid, "scan_index_forward", accending)
  end

  def get_struct(pid) do
    Data.get_all(pid)
  end

  def add_limit(pid, limit) do
    Data.add(pid, "limit", limit)
  end

  def get() do
    
  end
end
