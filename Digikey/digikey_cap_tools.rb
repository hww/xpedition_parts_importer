#!/bin/ruby
$LOAD_PATH << '.'

module DigikeyCapTools
  def self.convert_capacity(str)
      # produce capacity in farades
      scale = 1
      if str.index("mF") or str.index("MF") 
        str.sub!("mF", ".")
        str.sub!("MF", ".")
        scale = 1000.0
      elsif str.index("uF") or str.index("UF") or str.index("µF") 
        str.sub!("uF", ".")
        str.sub!("UF", ".")
        str.sub!("µF", ".")
        scale = 1000000.0
      elsif str.index("nF") or str.index("NF")
        str.sub!("nF", ".")
        str.sub!("NF", ".")
        scale = 1000000000.0
      elsif str.index("pF") or str.index("PF")
        str.sub!("pF", ".")
        str.sub!("PF", ".")
        scale = 1000000000000.0
      elsif str.index("F") or str.index("F") 
        str.sub!("mF", ".")
        str.sub!("MF", ".")
        scale = 1.0 
      elsif str.index("m") or str.index("M") 
        str.sub!("m", ".")
        str.sub!("M", ".")
        scale = 1000.0
      elsif str.index("u") or str.index("U") or str.index("µ") 
        str.sub!("u", ".")
        str.sub!("U", ".")
        str.sub!("µ", ".")
        scale = 1000000.0
      elsif str.index("n") or str.index("N")
        str.sub!("n", ".")
        str.sub!("N", ".")
        scale = 1000000000.0
      elsif str.index("p") or str.index("P")
        str.sub!("p", ".")
        str.sub!("З", ".")
        scale = 1000000000000.0        
      else
        raise("[DigikeyCapTools] Can]t parse capacity '#{str}'")
      end
      str.sub!(" .", ".0")
      str.sub!(" .", ".0")
      return (str.to_f / scale) 
  end
  def self.convert_tolerance(str)
    if str[0] == "±"
        min = str.gsub("±", "").gsub!("%", "").to_f 
        max = min
        return -min, max
    else
        raise "Bad tolerance format #{str}"
    end
  end
  def self.convert_rated_voltage(str) 
      return str.gsub(" V", "").gsub(" v", "").to_i
  end
  def self.convert_size(str)
      # lead space format is: 0.197" (5.00mm)
      # diameter format is: 0.394" Dia (10.00mm)
      # height format is: 0.551" (14.00mm)
      if str == nil || str == ""
          raise("can't parse dimention #{str}")
      end
      return str.split(" ")[-1].gsub("(", "").gsub("mm)","").to_f
  end
  def self.convert_temperature(str)
    # Format is -40°C ~ 85°C   
    arr = str.gsub(" ","").gsub("°C","").split("~")
    return arr[0].to_i,arr[1].to_i
  end
  def self.land_size(str)
    # 0.169" L x 0.169" W (4.30mm x 4.30mm)
    if str == nil || str == ""
        raise("can't parse dimention #{str}")
    end
    starts = str.index("(") + 1
    ends = str.index(")") -1
    subs = str[starts..ends]
    return subs.gsub("mm", "").split(" x ").map{|v| v.to_f}
  end
  
end


