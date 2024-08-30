#!/bin/ruby
$LOAD_PATH << '.'
require 'csv' 

def format_float(number)
  sprintf('%.19f', number).sub(/0+$/, '').sub(/\.$/, '.0')
end

class Row 
  @table = nil
  @cells = []
  def initialize(table, cells)
    @table = table
    @cells = cells
  end
  def cells()
    return @cells
  end
  def [](idx)
    if idx.is_a?(Symbol)
      return get_field(idx)
    elsif idx.is_a?(String)
      return get_field(idx)
    else
      return @cells[idx]
    end
  end
  def index(name)
    idx = @cells.index(name.to_sym)
    if idx == nil
      raise("\ncan't find field with name '#{name}' in the #{@header}\n")
    end
    return idx
  end
  def get_field(name)
    return @cells[@table.index(name)]
  end  
  def to_csv(separator)
    a = []
    cells.each do |c|
      if c.is_a?(String)
        a << %Q("#{c}")
      elsif c.is_a?(Float)
        a << format_float(c)
      else
        a << c.to_s
      end
    end
    return a.join(separator)
  end
end

class Table
  @header = nil
  @rows = []
  def initialize()
    @header = nil
    @rows = []
  end
  #
  def header()
    return @header
  end
  #
  def rows()
    return @rows
  end
  #
  def [](idx)
    return @rows[idx]
  end
  #
  def index(name)
    return @header.index(name)
  end
  #
  def load_file(file_path, options={})
    skip = options[:skip] || 0
    limit = options[:limit] || 999999
    File.open( file_path,"r:UTF-8").each do |line|
      if (line != "")
          if @header.nil? 
            while line[0] < ' ' || line[0] > 'Z' 
              line = line[1..]
            end      
            cells = CSV.parse_line(line)
            @header = Row.new(self, cells.map{|s| s.to_sym})
          else
            if skip<=0 && limit>0
              cells = CSV.parse_line(line)
              @rows << Row.new(self, cells)
              limit -= 1
            end
            skip -= 1
          end
      end
    end
  end
  #
  def add_header(cells)
    cells = cells.cells if cells.is_a?(Row)
    @header = Row.new(self, cells.map{|v| v.to_sym})
  end
  #
  def add_line(cells={})
    new_cells = []
    @header.cells().each do |k|
      new_cells << cells[k]
    end
    @rows << Row.new(self,  new_cells)
  end
  #
  def to_csv(separator = ",")
    a = []
    a << @header.to_csv(separator)
    rows.each do |r|
        a << r.to_csv(separator)
    end
    return a.join("\n") + "\n"
  end
  def filter(options={})
    only = options[:only] || []
    except = options[:except] || []
    invert = options[:invert] || false
    table = Table.new
    table.add_header(@header)
    @rows.each do |row|
      # All 'only' filters should have true result 
      only_result = true;
      only.each do |f|
        unless f.preficate(row)
          only_result = false
          break
        end
      end
      # All 'only' filters should have alse result 
      except_result = false;
      except.each do |f|
        if f.preficate(row)
          except_result = true
          break
        end
      end
      # The selection login      
      select = only_result && !except_result
      # Invert selection
      if select == !invert
        table.add_line(row)
      end
    end
    return table
  end
end