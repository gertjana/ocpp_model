defmodule OcppModelMessageTest do
  use ExUnit.Case
  doctest OcppModel

  test "term -> %Call" do
    message = [2, 42, "action", %{payload: true}]
    st =  message |> OcppModel.V20.Message.from_message
    assert st == %OcppModel.V20.Message.Call{message_type_id: 2, message_id: 42, action: "action", payload: %{payload: true}}
  end

  test "term -> %CallResult" do
    message = [3, 42, %{payload: true}]

    st =  message |> OcppModel.V20.Message.from_message
    assert st == %OcppModel.V20.Message.CallResult{message_type_id: 3, message_id: 42, payload: %{payload: true}}
  end

  test "term -> %CallError" do
    message = [4, 42, "code", "description", %{}]

    st =  message |> OcppModel.V20.Message.from_message
    assert st == %OcppModel.V20.Message.CallError{message_type_id: 4, message_id: 42, error_code: "code", error_description: "description", error_details: %{}}
  end

end
