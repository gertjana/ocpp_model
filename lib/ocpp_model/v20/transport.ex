defmodule OcppModel.V20.Transport do
  @moduledoc """
    contains structs for the three message types, and helper functions to transform between terms, structs and json

    There are 3 different Message type identified by the message_type_id

    | MessageType | MessageTypeId | Struct | Description |
    | --- | --- | --- | --- |
    | CALL       | 2 | OcppModel.V20.Transport.Call | a request message |
    | CALLRESULT | 3 | OcppModel.V20.Transport.CallResult | a response message |
    | CALLERROR  | 4 | OcppModel.V20.Transport.CallError | an error message |

    The messageId of the message for CallResult, CallError should correspond with that of the request they respond to
  """

  @typedoc false
  @type t() :: %OcppModel.V20.Transport.Call{} |
               %OcppModel.V20.Transport.CallResult{} |
               %OcppModel.V20.Transport.CallError{}
  @typedoc false
  @type message() :: list[any()]

  defmodule Call do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :message_type_id, integer(), default: 2, enforce: true
      field :message_id, String.t(), enforce: true
      field :action, String.t(), enforce: true
      field :payload, Map.t(), enforce: true
    end
  end

  defmodule CallResult do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :message_type_id, integer(), default: 3, enforce: true
      field :message_id, String.t(), enforce: true
      field :payload, Map.t(), enforce: true
    end
  end

  defmodule CallError do
    @moduledoc false
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
    do: %CallError{message_type_id: 4, message_id: message_id, error_code: error_code,
                   error_description: error_description, error_details: error_details}

end
