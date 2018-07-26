defmodule DynamoQuery.Actions.Meta do
    alias DynamoQuery.Actions.Data
    alias ExAws.Dynamo
    require Logger
    @table_prefix "wwd_dev_"

    def get_description(table_name) do
        table_description = Dynamo.describe_table(
            @table_prefix <> table_name
        ) |> ExAws.request!
        table_description
    end
    
    def get_primary_key(table_name) do
        table = get_table_item(table_name)
        Map.get(table, "KeySchema")
    end

    def get_attributes(table_name) do
        table = get_table_item(table_name)
        Map.get(table, "AttributeDefinitions")
    end

    def get_global_indexes(table_name) do
        table = get_table_item(table_name)
        indexes = Map.get(table, "GlobalSecondaryIndexes")
        list = []
        for item <- indexes, do: list ++ %{"name" => List.first(Map.get(item, "KeySchema")), "index" => Map.get(item, "IndexName")}
    end

    def get_table_item(table_name) do
        table_description = get_description(table_name)
        Map.get(table_description, "Table")
    end
end