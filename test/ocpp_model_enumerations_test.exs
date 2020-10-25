defmodule OcppModelEnumerationsTest do
  use ExUnit.Case

  alias OcppModel.V20.EnumTypes, as: ET

  test "valid enumeration" do
    assert ET.validate?(:triggerReasonEnumType, "MeterValuePeriodic")
  end

  test "wrong key enumeration" do
    assert ! ET.validate?(:unknownEnumType, "Accepted")
  end

  test "wrong value enumeration" do
    assert ! ET.validate?(:operationalStatusEnumType, "CertificateExpired")
  end

  test "get all enum types" do
    assert %{} = ET.get()
  end

  test "get a single enum type" do
    assert ["SHA256", "SHA384", "SHA512"] == ET.get(:hashAlgorithmEnumType)
  end

  test "get an unknown enum type" do
    assert nil == ET.get(:foo)
  end
end
