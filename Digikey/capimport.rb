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
        puts "The argument should include required option #{name}"
        exit 1
    end
    return v
end

def parse_dk_capacitor(item, options = {})

    #pin_size = required_option(:pin_size, options) 
    #pin_qty = required_option(:pin_qty, options) 

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Extract data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    dk_status = item.get_field("Product Status")
    dk_mfr_part_number = item.get_field("Mfr Part #")
    dk_mfr = item.get_field("Mfr")
    dk_series = item.get_field("Series")
    dk_value = item.get_field("Capacitance")
    dk_rated_voltage = item.get_field("Voltage - Rated")
    dk_tolerance = item.get_field("Tolerance")
    dk_temperature = item.get_field( "Operating Temperature")
    dk_size = item.get_field("Size / Dimension")
    dk_height = item.get_field("Height - Seated (Max)")
    dk_mount_type = item.get_field("Mounting Type")
    dk_package = item.get_field( "Package / Case")
    dk_datasheet_link = item.get_field("Datasheet") 
    dk_photo_link = item.get_field("Image") 
    dk_polarization = item.get_field("Polarization")  
    dk_pin_spacing = item.get_field("Lead Spacing")
    dk_surface_mount_land_size = item.get_field("Surface Mount Land Size")

    pin_size = item.get_field("Pin Size").to_f
    pin_qty = item.get_field("Pin Qty").to_i

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 
    min_tolerance, max_tolerance = DigikeyCapTools.convert_tolerance(dk_tolerance)
    min_temperature, max_temperature = DigikeyCapTools.convert_temperature(dk_temperature)
    smd_len, smd_width = DigikeyCapTools.land_size(dk_surface_mount_land_size)
    # Convet the strings to numerical values
    return {
        :status => dk_status,
        :mfr_part_number => dk_mfr_part_number,
        :mfr_name => dk_mfr,
        :series => dk_series,
        :value => DigikeyCapTools.convert_capacity(dk_value),
        :rated_voltage => DigikeyCapTools.convert_rated_voltage(dk_rated_voltage),
        :min_tolerance => min_tolerance,
        :max_tolerance => max_tolerance,
        :min_temperature =>min_temperature,
        :max_temperature =>max_temperature,
        :size => DigikeyCapTools.convert_size(dk_size),
        :height => DigikeyCapTools.convert_size(dk_height),
        :mount_type => dk_mount_type,
        :package => dk_package,
        :datasheet_link => dk_datasheet_link,
        :photo_link => dk_photo_link,
        :component_type => "Capacitor",
        :polarization => dk_polarization,
        :pin_spacing => DigikeyCapTools.convert_size(dk_pin_spacing),
        :pin_size => pin_size,
        :pin_qty => pin_qty,
        :smd_len => smd_len, 
        :smd_width => smd_width
    }
end

def parse_cemicon_capacitor(item, options = {})
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Extract data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   
    ck_status = item.get_field("Production Status")
    ck_mfr_part_number = item.get_field("Parts Number")
    ck_mfr = "CHEMI-CON"
    ck_series = item.get_field("Series")
    ck_value = item.get_field("Capacitance[μF]")
    ck_rated_voltage = item.get_field("Rated Voltage[Vdc]")
    ck_tolerance = item.get_field("Capacitance Tolerance Code")
    ck_min_temperature = item.get_field( "Min. Category Temperature[deg.C]")
    ck_max_temperature = item.get_field( "Max. Category Temperature[deg.C]")
    ck_size = item.get_field("Dimensions ⌀D[mm]")
    ck_height = item.get_field("Dimensions L[mm]")
    ck_mount_type = item.get_field("Mounting Type")
    ck_package = item.get_field("Package")
    ck_datasheet_link = item.get_field("Catalog PDF(en)") 
    ck_photo_link = ""
    ck_polarization =  item.get_field("Polarization") 

    ck_land_size = item.get_field("SMD Land Size") 
    ck_pin_spacing = item.get_field( "Pin Spacing")
    ck_pin_qty = item.get_field( "Pin Qty")
    ck_pin_size = item.get_field( "Pin Size")

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert data
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    case ck_tolerance
    when "M"
        tollerance = 20.0
    else
        raise("Unknown tollerance code #{ck_tolerance}")
    end    
    
    if ck_land_size == "" 
        smd_len, smd_width = DigikeyCapTools.land_size(ck_land_size)
    else
        smd_len, smd_width = 0, 0;
    end

    # Convet the strings to numerical values
    return {
        :status => ck_status,
        :mfr_part_number => ck_mfr_part_number,
        :mfr_name => ck_mfr,
        :series => ck_series,
        :value => ck_value.to_f / 1000000.0,
        :rated_voltage => ck_rated_voltage.to_i,
        :min_tolerance => tollerance,
        :max_tolerance => tollerance,
        :min_temperature => ck_min_temperature.to_i, 
        :max_temperature => ck_max_temperature.to_i,
        :pin_spacing => DigikeyCapTools.convert_size(ck_pin_spacing),
        :size => DigikeyCapTools.convert_size(ck_size),
        :height => DigikeyCapTools.convert_size(ck_height),
        :mount_type => ck_mount_type,
        :package => ck_package,
        :datasheet_link => ck_datasheet_link,
        :photo_link => ck_photo_link,
        :component_type => "Capacitor",
        :polarization => ck_polarization,
        :pin_size => ck_pin_size.to_f,
        :pin_qty => ck_pin_qty,
        :smd_len => smd_len, 
        :smd_width => smd_width
    }
end

@FILE_TYPE_DIGIKEY = "digikey"
@FILE_TYPE_CHEMICON = "chemicon"
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
@IPC_CAPAE_1 = "IPC_CAPAE_1"
@NONIPC_CAPS = "NONIPC_CAPS"
@NONIPC_CAPAER_1 = "NONIPC_CAPAER_1"
@NONIPC_CAPAER_2 = "NONIPC_CAPAER_2"
@CELL_FORMATS = [@IPC_CAPAE_1, @NONIPC_CAPS, @NONIPC_CAPAER_1, @NONIPC_CAPAER_2]

def convert_capacitor(obj, options)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Arguments
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    cell_format = options[:cell_format] 


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    status = obj[:status]
    mfr_part_number = obj[:mfr_part_number]
    mfr_name = obj[:mfr_name]
    series = obj[:series]
    value = obj[:value]
    rated_voltage = obj[:rated_voltage]
    min_tolerance = obj[:min_tolerance]
    max_tolerance = obj[:max_tolerance]
    min_temperature = obj[:min_temperature]
    max_temperature = obj[:max_temperature]

    size = obj[:size]
    height = obj[:height]
    mount_type = obj[:mount_type]
    package = obj[:package]
    datasheet_link = obj[:datasheet_link]
    photo_link = obj[:photo_link]
    component_type = obj[:component_type]
    polarization = obj[:polarization]
    pin_spacing = obj[:pin_spacing]
    pin_qty = obj[:pin_qty]
    pin_size = obj[:pin_size]
    smd_len = obj[:smd_len]
    smd_width = obj[:smd_width]

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert the value to Mentor's format
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    m_value = CapTools.captiance_f_to_s(value)
    m_value_desc = CapTools.description_captiance_f_to_s(value).upcase
    m_rated_voltage = CapTools.rated_voltage_to_s(rated_voltage)
    m_tolerance = CapTools.tolerance_to_s(min_tolerance, max_tolerance)
    m_temperature = CapTools.temperature_to_s(min_temperature, max_temperature)
    m_size_height = MentorIpcCapacitorCell.make_body_size(size*100, height*100)
    m_pin_spacing = MentorIpcCapacitorCell.make_size(pin_spacing*100, 4)
    m_pin_size = MentorIpcCapacitorCell.make_size(pin_size*100, 3)
    m_package = CapTools.package_to_s(package).upcase
    m_mount_type = CapTools.mount_type_to_s(mount_type).upcase

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Convert all to the footprint string
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    case cell_format
    when @IPC_CAPAE_1
        # Example CAPAE660W780HN
        dencity = required_option(:dencity, options)
        m_base_body_width = MentorIpcCapacitorCell.make_size(smd_width*100)
        m_height = MentorIpcCapacitorCell.make_size(height*100)
        m_footprint = %Q(CAPAE#{m_base_body_width}W#{m_height}H#{dencity})
    # Capacitor, Aluminum Electrolytic, Through_hole, Radial
    when @NONIPC_CAPAER_1
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        # CAPAETR(Pin_qty)_(mfr)_(mfr_sern)_(CC###) or (mfr_prtn) optional suffix PD{pin_data} pin data
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        m_footprint = %Q(CAPAETR#{pin_qty}_#{dk_mfr}_#{dk_series}_PD#{m_pin_size})
    when @NONIPC_CAPAER_2
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        # CAPAETR(Pin_qty)_(pitch)P(body_widthXbody_height) optional suffix PD{pin_data} pin data
        # -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        m_footprint = %Q(CAPAETR#{pin_qty}_#{m_pin_spacing}P_#{m_size_height}_PD#{m_pin_size})
    when @NONIPC_CAPS
        #m_footprint = %Q(CAPS#{pin_qty}_#{mfr_name}_(mfr_pkgn)or(mfr_sern)or (mfr_prtn)(DL))
        raise "Fix this code"
    else
        raise "\nUnknown cell name format '#{cell_format}' expected: #{@CELL_FORMATS}\n"
    end

    case component_type
    when "Capacitor"
        m_mfr_part_description = %Q(CAP ALUM #{m_value_desc} #{m_rated_voltage} #{m_tolerance} #{m_temperature} #{m_package} #{m_mount_type})
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
        "Manufacturer Part Description" => m_mfr_part_description,	
        "Manufacturer Name" => mfr_name,
        "Manufacturer Part Number" => mfr_part_number,
        "Manufacturer Link" => nil,
        "Series" => series,
        "Supplier Name" => nil,
        "Supplier Part Number" => nil,
        "Supplier Category" => nil,
        "Supplier Sub-Category" => nil,
        "Supplier Link" => nil,
        "Datasheet Link" => datasheet_link,
        "Photo Link" => photo_link,
        "Value" => value,
        "Resistance" => nil,
        "Capacitance" => nil,
        "Inductance" => nil,
        "Tolerance" => min_tolerance.abs / 100.0,
        "Rated Voltage" => rated_voltage,
        "Rated Current" => nil,
        "Rated Power" => nil,
        "Package" => "#{m_package} #{m_mount_type}",
        "Status" => status,
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
# :captiance, :rated_voltage
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
    #options[:only] = []
    #options[:except] = []
    #options[:pin_qty] = 2
    #options[:pin_size] = 1
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
        opts.on("-c", "--dencity C", String, "[REQUIRED] Use this cell format") do |n|
            options[:dencity] = n
        end    
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Change cell data
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        #opts.on("", "--pin-qty N", Integer, "Use this pint count") do |n|
        #  options[:pin_qty] = n
        #end
        #opts.on("-d", "--pin-dia N", Float, "Pin diameter") do |n|
        #    options[:pin_size] = n
        #end
        #opts.on("", "--polarization N", Float, "The part polarization diameter") do |n|
        #    options[:polarization] = n
        #end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Change mode
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        opts.on("-p N", "--print-level N", Integer, "Print level of progress: 1-load, 2-parse, 3-convert (DEFAULT)") do |n|
            options[:print_level] = n
        end        
        opts.on("", "--print-column N", String, "Print unique of items of this column") do |n|
            options[:print_column] = n
        end
        opts.on("", "--print-columns", Integer, "Print columns of the output") do |n|
            options[:print_columns] = true
        end
        opts.on("", "--pretty", "Pretty print") do |n|
            options[:pretty] = true
        end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Filter various fields 
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        opts.on("", "--skip N", Integer, "Skip N lines") do |n|
            options[:skip] = n
        end
        opts.on("", "--limit N", Integer, "Limit N lines") do |n|
            options[:limit] = n
        end
        #opts.on("", "--only-status N", String, "Only with this content. Example: mfr=Rohm") do |n|
        #  options[:only] << Filter.new(n)
        #end
        #opts.on("", "--except-status N", String, "Except records with this content. Example: mfr=Rohm") do |n|
        #  options[:except] << Filter.new(n)
        #end
        #opts.on("", "--invert", String, "Invert filter") do |n|
        #  options[:invert][k] = true
        #end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        # Help
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          puts Filter.usage_text
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
def print_result(table, options = {})
    print_fields = options[:print_columns] 
    print_column = options[:print_column]
    pretty = options[:pretty] || false

    if print_fields
        puts table.header.to_csv(pretty ? "\n" : ", ")
    elsif print_column
        puts table.column_to_csv(pretty ? "\n" : ",", print_column)
    else
        puts table.to_uniq_csv(",", "Part Number")
    end
end
options = parse_arguments()

case options[:print_level]
when 1
    table1 = Table.new
    table1.load_file(options[:file], options)
    print_result(table1, options)
when 2
    table1 = Table.new
    table1.load_file(options[:file], options)
    table2 = parse_table(table1, options)
    print_result(table2, options)
else 
    table1 = Table.new
    table1.load_file(options[:file], options)
    table2 = parse_table(table1, options)
    table3 = convert_table(table2, options)
    print_result(table3, options)
end
