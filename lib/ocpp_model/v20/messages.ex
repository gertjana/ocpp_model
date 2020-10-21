defmodule OcppModel.V20.Messages do
  @moduledoc """
    OCPP 2.0 message structs
  """
  alias OcppModel.V20.FieldTypes, as: FT

  defmodule AuthorizeRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      # field :certificate, String.t()                                    # 0..5500
      field :idToken, FT.IdTokenType.t(), enforce: true
      # field :iso15118CertificateHashData, OCSPRequestDataType.t()       # 0..4 ??
    end
  end

  defmodule AuthorizeResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      # field :certificateStatus, String.t() # AuthorizeCertificateStatusEnumType
      field :idTokenInfo, FT.IdTokenInfoType.t(), enforce: true
    end
  end

  defmodule BootNotificationRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :reason, String.t(), enforce: true # BootReasonEnumType
      field :chargingStation, FT.ChargingStationType.t(), enforce: true
    end
  end

  defmodule BootNotificationResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :currentTime, String.t(), enforce: true # dateTime
      field :interval, integer(), enforce: true
      field :status, String.t(), enforce: true # RegistrationStatusEnumType
      field :statusInfo, StatusInfoType.t()
    end
  end

  defmodule ChangeAvailabilityRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :operationalStatus, String.t(), enforce: true # OperationalStatusEnumType
      field :evse, EvseType.t()
    end
  end

  defmodule ChangeAvailabilityResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :status, String.t(), enforce: true # ChangeAvailabilityStatusEnumType
      field :statusInfo, FT.StatusInfoType.t()
    end

  end
  defmodule HeartbeatRequest do
    @moduledoc false
    use TypedStruct

      typedstruct do
        # no fields
      end
  end

  defmodule HeartbeatResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :currentTime, String.t(), enforce: true, default: ""
    end
  end

  defmodule StatusNotificationRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :timestamp, String.t(), enforce: true # dateTime
      field :connectorStatus, String.t(), enforce: true # ConnectorStatusEnumType
      field :evseId, integer(), enforce: true
      field :connectorId, integer(), enforce: true
    end
  end

  defmodule StatusNotificationResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
    end
  end

  defmodule TransactionEventRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :eventType, String.t(), enforce: true # TransactionEventEnumType
      field :timestamp, String.t(), enforce: true # dateTime
      field :triggerReason, String.t(), enforce: true # TriggerreasonEnumType
      field :seqNo, integer(), enforce: true
      field :transactionInfo, FT.TransactionType.t(), enforce: true
      field :idToken, FT.IdTokenType.t()
      field :evse, FT.EvseType.t()
      field :meterValue, FT.MeterValueType.t()
      # some optional fields left out for now
    end
  end

  defmodule TransactionEventResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      #all fields optional, left out for now
    end
  end

  defmodule UnlockConnectorRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :evseId, integer(), enforce: true
    end
  end

  defmodule UnlockConnectorResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :status, String.t(), enforce: true # UnlockStatusEnumType
      field :statusInfo, FT.StatusInfoType.t()
    end
  end
end
