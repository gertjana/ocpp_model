defmodule OcppModel.V20.FieldTypes do
  defmodule AdditionalInfoType do
    use TypedStruct

    typedstruct do
      field :additionalIdToken, String.t(), enforce: true             # 0..36 identifierString
      field :type, String.t(), enforce: true                          # 0..50
    end
  end

  defmodule ChargingStationType do
    use TypedStruct

    typedstruct do
    field :serialNumber, String.t()  # 0..25
    field :model, String.t(), enforce: true # 0..20
    field :vendorName, String.t(), enforce: true  # 0..50
    field :firmwareVersion, String.t()  # 0..50
    field :modem, ModemType.t()
    end
  end

  defmodule EvseType do
    use TypedStruct

    typedstruct do
      field :id, integer(), enforce: true
      field :connector_id, integer()
    end
  end

  defmodule IdTokenType do
    use TypedStruct

    typedstruct do
      field :idToken, String.t(), enforce: true                     # 0..36
      field :type, String.t(), enforce: true                        # IdTokenEnumType
      field :additionalInfo, List[AdditionalInfoType.t()]
    end
  end

  defmodule IdTokenInfoType do
    use TypedStruct

    typedstruct do
      field :status, String.t() # AuthorizationStatusEnumType
    end

  end

  defmodule ModemType do
    use TypedStruct

    typedstruct do
      field :iccid, String.t() # 0..20
      field :imsi, String.t() # 0..20
    end
  end

  defmodule OCSPRequestDataType do
    use TypedStruct

    typedstruct do
      field :hashAlgorithm, String.t(), enforce: true                 # HashAlgorithmEnumType
      field :issuerNameHash, String.t(), enforce: true                # 0..512
      field :issuerKeyHash, String.t(), enforce: true                 # 0..128
      field :serialNumber, String.t(), enforce: true                  # 0..40
      field :responderURL, String.t(), enforce: true                  # 0..512
    end
  end

  defmodule StatusInfoType do
    use TypedStruct

    typedstruct do
      field :reasonCode, String.t(), enforce: true # 0..20
      field :additionalInfo, String.t() # 0..512
    end
  end
end
