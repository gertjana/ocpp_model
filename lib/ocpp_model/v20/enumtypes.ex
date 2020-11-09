defmodule OcppModel.V20.EnumTypes do
  @moduledoc """
    Contains a map of all EnumTypes that are used in the currently supported messages, with a function to validate if a value is part of the EnumType
  """
  @enum_types %{
    authorizeCertificateStatusEnumType: ["Accepted", "SignatureError", "CertificateExpired", "NoCertificateAvailable",
                                            "CertChainError", "CertificateRevoked", "ContractCancelled"],
    authorizationStatusEnumType:        ["Accepted ", "Blocked ", "ConcurrentTx", "Expired", "Invalid", "NoCredit",
                                            "NotAllowedTypeEVSE", "NotAtThisLocation", "NotAtThisTime", "Unknown"],
    bootReasonEnumType:                 ["ApplicationReset", "FirmwareUpdate", "LocalReset", "PowerUp", "RemoteReset",
                                            "ScheduledReset", "Triggered", "Unknown",  "Watchdog"],
    changeAvailabilityStatusEnumType:   ["Accepted", "Rejected", "Scheduled"],
    chargingStateEnumType:              ["Charging", "SuspendedEV", "SuspendedEVSE", "Idle"],
    connectorStatusEnumType:            ["Available", "Occupied", "Reserved", "Faulted"],
    dataTransferStatusEnum:             ["Accepted", "Rejected", "UnknownMessageId", "UnknownVendorId"],
    hashAlgorithmEnumType:              ["SHA256", "SHA384", "SHA512"],
    idTokenEnumType:                    ["Central", "eMAID", "ISO14443", "ISO15693", "KeyCode", "Local ",
                                            "MacAddress ", "NoAuthorization"],
    locationEnumType:                   ["Body", "Cable", "EV", "Inlet", "Outlet"],
    measurerandEnumType:                ["Current.Export", "Current.Import", "Current.Offered",
                                            "Energy.Active.Export.Register", "Energy.Active.Import.Register",
                                            "Energy.Reactive.Export.Register", "Energy.Reactive.Import.Register",
                                            "Energy.Active.Export.Interval", "Energy.Active.Import.Interval",
                                            "Energy.Active.Net", "Energy.Reactive.Export.Interval",
                                            "Energy.Reactive.Import.Interval", "Energy.Reactive.Net",
                                            "Energy.Apparent.Net", "Energy.Apparent.Import", "Energy.Apparent.Export",
                                            "Frequency", "Power.Active.Export", "Power.Active.Import", "Power.Factor",
                                            "Power.Offered", "Power.Reactive.Export", "Power.Reactive.Import", "SoC",
                                            "Voltage"],
    messageFormatEnumType:              ["ASCII", "HTML", "URI", "UTF8"],
    operationalStatusEnumType:          ["Inoperative", "Operative"],
    phaseEnumType:                      ["L1", "L2", "L3", "N", "L1-N", "L2-N", "L3-N", "L1-L2", "L2-L3", "L3-L1"],
    readingContextEnumType:             ["Interruption.Begin", "Interruption.End ", "Other ", "Sample.Clock ",
                                            "Sample.Periodic"],
    reasonEnumType:                     ["DeAuthorized", "EmergencyStop", "EnergyLimitReached", "EVDisconnected",
                                            "GroundFault", "ImmediateReset", "Local", "LocalOutOfCredit", "MasterPass",
                                            "Other", "OvercurrentFault", "PowerLoss", "PowerQuality", "Reboot", "Remote",
                                            "SOCLimitReached", "StoppedByEV", "TimeLimitReached", "Timeout"],
    registrationStatusEnumType:         ["Accepted", "Pending", "Rejected"],
    transactionEventEnumType:           ["Ended", "Started", "Updated"],
    triggerReasonEnumType:              ["Authorized", "CablePluggedIn", "ChargingRateChanged", "ChargingStateChanged",
                                            "EnergyLimitReached", "EVCommunicationLost", "EVConnectTimeout",
                                            "MeterValueClock", "MeterValuePeriodic", "TimeLimitReached", "Trigger",
                                            "UnlockCommand", "StopAuthorized", "EVDeparted", "EVDetected", "RemoteStop",
                                            "RemoteStart", "AbnormalCondition", "SignedDataReceived", "ResetCommand"],
    unlockStatusEnumType:               ["Unlocked", "UnlockFailed", "OngoingAuthorizedTransaction",
                                            "UnknownConnector"],
  }

  @spec validate?(atom(), String.t())  :: boolean
  def validate?(enum_type, value) do
    case Map.get(@enum_types, enum_type) do
      nil -> false
      values -> Enum.member?(values, value)
    end
  end

  @spec get(atom() | nil)  ::  %{} | list(String.t() | nil)
  def get(item \\ nil) do
    case item do
      nil -> @enum_types
      item -> Map.get(@enum_types, item)
    end
  end
end
