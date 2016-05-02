defmodule Mix.Tasks.CreateInvoiceCsv do
  use Mix.Task

  @shortdoc "Converts Toggl CSV to Xero importable CSV"

  def run(args) do
    {:ok, csv_path} = parse_args(args)
    {:ok, output_file} = File.open "converted.csv", [:write]

    parse_csv(csv_path)
    |> Enum.map(&TogglToXeroCSV.convert/1)
    |> add_header
    |> CSV.encode
    |> Enum.each(&IO.write(output_file, &1))

    Mix.shell.info("\n")
    Mix.shell.info("CSV has been converted and output to #{Path.absname "converted.csv"}")
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
  end

  defp add_header(csv) do
    [TogglToXeroCSV.xero_csv_header | csv]
  end
end
