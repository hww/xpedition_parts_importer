#!/bin/ruby
$LOAD_PATH << '.'

module CapTools

    def CapTools.description_captiance_f_to_s(value)
        if !value.is_a?(Float)
            raise  "Excepted floating point, got #{value}\n"
        end

        if value >= 1.0
            units = "F"
            text = value.to_s
        elsif value >= 0.001
            units = "mF"
            text = (value * 1000.0).to_s
        elsif value >= 0.000001
            units = "uF"
            text = (value * 1000000.0).to_s
        elsif  value >= 0.000000001
            units = "nF"
            text = (value * 1000000000.0).to_s
        elsif  value >= 0.000000000001
            units = "pF"
            text = (value * 1000000000000.0).to_s
        elsif  value >= 0.000000000000001
            units = "pF"
            text = (value * 1000000000000.0).to_s
        else
            raise("[CapTools] Unexpected case #{value}")
        end
        if text.end_with?(".0")
            text.gsub!(".0","")
            return %Q(#{text}#{units})
        else
            return %Q(#{text}#{units})
        end
    end

    def CapTools.captiance_f_to_s(value)
        if !value.is_a?(Float)
            raise "Excepted floating point, got #{value}\n"
        end

        if value >= 1.0
            units = "F"
            text = value.to_s
        elsif value >= 0.001
            units = "mF"
            text = (value * 1000.0).to_s
        elsif value >= 0.000001
            units = "uF"
            text = (value * 1000000.0).to_s
        elsif  value >= 0.000000001
            units = "nF"
            text = (value * 1000000000.0).to_s
        elsif  value >= 0.000000000001
            units = "pF"
            text = (value * 1000000000000.0).to_s
        elsif  value >= 0.000000000000001
            units = "pF"
            text = (value * 1000000000000.0).to_s
        else
            raise("[CapTools] Unexpected case #{value}")
        end
        # To forma 5p6, 56pF, etc
        if text.end_with?(".0") || text.end_with?(".00") || text.end_with?(".000")
            return text.sub(".0", units) # 56pF
        elsif text.include?(".") 
            return text.sub(".", units[0]) # 5p6
        end
    end

    def CapTools.tolerance_to_s(min, max)
        if (min.abs()==max.abs())
            return "#{max}%"
        else
            return "#{min}% ~+#{max}%"
        end
    end

    def CapTools.rated_voltage_to_s(value)
        if value.to_s.end_with?(".0")
            return "#{value.to_i}V"
        else
            return "#{value}V"
        end 
    end

    def CapTools.temperature_to_s(min, max)
        return "#{min.abs}C#{max.abs}"
    end

    def CapTools.package_to_s(s)
        case s
        when "Radial, Can"
            return "Radial Can"
        when "Radial"
            return "Radial"   
        when "Radial, Can - SMD"          
            return "Radial Can"   
        else
            raise "Unknown package '#{s}'"
        end
    end

    def CapTools.mount_type_to_s(s)
        case s
        when "Through Hole"
            return "TH"
        when "Surface Mount"
            return "SMD"
        else
            raise "Unknown mount type '#{s}'"
        end
    end
end
