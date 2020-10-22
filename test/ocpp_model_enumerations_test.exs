defmodule OcppModelEnumerationsTest do
  use ExUnit.Case

  alias OcppModel.V20.EnumTypes, as: ET

  test "valid enumeration" do
    assert ET.validate?(:TriggerReasonEnumType, "MeterValuePeriodic")
  end

  test "wrong key enumeration" do
    assert ! ET.validate?(:UnknownEnumType, "Accepted")
  end

  test "wrong value enumeration" do
    assert ! ET.validate?(:OperationalStatusEnumType, "CertificateExpired")
  end

  test "get all enum types" do
    assert %{} = ET.get()
  end

  test "get a single enum type" do
    assert ["SHA256", "SHA384", "SHA512"] == ET.get(:HashAlgorithmEnumType)
  end

  test "get an unknown enum type" do
    assert nil == ET.get(:FooBar)
  end
end
