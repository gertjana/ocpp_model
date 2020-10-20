defmodule OcppModelTest do
  use ExUnit.Case

  defmodule TestStruct do
    use TypedStruct

    typedstruct do
      field :foo, String.t(), enforce: true
      field :bar, integer()
    end
  end

  test "to_struct convert a map to a struct" do
    map = %{foo: "oof", bar: 42, baz: "Booyah"}
    st = OcppModel.to_struct(TestStruct, map)
    assert st.foo == "oof"
    assert st.bar == 42
    assert ! Map.has_key?(st, :baz)
  end

end
