defmodule OcppModelTest do
  use ExUnit.Case

  alias OcppModel.V20.FieldTypes, as: FT
  alias OcppModel.V20.Messages, as: M

  defmodule TestStruct do
    use TypedStruct

    typedstruct do
      field :foo, String.t(), enforce: true
      field :bar, integer()
    end
  end

  test "that to_struct converts a map to a struct" do
    map = %{foo: "oof", bar: 42, baz: "Booyah"}
    st = OcppModel.to_struct(map, TestStruct)
    assert st.foo == "oof"
    assert st.bar == 42
    assert ! Map.has_key?(st, :baz)
  end

  test "that to_map converts a struct with optional nested structs to a map" do
    st = %M.AuthorizeResponse{idTokenInfo: %FT.IdTokenInfoType{status: "Accepted"}}
    assert %{idTokenInfo: %{status: "Accepted"}} == OcppModel.to_map!(st)
    assert {:ok, %{idTokenInfo: %{status: "Accepted"}}} == OcppModel.to_map({:ok, st})
  end

  test "that passing an error to to_map results in the same error" do
    error = {:error, :some_error, "Something made a boo boo"}
    assert error == OcppModel.to_map(error)
  end

  test "that empty values are not skipped when skip_empty is set to false" do
    st = %TestStruct{foo: "Foo"}
    map = OcppModel.to_map!(st, false)
    assert %{foo: "Foo", bar: nil} == map
  end
end
