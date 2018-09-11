defmodule Zoho.LeadById do

  @loc "Leads"
  @resource Zoho.Lead

  def endpoint do
    "/#{@loc}/getRecordById?authtoken=#{auth_key()}&scope=crmapi"
  end

  def get(params) do
    raw_get(params).data
  end

  def raw_get(params) do
    build_path(endpoint(), params)
    |> Zoho.get
    |> Zoho.Response.new(%{as: @resource()})
  end

  #clean up strange data format
  def get_clean(params) do
     data = Zoho.Leads.get(params)

     top = data.response["result"]["Leads"]["row"]
     if is_list top do
       data2 = top
       data3 = Enum.map(data2, fn(y) -> Enum.map(y["FL"], fn(x) -> %{x["val"] => x["content"]} end) end)
       Enum.map(data3, fn(y) -> Enum.reduce(y, %{}, fn (map, acc) -> Map.merge(acc, map) end) end)
     else
       data2 = top["FL"]
       Enum.reduce(data2, %{}, fn(x, acc) -> Map.put(acc, x["val"], x["content"]) end)
     end
  end

  use Zoho.Resource
end


