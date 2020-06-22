defmodule HowToDrawDownload do
  def download_instructions do
    get_image_links = fn link -> link |> get_links_in_page("div.separator a") end

    IO.write "Getting image links :"
    image_links = home_page()
    |> get_links_in_page("div.post-body span a")
    |> Enum.map(&Task.async(fn -> get_image_links.(&1) end))
    |> Task.yield_many(500_000)
    |> Enum.reduce([], fn
      {_task, {:ok, res}}, acc -> [res | acc]
      {_task, _res}, acc -> acc
    end)
    |> Enum.flat_map(&(&1))

    IO.puts ""
    IO.write "Saving images :"
    image_links
    |> Enum.filter(&(&1 |> String.contains?(".jpg")))
    |> Enum.map(&save_image/1)
  end

  defp get_links_in_page(page, path) do
    page
    |> redirect_to_com
    |> get_data
    |> show_status
    |> Floki.parse_document!
    |> Floki.find(path)
    |> Floki.attribute("href")
    |> Enum.uniq
  end

  defp show_status(data) do
    IO.write "."
    data
  end

  defp save_image(link) do
    image_path = link |> String.split("/") |> List.last() |> String.replace("%2B", "_")
    path = Path.relative_to_cwd("./instructions/" <> image_path)
    File.write!(path, link |> get_data |> show_status())
  end

  defp get_data(link) do
    %HTTPoison.Response{body: body} =
      HTTPoison.get!(link, [], timeout: 50_000, recv_timeout: 50_000)

    body
  end

  defp redirect_to_com(link), do: link |> String.replace("co.uk", "com")

  defp home_page do
  "url"
  end
end
