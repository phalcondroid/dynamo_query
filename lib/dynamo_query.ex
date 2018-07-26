defmodule DynamoQuery do
  alias ExAws.Dynamo
  alias DynamoQuery.Actions.{Meta}
  require Logger

  @agent_pid Agent.start_link fn -> %{} end

  def start(_type, _args) do
    IO.puts "starting"
    #desc = Dynamo.describe_table("wwd_dev_bz_administrators") |> ExAws.request!
    #desc = Meta.get_primary_key("bz_administrators")
    dos = Meta.get_global_indexes("bz_administrators")
    Logger.info "->-> " <> inspect(dos)
    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end

  def query(table_name) do
    #Data.add(get_pid(), "TableName", table_name)
  end
  
  def add_key_condition(field, value) do
    #Dynamo.describe_table("wwd_dev_bz_administrators") 
  end

  def add_filter(field, value, operator \\ "$and") do

  end

  def count() do
    #Data.add(get_pid(), "Select", "COUNT")
  end

  def sort(sort) do
    accending =
      case sort do
        true -> 1
        1 -> 1
        _ -> 0 
      end
    #Data.add(get_pid(), "ScanIndexForward", accending)
  end

  defp resolve_attribute_names() do
    
  end

  defp resolve_attribute_values() do
    
  end

  def get_struct() do
    resolve_attribute_names()
    resolve_attribute_values()
    #Data.get_all(get_pid())
  end

  def add_limit(limit) do
    #Data.add(get_pid(), "Limit", limit)
  end

  def get() do
    
  end

  def get_pid() do
    {_, pid} = @agent_pid
    pid
  end
end
