defmodule OcppModel do
  @moduledoc """
    OcppModel Module: Contains helper functions
  """
  #@type struct() :: %{:__struct__ => atom, optional(atom) => any}

  # @spec to_struct(map, struct()) :: struct()
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
  def to_map({:ok, st}) when is_struct(st), do: {:ok, to_map!(st)}
  def to_map({:error, error, desc}), do: {:error, error, desc}
end
