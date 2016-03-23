defmodule Mix.Tasks.CreateInvoiceCsv do
  use Mix.Task

  @shortdoc "Converts Toggl CSV to Xero importable CSV"

  def run(args) do
    {:ok, csv_path} = parse_args(args)
    {:ok, file} = File.open "test.csv", [:write]
    parse_csv(csv_path)
    |> add_header
    |> CSV.encode
    |> Enum.each(&IO.write(file, &1))
  end

  defp parse_args([csv_path]) do
    path = Path.expand(csv_path)
    case File.exists?(path) do
      true ->
        {:ok, path}
      false ->
        {:error, "No file found at that path."}
    end
  end

  defp parse_csv(csv_path) do
    File.stream!(csv_path)
    |> CSV.decode(headers: true)
    |> Enum.map(&TogglToXeroCSV.convert/1)
  end

  defp add_header(csv) do
    [TogglToXeroCSV.xero_csv_header | csv]
  end
end
