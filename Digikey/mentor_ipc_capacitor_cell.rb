class MentorIpcCapacitorCell
    # ==========================================================================
    # Naming Convention IPC table
    # ==========================================================================
    def self.make_size(size, digits)
        s = size.to_i.to_s
        if s.size > digits
            raise "the value #{size} not fit to #{digits} digits"
        elsif s.size == digits
            return s
        end
        return  ("0" * (digits-s.size)) + s
    end
    # N.B. chip parts >9.99mm in either x or y will have 4 digit 
    # body size dimensions for both x and y using X as a separator 
    # i.e (9.14mmx10.20mm = 9140X1020)
    def self.make_body_size(width, lenght)
        ws = width.to_i.to_s
        ls = lenght.to_i.to_s
        diff = ws.size-ls.size       
        if diff > 0
            prefix= "0" * diff
            ls = prefix + ls
        elsif diff < 0
            prefix= "0" * -diff
            ws = prefix + ws
        end
        return "#{ws}X#{ls}"
    end
    #
    # Capacitor, Chip, Polarized
    #   
    # Example CAPC3216N-A for non polar
    # Example CAPCP3216N-A for polar
    #
    # N.B. chip parts >9.99mm in either x or y will have 4 digit 
    # body size dimensions for both x and y using X as a separator 
    # i.e (9.14mmx10.20mm = 9140X1020)
    # Density Level, M= Maximum, N= nominal, L= Least, Q = Manufacturer Specified
    def self.make_chip(polarized, width, lenght, density)
        body_size = make_body_size(width, lenght)
        if polarized
            return "CAPCP#{body_size}#{density}"
        else
            return "CAPC#{body_size}#{density}"
        end
    end
    #
    #
    # Capacitor, Chip, Wire Rectangle
    # 
    def self.make_chip_wire_rectangle(body_size, density)
        return "CAPCWR#{body_size}#{density}"
    end
    #
    # Capacitor, Chip, Array
    #
    def self.make_chip_array(mfr, mfr_sern, pin_qty, density)
        return "CAPAS_#{mfr}_#{mfr_sern}_#{pin_qty}#{DL}"
    end
    #
    # Capacitor, Molded, Polarized and Non-polarized
    #   
    # Example CAPC3216N-A for non polar
    # Example CAPCP3216N-A for polar
    #
    # N.B. chip parts >9.99mm in either x or y will have 4 digit 
    # body size dimensions for both x and y using X as a separator 
    # i.e (9.14mmx10.20mm = 9140X1020)
    # Density Level, M= Maximum, N= nominal, L= Least, Q = Manufacturer Specified
    def self.make_modlded(polarized, width, length, density)
        body_size = make_body_size(width, lenght)
        if polarized
            return "CAPMP#{body_size}#{density}"
        else
            return "CAPM#{body_size}#{density}"
        end
    end
    #
    # Capacitor, Aluminum Electrolytic
    #
    def self.make_aluminum_electrolytic(base_body_width, height, density)
        w = (base_body_width*100).to_i
        h = (height*100).to_i
        return "CAPAE#{w}W#{h}H#{dencity}"
    end
end