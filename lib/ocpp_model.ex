defmodule OcppModel do
  @moduledoc """
    OcppModel Module: Contains helper functions
  """

  @spec to_struct(map, atom | struct()) :: struct()
  @doc """
    Converts a Map into a struct of the given kind
  """
  def to_struct(map, kind) when is_map(map) do
    struct = struct(kind)
    map_to_struct = fn {k, _}, acc ->
      case Map.fetch(map, k) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
    struct |> Map.to_list |> Enum.reduce(struct, map_to_struct)
  end

  @spec to_map!(struct()) :: map()
  @doc """
    Converts a struct into a map including nested structs
  """
  def to_map!(st) when is_struct(st) do
    struct_to_map = fn({k, v}, acc) ->
      cond do
        is_struct(v) -> Map.put_new(acc, k, to_map!(v))
        is_nil(v) -> acc
        true -> Map.put_new(acc, k, v)
      end
    end
    st |> Map.from_struct |> Enum.reduce(%{}, struct_to_map)
  end

  @spec to_map({:ok, struct()} | {:error, atom(), String.t()}) :: {:ok, map()} | {:error, atom(), String.t()}
  @doc """
    same as `to_map!()` but takes an `{:ok, struct()}` and returns an `{:ok, map()}`

    in case of een `{:error, atom(), String.t()}` argument it will let it pass through
  """
  def to_map({:ok, st}) when is_struct(st), do: {:ok, to_map!(st)}
  def to_map({:error, error, desc}), do: {:error, error, desc}
end
