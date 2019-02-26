defmodule Zoho.Leads do

  @loc "Leads"
  @resource Zoho.Lead
  use Zoho.Resource

  def postendpoint do
    "/#{@loc}/insertRecords?authtoken=#{auth_key()}&scope=crmapi&xmlData="
  end

  def searchendpoint(email) do
    "/#{@loc}/getSearchRecordsByPDC?authtoken=#{auth_key()}&scope=crmapi&newFormat=1selectColumns=Leads(LEADID,Lead Source)&searchColumn=email&searchValue=#{email}"
  end

  #clean up strange data format
  def get_clean(params \\ %{}) do
    data = Zoho.Leads.get(params)
    clean_result(data)
  end

  def search(params \\ %{}) do
    raw_get(params).data
  end

  def raw_search(params\\%{}) do
    build_path(searchendpoint(params["email"]), params)
    |> Zoho.get
    |> Zoho.Response.new(%{as: @resource()})
  end

  def search_clean(params \\ %{}) do
    data = Zoho.Leads.search(params)
    clean_result(data)
  end

  def clean_result(data) do
    top = data.response["result"]["Leads"]["row"]
    cond do
      is_list(top) ->
        top
        |> Enum.map(fn(y) -> Enum.map(y["FL"], fn(x) -> %{x["val"] => x["content"]} end) end)
        |> Enum.map(fn(y) -> Enum.reduce(y, %{}, fn (map, acc) -> Map.merge(acc, map) end) end)
      !is_nil(top["FL"]) ->
        Enum.map(top["FL"], fn(x) -> %{x["val"] => x["content"]} end)
      true ->
        data.response
    end
  end

  #get example map for Leads post
  def get_example do

    example = %{
      "Lead Source": "Web Download",
      "Company": "Your Company",
      "First Name": "Hannah",
      "Last Name": "smith",
      "Email": "testing@testing.com",
      "Title": "Manager",
      "Phone": "1234567890",
      "Home Phone": "0987654321",
      "Other Phone": "111",
      "Fax": "222",
      "Mobile": "123"}

    example
  end
end


