defmodule Mix.Tasks.CreateInvoiceCsv do
  use Mix.Task

  @shortdoc "Converts Toggl CSV to Xero importable CSV"

  def run(args) do
    {:ok, csv_path} = parse_args(args)

    Mix.shell.info(csv_path)
    Mix.shell.info("File exists?: #{File.exists?(csv_path)}")
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
end
