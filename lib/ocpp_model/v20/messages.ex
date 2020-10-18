defmodule OcppModel.V20.Messages do
  import OcppModel.V20.FieldTypes

  # @authorize_certificate_status ["Accepted", "SignatureError", "CertificateExpired", "NoCertificateAvailab", "CertChainError", "CertificateRevoked", "ContractCancelled"]
  # @boot_reason ["ApplicationReset", "FirmwareUpdate", "LocalReset", "PowerUp",  "RemoteReset", "ScheduledReset", "Triggered", "Unknown",  "Watchdog"]
  # @unlock_status ["Unlocked", "UnlockFailed", "OngoingAuthorizedTransaction", "UnknownConnector"]
  # @operational_status ["Inoperative", "Operative"]


  defmodule AuthorizeRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      # field :certificate, String.t()                                    # 0..5500
      field :idToken, IdTokenType.t(), enforce: true
      # field :iso15118CertificateHashData, OCSPRequestDataType.t()       # 0..4 ??
    end
  end

  defmodule AuthorizeResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      # field :certificateStatus, String.t() # AuthorizeCertificateStatusEnumType
      field :idTokenInfo, IdTokenInfoType.t(), enforce: true
    end
  end

  defmodule BootNotificationRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :reason, String.t(), enforce: true # BootReasonEnumType
      field :chargingStation, ChargingStationType.t(), enforce: true
    end
  end

  defmodule BootNotificationResponse do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :currentTime, String.t(), enforce: true # dateTime
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
      field :statusInfo, StatusInfoType.t()
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

  defmodule TransactionEventRequest do
    @moduledoc false
    use TypedStruct

    typedstruct do
      field :eventType, String.t(), enforce: true # TransactionEventEnumType
      field :timestamp, String.t(), enforce: true # dateTime
      field :triggerReason, String.t(), enforce: true # TriggerreasonEnumType
      field :seqNo, integer(), enforce: true
      field :transactionInfo, TransactionType.t(), enforce: true
      # optional fields left out for now
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
      field :statusInfo, StatusInfoType.t()
    end
  end

end
