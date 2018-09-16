defmodule Zoho.Leads do

  @loc "Leads"
  @resource Zoho.Lead
  use Zoho.Resource

  def create_endpoint do
    "/#{@loc}/insertRecords?authtoken=#{auth_key()}&scope=crmapi&xmlData="
  end

  def update_endpoint(id) do
    "/#{@loc}/updateRecords?authtoken=#{auth_key()}&id=#{id}&scope=crmapi&xmlData="
  end


  def update(id, params\\%{}) do
    update(id, params).data
  end

  def raw_update(id, params\\%{}) do
    build_post(@loc, update_endpoint(id), params)
    |> Zoho.get #[body: ""]
    |> Zoho.Response.new(%{as: @resource})
  end

  #clean up strange data format
  def get_clean do
     data = Zoho.Leads.get

     top = data.response["result"]["Leads"]["row"]
     if is_list top do
       data2 = top
       data3 = Enum.map(data2, fn(y) -> Enum.map(y["FL"], fn(x) -> %{x["val"] => x["content"]} end) end)
       Enum.map(data3, fn(y) -> Enum.reduce(y, %{}, fn (map, acc) -> Map.merge(acc, map) end) end)
     else
       data2 = top["FL"]
       Enum.map(data2, fn(x) -> %{x["val"] => x["content"]} end)
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
