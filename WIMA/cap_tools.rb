module CapTools
    def CapTools.pf_to_s(value)
        if value >= 1000000000
            units = "F"
            humanValue = (value/1000000000).to_s
        elsif value >= 1000000
            units = "uF"
            humanValue = (value/1000000).to_s
        elsif  value >= 1000
            units = "nF"
            humanValue = (value/1000).to_s
        else  
            units = "pF"
            humanValue = value.to_s
        end
    
        if humanValue.end_with?(".0")
            humanValue.sub!(".0", units)
        elsif humanValue.include?(".") 
            humanValue.sub!(".", units[0])
        else 
            humanValue+=units
        end
    end

    def CapTools.f_to_s(value)
        return pf_to_s(value*1000000000000)
    end
end