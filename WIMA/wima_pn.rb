class WimaPartNumber

    @@vdc_table = {
    "B0" => 50,
    "C0" => 63,
    "D0" => 100,
    "F0" => 250,
    "G0" => 400,
    "H0" => 450,
    "H2" => 520,
    "I0" => 600,
    "J0" => 630,
    "K0" => 700,
    "L0" => 800,
    "M0" => 850,
    "N0" => 900,
    "O1" => 1000,
    "P0" => 1100,
    "Q0" => 1200,
    "R0" => 1250,
    "S0" => 1500,
    "T0" => 1600,
    "TA" => 1700,
    "U0" => 2000,
    "V0" => 2500,
    "W0" => 3000,
    "X0" => 4000,
    "Y0" => 6000,
    "3Y" => 230,
    "1W" => 275,
    "2W" => 300,
    "AW" => 305,
    "BW" => 350,
    "4W" => 440,
    "5W" => 500,
    }
    @@tolerances = { "M" => 0.20, "K" => 0.10, "J" => 0.05, "H" => 0.025, "E" => 0.01 }

    # ==============================================
    
    @pn = nil

    def initialize(pn)
        @pn = pn
    end

    # ==============================================

    def series() 
        return @pn[0..3]
    end
    def vdc() 
        return @@vdc_table[@pn[4..5]]
    end
    def capacity_pf() 
        digits = @pn[6].to_i
        value = @pn[7..9].to_f
        k = 10**digits
        return value * k 
    end
    def cell_code() 
        return @pn[10..11]   
    end
    def cell_pitch() 
        case cell_code()[0] 
        when "0"
            return 2.5
        when "1"
            return 5.0
        when "2"
            return 7.5
        when "3"
            return 10.0
        when "4"
            return 15.0
        when "5"
            return 22.5
        when "6"
            return 27.5
        when "7"
            return 37.5
        when "8"
            return 48.5
        when "9"
            return 52.5
        when "F"
            case code 
            when "FA","FB"
                return 10.0
            when "FC","FD", "FE", "FF", "FG"
                return 15.0
            when "FH","FI","FJ"
                return 22.5
            when "FK","FL","FM"
                return 27.5
            end
        end
        print("Error: can't dispach cell for part #{des} code: #{code}\n")
        exit
    end


    def tolerance() 
        ps = @pn[14]
        p = @@tolerances[ps]
        if p == nil
            print "Part #{des} has bad tolerance #{ps}"
            exit
        end
        return p
    end

    def dk_description(mft_series, capacity, rated_voltage, pitch, dimentions, suffix)
        return "#{mft_series} #{capacity} #{rated_voltage} #{pitch} #{dimentions} #{suffix}"
    end

    def mfr_description()
        case series()
        when "FKS2"
            return "FKS2 Polyester (PET) Film and Foil Capacitors for Pulse Applications"
        when "FKS3"
            return "FKS3 Polyester (PET) Film and Foil Capacitors for Pulse Applications"  

        when "FKP0"
            return "FKP02 Polypropylene (PP) Film and Foil Capacitors for Pulse Applications"
        when "FKP2"
            return "FKP2 Polypropylene (PP) Film and Foil Capacitors for Pulse Applications"          
        when "FKP3"
            return "FKP3 Polypropylene (PP) Film and Foil Capacitors for Pulse Applications"
        when "FKP4"
            return "FKP4 Polypropylene (PP) Capacitors"
        when "FKP1"
            return "FKP10 Polypropylene (PP) Capacitors"

        when "MKS0"
            return "MKS02 Metallized Polyester (PET) Capacitors"
        when "MKS2"
            return "MKS2 Metallized Polyester (PET) Capacitors"
        when "MKS4"
            return "MKS4 Metallized Polyester (PET) Capacitors"

        when "MKP2"
            return "MKP2 Metallized Polypropylene (PP) Capacitors"
        when "MKP4"
            return "MKP4 Metallized Polypropylene (PP) Capacitors"
        when "MKP1"
            return "MKP10 Metallized Polypropylene (PP) Capacitors"


        when "MKX2"
            return "Metallized Polypropylene (PP) RFI-Capacitors Class X2"
        when "MKX1"
            return "R Metallized Polypropylene (PP) RFI-Capacitors Class X1"
        when "MKY2"
            return "Metallized Polypropylene (PP) RFI-Capacitors Class Y2"

        when "MKPF"
            return "Metallized Polypropylene (PP) Filter Capacitors"
        else
            print "Bad series #{series}"
            exit
        end
    end


end