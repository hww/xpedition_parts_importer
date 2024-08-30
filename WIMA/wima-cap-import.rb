#!/bin/ruby
$LOAD_PATH << '.'
require "wima_mks_fkp"

require "wima_pn"
require "mentor_non_ipc_capacitor_cell"
require "cap_tools"

# ==============================================

def parse_designator(mfr_pn) 
    mfr = "WIMA"
    pnobj = WimaPartNumber.new(mfr_pn)
    mfr_series = pnobj.series()
    rated_voltage = pnobj.vdc()
    value_pf = pnobj.capacity_pf()
    cell_code = pnobj.cell_code()
    pitch =  pnobj.cell_pitch()
    tolerance = pnobj.tolerance()
    if true
        pcm = ("0000000"+(pitch*100).to_i.to_s)[-4..-1]
        footprint = MentorNonIpcCapacitorCell.make_th(2, mfr, "#{pcm}P", cell_code)
    else
        footprint = MentorNonIpcCapacitorCell.make_th(2, mfr, mfr_series, cell_code)
    end
    cap_str = CapTools.pf_to_s(value_pf)
    desc = pnobj.mfr_description()

    pn = "CAP-WIMA-#{mfr_series}-#{cap_str}-#{rated_voltage}VDC-#{tolerance*100}%";

    digikey_description = "CAP FILM #{cap_str} #{tolerance*100}% #{rated_voltage}VDC RAD"

    return {    
        "Part Number" => footprint,
        "Description" => digikey_description,
        "Symbol" => "cap",
        "Footprint" => footprint,
        "Manufacturer Part Description"=> desc,
        "Manufacturer Name"=> "WIMA",
        "Manufacturer Part Number"=> mfr_pn,
        "Value" => value_pf / 1000000000000.0,
        "Tolerance" => tolerance,
        "Component Type" => "Capacitor",
        "Rated Voltage" => rated_voltage,
        "Series" => mfr_series
    }
end

def convert_all()
    list = []
    caps = WimaMksFkpCapacitors.get_capacitors()
    caps.each do |c|
        cap = parse_designator(c)
        list << cap
    end
    return list
end

@fields = [
    "Part Number",
    "Part Name",
    "Part Label",
    "Part ID", 
    "Symbol",
    "Footprint",
    "Manufacturer Part Description",
    "Manufacturer Name",	
    "Manufacturer Part Number",
    "Manufacturer Link",
    "Series",
    "Supplier Name",
    "Supplier Part Number",
    "Supplier Category",
    "Supplier Sub-Category",
    "Supplier Link",
    "Datasheet Link",
    "Photo Link",
    "Value",
    "Resistance",
    "Capacitance",
    "Inductance",
    "Tolerance",
    "Rated Voltage",
    "Rated Current",
    "Rated Power",
    "Package",
    "Status	Component",
    "Type Cost"
]

# Check if builded table has bad fields
def verify_fields(record)
    record.each do |f,v|
        if !@fields.include?(f)
            return false
        end
    end
    return true
end
def format_float(number)
    sprintf('%.30f', number).sub(/0+$/, '').sub(/\.$/, '.0')
end
  
# Write csv file
def print_csv(list)
    # Check structure
    verify_fields(list[0])
    # Write header
    list[0].each do |f,v|
        print("\"#{f}\",")
    end
    print("\n")
    # Write table
    list.each do |t|
        list[0].each do |f,v|
            tf = t[f]
            if tf.is_a?(String)
                print("\"#{tf}\"")
            elsif tf.is_a?(Float)
                print(format_float(tf))
            else 
                print(tf)
            end
            print(",")
        end
        print("\n")
    end
end
def print_footprints(list)
    # Check structure
    verify_fields(list[0])
    table = {}
    result = []
    # Write table
    list.each do |t|
        fp = t["Footprint"]  
        if table[fp] == nil
        table[fp] = true 
        result << fp
        end
    end
    result.sort!
    result.each do |fp|
        print("#{fp}\n")
    end
end


list = convert_all()
if ARGV[0] == "cell"
    print_footprints(list)
else
    print_csv(list)
end
