defmodule ExAws.Textract do
  @moduledoc """
  Operations on ExAws Textract
  """
  alias ExAws.Textract.S3Object

  #
  # https://docs.aws.amazon.com/textract/latest/dg/API_Operations.html
  #
  @actions %{
    detect_document_text: :post
  }

  @doc """
  https://docs.aws.amazon.com/textract/latest/dg/API_DetectDocumentText.html

  NOTE: When using an S3Object, you may need to insure that
  the S3 uses the same region as Textract
  """
  @spec detect_document_text(binary() | S3Object.t()) ::
          %ExAws.Operation.JSON{}
  def detect_document_text(source_document) do
    request(:detect_document_text, %{
      "Document" => map_document(source_document)
    })
  end

  # Utility

  defp map_document(document) when is_binary(document) do
    %{"Bytes" => Base.encode64(document)}
  end

  defp map_document(%S3Object{} = object) do
    S3Object.map(object)
  end

  defp request(action, data) do
    http_method = @actions |> Map.fetch!(action)

    operation =
      action
      |> Atom.to_string()
      |> Macro.camelize()

    headers = [
      {"content-type", "application/x-amz-json-1.1"},
      {"x-amz-target", "Textract.#{operation}"}
    ]

    ExAws.Operation.JSON.new(:textract, %{
      http_method: http_method,
      data: data,
      headers: headers
    })
  end
end
