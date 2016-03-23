defmodule TogglToXeroCSVTest do
  use ExUnit.Case, async: true
  doctest TogglToXeroCSV

  setup do
    row = %{"Amount ()" => "", "Billable" => "No", "Client" => "Feldpost",
      "Description" => "Work on page builder and sparkle front end integrations",
      "Duration" => "08:00:00", "Email" => "matthew@mpl.io",
      "End date" => "2016-03-02", "End time" => "17:00:00", "Project" => "CMS",
      "Start date" => "2016-03-02", "Start time" => "09:00:00", "Tags" => "",
      "Task" => "", "User" => "Matthew"}
    {:ok, [row: row]}
  end

  test "gets inventory_item_code", context do
    assert TogglToXeroCSV.inventory_item_code(context[:row]) == "CMS"
  end

  test "gets description", context do
    row = context[:row]
    start_date = Map.fetch!(row, "Start date")
    description = Map.fetch!(row, "Description")
    full_description = "#{start_date} - #{description}"
    assert TogglToXeroCSV.description(row) == full_description
  end

  test "gets started_at", context do
    start_time = TogglToXeroCSV.started_at(context[:row])
    check_time = Timex.DateTime.from({{2016, 3, 2}, {9, 0, 0}})
    assert Timex.equal? start_time, check_time
  end

  test "gets ended_at", context do
    end_time = TogglToXeroCSV.ended_at(context[:row])
    check_time = Timex.DateTime.from({{2016, 3, 2}, {17, 0, 0}})
    assert Timex.equal? end_time, check_time
  end

  test "gets duration", context do
    starts = TogglToXeroCSV.started_at(context[:row])
    ends = TogglToXeroCSV.ended_at(context[:row])
    control_duration = Timex.Interval.new(from: starts, until: ends)
    |> Timex.Interval.duration(:hours)

    assert TogglToXeroCSV.duration(context[:row]) == control_duration
  end
end
