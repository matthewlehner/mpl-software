defmodule TogglToXeroCSV do
  def convert(row) do
    [ "Feldpost",
      "sebastian@feldpost.com",
      "1523 N Elk Grove",
      "Suite 2",
      "",
      "",
      "Chicago",
      "IL",
      "60622",
      "USA",
      "INV-0089", # Invoice Number
      "", # Total
      "Mar 16, 2016", # Invoice Date
      "April 30, 2016", # Due Date
      "", # Total
      inventory_item_code(row), # InventoryItemCode
      description(row),
      duration(row), #Quantity
      "150", # Unit Amount
      "", # Discount
      "4000", # Account Code
      "Tax on Sales", # Tax Type
      "", # Tax Amount
      "Client", # Tracking Name 1
      "Scripps", # Tracking Option 1
      "", # Tracking Name 2
      "", # Tracking Option 2
      "USD", # Currency
      "USD Invoice" # BrandingTheme
    ]
  end

  def inventory_item_code(row) do
    Map.fetch!(row, "Project")
  end

  def description(row) do
    "#{Map.fetch!(row, "Start date")} - #{Map.fetch!(row, "Description")}"
  end

  def started_at(row) do
    parse_toggl_time(row, "Start")
  end

  def ended_at(row) do
    parse_toggl_time(row, "End")
  end

  def duration(row) do
    Timex.Interval.new(from: TogglToXeroCSV.started_at(row), until: ended_at(row))
    |> Timex.Interval.duration(:hours)
  end

  defp parse_toggl_time(row, map_location) do
    {:ok, date} = Map.fetch(row, "#{map_location} date")
    {:ok, time} = Map.fetch(row, "#{map_location} time")
    Timex.parse!("#{date}T#{time}", timex_format_string)
  end

  defp timex_format_string do
    "{WYYYY}-{0M}-{D}T{h24}:{m}:{s}"
  end

  def xero_csv_header do
    [ "*ContactName",
      "EmailAddress",
      "POAddressLine1",
      "POAddressLine2",
      "POAddressLine3",
      "POAddressLine4",
      "POCity",
      "PORegion",
      "POPostalCode",
      "POCountry",
      "*InvoiceNumber",
      "Reference",
      "*InvoiceDate",
      "*DueDate",
      "Total",
      "InventoryItemCode",
      "*Description",
      "*Quantity",
      "*UnitAmount",
      "Discount",
      "*AccountCode",
      "*TaxType",
      "TaxAmount",
      "TrackingName1",
      "TrackingOption1",
      "TrackingName2",
      "TrackingOption2",
      "Currency",
      "BrandingTheme" ]
  end
end
