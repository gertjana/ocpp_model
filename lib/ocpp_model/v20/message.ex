defmodule OcppModel.V20.Message do
  @moduledoc """
    contains struct for the three message type, and helper functions to transform between terms, structs and json

    There are 3 different Message type identified by the message_type_id

    | MessageType | MessageTypeId | Struct | Description |
    | --- | --- | --- | --- |
    | CALL       | 2 | `%OcppModel.Message.Call{}` | a request message |
    | CALLRESULT | 3 | `%OcppModel.Message.CallResult{}` | a response message |
    | CALLERROR  | 4 | `%OcppModel.Message.CallError{}` | an error message |

    The messageId of the message for CallResult and CallError should correspond with that of the request they respond to
  """
  # import OcppModel.V20

  @type t() :: %OcppModel.V20.Message.Call{} | %OcppModel.V20.Message.CallResult{} | %OcppModel.V20.Message.CallError{}
  @type message() :: list[any()]

  defmodule Call do
    use TypedStruct

    typedstruct do
      field :message_type_id, integer(), default: 2, enforce: true
      field :message_id, String.t(), enforce: true
      field :action, String.t(), enforce: true
      field :payload, Map.t(), enforce: true
    end
  end

  defmodule CallResult do
    use TypedStruct

    typedstruct do
      field :message_type_id, integer(), default: 3, enforce: true
      field :message_id, String.t(), enforce: true
      field :payload, Map.t(), enforce: true
    end
  end

  defmodule CallError do
    use TypedStruct

    typedstruct do
      field :message_type_id, integer(), default: 4, enforce: true
      field :message_id, String.t(), enforce: true
      field :error_code, String.t(), enforce: true
      field :error_description, String.t(), enforce: true
      field :error_details, Map.t(), enforce: true
    end
  end

  @spec to_message(Message.t()) :: Message.message()
  def to_message(%Call{} = st),       do: [2, st.message_id, st.action, st.payload]
  def to_message(%CallResult{} = st), do: [3,  st.message_id, st.payload]
  def to_message(%CallError{} = st),  do: [4, st.message_id, st.error_code, st.error_description, st.error_details]

  @spec from_message(message()) :: Message.t()
  def from_message([2, message_id, action, payload]),
    do: %Call{message_type_id: 2, message_id: message_id, action: action, payload: payload}
  def from_message([3, message_id, payload]),
    do: %CallResult{message_type_id: 3, message_id: message_id, payload: payload}
  def from_message([4, message_id, error_code, error_description, error_details]),
    do: %CallError{message_type_id: 4, message_id: message_id, error_code: error_code, error_description: error_description, error_details: error_details}




end
