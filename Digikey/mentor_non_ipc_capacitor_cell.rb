class MentorNonIpcCapacitorCell
    # N.B. chip parts >9.99mm in either x or y will have 4 digit 
    # body size dimensions for both x and y using X as a separator 
    # i.e (9.14mmx10.20mm = 9140X1020)
    def make_body_size(width, lenght)
        ws = w.to_s
        ls = l.to_s
        diff = ws.size>ls.size       
        if diff > 0
            prefix= "0" * diff
            ls = prefix + ls
        elsif diff < 0
            prefix= "0" * -diff
            ws = prefix + ws
        end
        return "#{ws}X#{ls}"
    end
    # ==========================================================================
    # Naming Convention Non IPC table
    # ==========================================================================
    #
    # Capacitor, SMD
    # 
    # Density Level:
    #   M= Maximum, N= nominal, L= Least, Q = Manufacturer Specified
    # CC: 
    #   mfr_pkgn, mfr_pkgn, mfr_sern
    def self.make_smd(pin_qty, mfr, cc, density)
        return "CAPS#{pin_qty}_#{mfr}_#{cc}#{density}"
    end
    #
    # Capacitor, Through_hole by code
    #
    # Example CAPT2_WIMA_FKP4_FKP0D011500B00
    # Example CAPT2_WIMA_MKS4_0B
    # CC: 
    #   mfr_pkgn, mfr_pkgn, mfr_sern
    def self.make_th(pin_qty, mfr, mfr_sern, cc)
        return "CAPT#{pin_qty}_#{mfr}_#{mfr_sern}_#{cc}"
    end
    #
    # Capacitor, Through_hole by dimentions
    #
    # Example CAPT2_0250P0500X01000_PD0500
    # The value precision is 0.01
    def self.make_th_by_size(pin_qty, pitch, width, length, pin_diameter)
        body_size = make_body_size(width, length)
        pd = (pin_diameter * 100).to_i
        return "CAPT#{pin_qty}_#{pitch}P#{body_size}_PD#{pd}"
    end
    #
    # Capacitor, Aluminum Electrolytic, Through_hole, Axial
    #
    def self.make_elcap_th_axial(pin_qty, mfr, mfr_sern, cc)
        return "CAPAETA#{pin_qty}_#{mfr}_#{mfr_sern}_#{cc}"
    end
    def self.make_elcap_th_axial_by_size(pin_qty, pitch, width, length)
        body_size= make_body_size(width,lenght)
        return "CAPAETA#{pin_qty}_#{pitch}P#{body_size}"
    end
    #
    # Capacitor, Aluminum Electrolytic, Through_hole,Radial
    #
    def self.make_elcap_th_radial(pin_qty, mfr, mfr_sern, cc)
        return "CAPAETR#{pin_qty}_#{mfr}_#{mfr_sern}_#{cc}"
    end
    def self.make_elcap_th_radia_by_size(pin_qty, pitch, width, height, pin_diameter)
        body_size = make_body_size(width, length)
        return "CAPAETR#{pin_qty}_#{pitch}P#{body_size}"
    end
    #
    # Capacitor, Variable, SMD
    #
    def self.make_variable_smd(pin_qty, mfr, mfr_sern, cc, dancity)
       return "CAPVS#{pin_qty}_#{mfr}_#{cc}#{dancity}"
    end
    #
    # Capacitor, Variable, Through_hole
    #
    def self.make_variable_th(pin_qty, mfr, mfr_sern, cc)
        return "CAPVT#{pin_qty}_#{mfr}_#{mfr_sern}_#{cc}"
    end
end
