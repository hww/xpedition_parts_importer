#!/bin/ruby
$LOAD_PATH << '.'
require 'csv' 
require 'optparse'
require 'digikey_cap_tools'
require 'mentor_non_ipc_capacitor_cell'
require 'mentor_ipc_capacitor_cell'
require 'cap_tools'
require 'table'
require 'filter'

def required_option(name, options={})
    v = options[name]
    if v.nil?
        print "The argument should include required option #{name}"
        exit 1
    end
    return v
end

def parse_dk_capacitor(item, options = {})

    pin_dia = required_option(:pin_dia, options) 
    pin_qty = required_option(:pin_qty, options) 

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Extract data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    dk_status = item.get_field("Product Status")
    dk_mfr_partn = item.get_field("Mfr Part #")
    dk_mfr = item.get_field("Mfr")
    dk_series = item.get_field("Series")
    dk_capacitance = item.get_field("Capacitance")
    dk_voltage = item.get_field("Voltage - Rated")
    dk_tolerance = item.get_field("Tolerance")
    dk_temperature = item.get_field( "Operating Temperature")
    dk_lead_spacing = item.get_field("Lead Spacing")
    dk_size = item.get_field("Size / Dimension")
    dk_height = item.get_field("Height - Seated (Max)")
    dk_mount_type = item.get_field("Mounting Type")
    dk_package = item.get_field( "Package / Case")
    dk_datasheet = item.get_field("Datasheet") 
    dk_image = item.get_field("Image") 
    dk_polarization = item.get_field("Polarization")

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    min_tolerance, max_tolerance = DigikeyCapTools.convert_tolerance(dk_tolerance)
    min_temperature, max_temperature = DigikeyCapTools.convert_temperature(dk_temperature)
    
    # Convet the strings to numerical values
    return {
        :status => dk_status,
        :mfr_partn => dk_mfr_partn,
        :mfr => dk_mfr,
        :series => dk_series,
        :capacitance => DigikeyCapTools.convert_capacity(dk_capacitance),
        :voltage => DigikeyCapTools.convert_rated_voltage(dk_voltage),
        :min_tolerance => min_tolerance,
        :max_tolerance => max_tolerance,
        :min_temperature =>min_temperature,
        :max_temperature =>max_temperature,
        :lead_spacing => DigikeyCapTools.convert_size(dk_lead_spacing),
        :size => DigikeyCapTools.convert_size(dk_size),
        :height => DigikeyCapTools.convert_size(dk_height),
        :mount_type => dk_mount_type,
        :package => dk_package,
        :datasheet => dk_datasheet,
        :image => dk_image,
        :component_type => "Capacitor",
        :polarization => dk_polarization,
        :pin_dia => pin_dia,
        :pin_qty => pin_qty
    }
end

def parse_cemicon_capacitor(item, options = {})
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Arguments
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    lead_spacing = required_option(:lead_spacing, options)
    package = required_option(:package, options)
    polarization = required_option(:polarization, options)
    pin_dia = required_option(:pin_dia, options) 
    pin_qty = required_option(:pin_qty, options) 

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Extract data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   
    ck_status = item.get_field("Production Status")
    ck_mfr_partn = item.get_field("Parts Number")
    ck_mfr = "CHEMI-CON"
    ck_series = item.get_field("Series")
    ck_capacitance = item.get_field("Capacitance[μF]")
    ck_voltage = item.get_field("Rated Voltage[Vdc]")
    ck_tolerance = item.get_field("Capacitance Tolerance Code")
    ck_min_temperature = item.get_field( "Min. Category Temperature[deg.C]")
    ck_max_temperature = item.get_field( "Max. Category Temperature[deg.C]")
    ck_lead_spacing = lead_spacing
    ck_size = item.get_field("Dimensions ⌀D[mm]")
    ck_height = item.get_field("Dimensions L[mm]")
    ck_mount_type = item.get_field("Mounting Type")
    ck_package = package
    ck_datasheet = item.get_field("Catalog PDF(en)") 
    ck_image = ""
    ck_polarization = polarization

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    case ck_tolerance
    when "M"
        tollerance = 20.0
    else
        raise("Unknown tollerance code #{ck_tolerance}")
    end

    min_temperature, max_temperature = DigikeyCapTools.convert_temperature(dk_temperature)

    # Convet the strings to numerical values
    return {
        :status => ck_status,
        :mfr_partn => ck_mfr_partn,
        :mfr => ck_mfr,
        :series => ck_series,
        :capacitance => DigikeyCapTools.convert_capacity(dk_capacitance),
        :voltage => DigikeyCapTools.convert_rated_voltage(dk_voltage),
        :min_tolerance => tollerance,
        :max_tolerance => tollerance,
        :min_temperature => min_temperature, 
        :max_temperature => max_temperature,
        :lead_spacing => DigikeyCapTools.convert_size(dk_lead_spacing),
        :size => DigikeyCapTools.convert_size(dk_size),
        :height => DigikeyCapTools.convert_size(dk_height),
        :mount_type => dk_mount_type,
        :package => dk_package,
        :datasheet => dk_datasheet,
        :image => dk_image,
        :component_type => "Capacitor",
        :polarization => ck_polarization,
        :pin_dia => pin_dia,
        :pin_qty => pin_qty
    }
end

@FILE_TYPE_DIGIKEY = "digikey"
@FILE_TYPE_CHEMICON = "nichicon"
@FILE_TYPES = [@FILE_TYPE_DIGIKEY, @FILE_TYPE_CHEMICON]

def parse_capacitor(item, options = {})

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Arguments
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    type = required_option(:type, options)

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Parse
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    case type
    when @FILE_TYPE_DIGIKEY
        obj = parse_dk_capacitor(item, options)
    when @FILE_TYPE_CHEMICON
        obj = parse_cemicon_capacitor(item, options)
    else
        raise("\nUnsupported file type '#{type}', expected: #{@FILE_TYPES}\n")
    end
    
end

@IPC_CAPAER_1 = "IPC_CAPAER_1"
@IPC_CAPAER_2 = "IPC_CAPAER_2"
@CELL_FORMATS = [@IPC_CAPAER_1, @IPC_CAPAER_2]

def convert_capacitor(obj, options)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Arguments
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    cell_format = options[:cell_format] 

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    status = obj[:status]
    mfr_partn = obj[:mfr_partn]
    mfr = obj[:mfr]
    series = obj[:series]
    capacitance = obj[:capacitance]
    voltage = obj[:voltage]
    min_tolerance = obj[:min_tolerance]
    max_tolerance = obj[:max_tolerance]
    min_temperature = obj[:min_temperature]
    max_temperature = obj[:max_temperature]
    lead_spacing = obj[:lead_spacing]
    size = obj[:size]
    height = obj[:height]
    mount_type = obj[:mount_type]
    package = obj[:package]
    datasheet = obj[:datasheet]
    image = obj[:image]
    component_type = obj[:component_type]
    polarization = obj[:polarization]
    pin_qty = obj[:pin_qty]
    pin_dia = obj[:pin_dia]

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert the value to Mentor's format
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    m_capacitance = CapTools.captiance_f_to_s(capacitance)
    m_capacitance_desc = CapTools.description_captiance_f_to_s(capacitance).upcase
    m_voltage = CapTools.voltage_to_s(voltage)
    m_tolerance = CapTools.tolerance_to_s(min_tolerance, max_tolerance)
    m_temperature = CapTools.temperature_to_s(min_temperature, max_temperature)
    m_size_height = MentorIpcCapacitorCell.make_body_size(size*100, height*100)
    m_lead_spacing = MentorIpcCapacitorCell.make_size(lead_spacing*100, 4)
    m_lead_size = MentorIpcCapacitorCell.make_size(pin_dia*100, 3)
    m_package = package.gsub(" ","")

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert all to the footprint string
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    case cell_format
    # Capacitor, Aluminum Electrolytic, Through_hole, Radial
    when @IPC_CAPAER_1
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        # CAPAETR(Pin_qty)_(mfr)_(mfr_sern)_(CC###) or (mfr_prtn) optional suffix PD{pin_data} pin data
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        m_footprint = %Q(CAPAETR#{pin_qty}_#{dk_mfr}_#{dk_series}_PD#{m_lead_size})
    when @IPC_CAPAER_2
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        # CAPAETR(Pin_qty)_(pitch)P(body_widthXbody_height) optional suffix PD{pin_data} pin data
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        m_footprint = %Q(CAPAETR#{pin_qty}_#{m_lead_spacing}P_#{m_size_height}_PD#{m_lead_size})
    else
        raise "\nUnknown cell name format '#{cell_format}' expected: #{@CELL_FORMATS}\n"
    end

    case component_type
    when "Capacitor"
        m_description = %Q(CAP ALUM #{m_capacitance_desc} #{m_tolerance} #{m_voltage} #{m_temperature} #{m_package} #{mount_type})
    else
        raise "Unknown ccomponent type #{component_type} expected: " + ["Capacitor"].to_s
    end

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Create result
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


    return {
        "Part Number" => m_footprint,
        "Part Name" => "",
        "Part Label" => "",
        "Part ID" => "", 
        "Symbol" => "cap",
        "Footprint" => m_footprint,
        "Manufacturer Part Description" => m_description,	
        "Manufacturer Name" => mfr,
        "Manufacturer Part Number" => mfr_partn,
        "Manufacturer Link" => nil,
        "Series" => series,
        "Supplier Name" => nil,
        "Supplier Part Number" => nil,
        "Supplier Category" => nil,
        "Supplier Sub-Category" => nil,
        "Supplier Link" => nil,
        "Datasheet Link" => datasheet,
        "Photo Link" => image,
        "Value" => capacitance,
        "Resistance" => nil,
        "Capacitance" => nil,
        "Inductance" => nil,
        "Tolerance" => max_tolerance / 100.0,
        "Rated Voltage" => voltage,
        "Rated Current" => nil,
        "Rated Power" => nil,
        "Package" => package,
        "Status" => status,
        "Type Cost" => nil,
        "Component Type" => component_type
    }
end

# ==============================================================================
# The parsing is convertinh the CSV file to the hash table
# ==============================================================================

def parse_table(table, options={})
    result = Table.new
    first_row = true
    table.rows().each do |row|
        obj1 = parse_capacitor(row, options)
        if first_row
            result.add_header(obj1.map{|k,v| k})
            first_row = false
        end
        result.add_line(obj1)
    end
    return result
end

# ==============================================================================
# Converting will produce the DxDatabook data format
# ==============================================================================

# On the inout it has table with short names
# :captiance, :voltage
# On the output onverted values
# "Captiance", "RatedValue"
def convert_table(table, options={})
    result = Table.new
    first_row = true
    table.rows().each do |row|
        obj2 = convert_capacitor(row, options)
        # Now there is long names
        if first_row
            keys = obj2.map{|k,v| k}
            result.add_header(keys)
            first_row = false
        end
        new_cells = obj2.map{|k,v| obj2[k]}
        result.add_line(new_cells)
    end
    return result
end

# ==============================================================================
# Parse the arguments of application
# ==============================================================================

def parse_arguments()
    options = {}
    options[:only] = []
    options[:except] = []
    options[:pin_qty] = 2
    options[:pin_dia] = 1
    options[:print_level] = 10
    parser = OptionParser.new do |opts|
        opts.banner = "Usage: digikey-cap.rb [options]"
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Main
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        opts.on("-f FILE", "--file FILE", String, "[REQUIRED] The .csv file to parse") do |n|
          options[:file] = n
        end
        opts.on("-t TYPE", "--type TYPE", String, "[REQUIRED] The type of .csv file to parse") do |n|
          options[:type] = n
        end
        opts.on("-c", "--cell-format FORMAT", String, "[REQUIRED] Use this cell format") do |n|
            options[:cell_format] = n
        end   
        opts.on("", "--pin-qty N", Integer, "Use this pint count") do |n|
          options[:pin_qty] = n
        end
        opts.on("-d", "--pin-dia N", Float, "Pin diameter") do |n|
            options[:pin_dia] = n
        end
        opts.on("", "--polarization N", Float, "The part polarization diameter") do |n|
            options[:polarization] = n
        end
        opts.on("", "--skip N", Integer, "Skip N lines") do |n|
            options[:skip] = n
        end
        opts.on("", "--limit N", Integer, "Limit N lines") do |n|
            options[:limit] = n
        end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Change mode
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        opts.on("", "--print-cell", "Print the fotprins") do |n|
          options[:print_cell] = true
        end
        opts.on("-p N", "--print-level N", Integer, "Print level") do |n|
            options[:print_level] = n
        end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Filter various fields 
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        opts.on("", "--only-status N", String, "Only with this content. Example: mfr=Rohm") do |n|
          options[:only] << Filter.new(n)
        end
        opts.on("", "--except-status N", String, "Except records with this content. Example: mfr=Rohm") do |n|
          options[:except] << Filter.new(n)
        end
        opts.on("", "--invert N", String, "Invert filter") do |n|
          options[:invert][k] = n
        end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Help
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
    end
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      # Help
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
    parser.parse!(ARGV)
    required = [:file]
    required.each do |k|
        if options[k].nil?
            puts "Required field #{k} was not found\n"
            exit 1
        end
    end
    if !@FILE_TYPES.index(options[:type])
        puts "Required field --type equal one of #{@FILE_TYPES}\n  Got '#{options[:type]}'\n"
        exit 1
    end

    if !@CELL_FORMATS.index(options[:cell_format])
        puts "Required field --cell-format equal one of #{@CELL_FORMATS}\n  Got '#{options[:cell_format]}'\n"
        exit 1
    end

    return options
end
options = parse_arguments()
case options[:print_level]
when 1
    table1 = Table.new
    table1.load_file(options[:file], options)
    table2 = table1.filter(options)
    print table2.to_csv(",")
when 2
    table1 = Table.new
    table1.load_file(options[:file], options)
    table2 = parse_table(table1, options)
    table3 = table2.filter(options)
    print table3.to_csv(",")
else 
    table1 = Table.new
    table1.load_file(options[:file], options)
    table2 = parse_table(table1, options)
    table3 = table2.filter(options)
    table4 = convert_table(table3, options)
    print table4.to_csv(",")
end
