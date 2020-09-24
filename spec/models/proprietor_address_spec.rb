require "rails_helper"

RSpec.describe ProprietorAddress, "#parsed" do
  it "returns an address mapped to lines" do
    address = "Mill Mall Tower, 2nd Floor, Wickhams Cay 1, PO Box 4406, Road Town, Tortola, British Virgin Islands"
    building = double(:building, land_registry_proprietor_address: address)

    parsed_address = ProprietorAddress.new(building).parsed

    expect(parsed_address).to eq({
      "line_0" => "Mill Mall Tower",
      "line_1" => "2nd Floor",
      "line_2" => "Wickhams Cay 1",
      "line_3" => "PO Box 4406",
      "line_4" => "Road Town",
      "line_5" => "Tortola",
      "line_6" => "British Virgin Islands",
    })
  end

  it "separates the postcode to its own line if a UK postcode is present" do
    address = "32B Borland Road, London SE15 3BD"
    building = double(:building, land_registry_proprietor_address: address)

    parsed_address = ProprietorAddress.new(building).parsed

    expect(parsed_address).to eq({
      "line_0" => "32B Borland Road",
      "line_1" => "London",
      "line_2" => "SE15 3BD",
    })
  end

  it "separates the postcode to its own line if an UK postcode is present and is preceeded by a comma" do
    address = "130-136 Sydenham Road, London, SE26 5JY"
    building = double(:building, land_registry_proprietor_address: address)

    parsed_address = ProprietorAddress.new(building).parsed

    expect(parsed_address).to eq({
      "line_0" => "130-136 Sydenham Road",
      "line_1" => "London",
      "line_2" => "SE26 5JY",
    })
  end
end
