#!/bin/ruby
$LOAD_PATH << '.'
require 'table'
class Filter
  @operation = nil
  @key = nil
  @value = nil

  def initialize(str)
      if str.index("LIKE")
          sep = "LIKE"
          @operation = :like
      elsif str.index("==")
          sep = "=="
          @operation = :eq
      elsif str.index("!=")
          sep = "!="
          @operation = :neq
      elsif str.index("<=")
          sep = "<="
          @operation = :lte
      elsif str.index(">=")
          sep = ">="
          @operation = :gte
      elsif str.index("<")
          sep = "<"
          @operation = :lt
      elsif str.index(">")
          sep = ">"
          @operation = :gt
      elsif str.index("=")
          sep = "="
          @operation = :eq
      end

      arr = str.split(sep)
      @key  = arr[0]
      @value = arr[1] 
      if @value.nil?
        raise "Expected key=value found '#{str}'"
      end
  end

  def format_float(number)
    sprintf('%.19f', number).sub(/0+$/, '').sub(/\.$/, '.0')
  end

  def preficate(row, options = {})
    verbose = options[:verbose] || false
    value = row[@key]
    if value.nil?
      result = predicate_nil(value)
    elsif value.is_a?(String)
      result = predicate_string(value)
    elsif value.is_a?(Float) or value.is_a?(Integer)
      result = predicate_number(value)
    else
      raise "Unexpected type #{@key} #{value}"
    end
    if verbose
      print %Q()
    end
    return result
  end
  def predicate_nil(value)
    case @operation
    when :eq
      return @value == "nil"
    when :neq
      return @value != "nil"
    when :qte
      return false
    when :qt
      return false
    when :lte
      return false
    when :lt
      return false
    when :like
      return false
    end
  end
  def predicate_string(value)
    case @operation
    when :eq
      return value == @value
    when :neq
      return value != @value
    when :qte
      return false
    when :qt
      return false
    when :lte
      return false
    when :lt
      return false
    when :like
      return value.to_s.upcase.include?(@value.upcase) 
    end
  end

  def predicate_number(value)
    case @operation
    when :eq
      return value == @value.to_f
    when :neq
      return value != @value.to_f
    when :qte
      return value >= @value.to_f
    when :qt
      return value > @value.to_f
    when :lte
      return value <= @value.to_f
    when :lt
      return value < @value.to_f
    when :like
      return format_float(value).index(@value)
    end
  end

end