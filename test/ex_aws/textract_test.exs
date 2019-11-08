defmodule ExAws.TextractTest do
  use ExUnit.Case, async: true
  doctest ExAws.Textract

  test "detect document text" do
    {:ok, image_binary} = File.read("test/assets/test.png")

    assert {:ok, %{"Blocks" => _}} =
             ExAws.Textract.detect_document_text(image_binary)
             |> ExAws.request(region: "us-east-1")
  end
end
