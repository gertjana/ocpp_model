defmodule OcppModelTransportTest do
  use ExUnit.Case

  alias OcppModel.V20.Transport, as: T

  test "term -> %Call -> term" do
    message = [2, 42, "action", %{payload: true}]
    st =  message |> T.from_message
    assert st == %T.Call{message_type_id: 2, message_id: 42, action: "action", payload: %{payload: true}}

    result = st |> T.to_message
    assert result == message
  end

  test "term -> %CallResult -> term" do
    message = [3, 42, %{payload: true}]

    st =  message |> T.from_message
    assert st == %T.CallResult{message_type_id: 3, message_id: 42, payload: %{payload: true}}

    result = st |> T.to_message
    assert result == message
  end

  test "term -> %CallError -> term" do
    message = [4, 42, "code", "description", %{}]

    st =  message |> T.from_message
    assert st == %T.CallError{message_type_id: 4, message_id: 42, error_code: "code",
                              error_description: "description", error_details: %{}}
    result = st |> T.to_message
    assert result == message
  end
end
