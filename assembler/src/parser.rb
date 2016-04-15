require_relative 'code'
require_relative 'symbol_table'

class Parser
  attr_accessor :lines

  def initialize lines
    @lines = lines
    @codifier = Code.new
    @symbol_table = SymbolTable.new
  end

  def parse
    remove_blank_lines
    remove_comments
    # first pass
    pc = 0
    @lines.map! do |line|
      case command_type line
      when :A_COMMAND
        pc+=1
        if line[1].index(/[0-9]/)
          number = symbol line
          to_16_bit_padded_number number
        elsif line[1] == "R"
          label = symbol line
          number = @symbol_table.get_address label
          to_16_bit_padded_number number
        else
          line
        end
      when :L_COMMAND
        label = symbol line
        @symbol_table.add_entry label, pc
        ""
      else
        pc+=1
        "111"                            +
        what_A_bit_should_be(line)       +
        @codifier.codify_comp(comp line) +
        @codifier.codify_dest(dest line) +
        @codifier.codify_jump(jump line)
      end
    end
    # second pass
    # p "label #{label} , number #{number} , binary #{to_16_bit_padded_number(number)} "
    @lines.map! do |line|
      if line[0] == "@"
        label = symbol line
        number = @symbol_table.get_address label
        to_16_bit_padded_number number
      else
        line
      end
    end
    @lines.reject {|l| l.empty?}.join "\n"
  end

  private
    def command_type line
      if line[0] == '@'
        return :A_COMMAND
      elsif line.index("=") || line.index(";")
        return :C_COMMAND
      else return :L_COMMAND
      end
    end

    def symbol line
      if line[0] == '@'
        line[1..-1]
      else
        line[1..-2]
      end
    end

    def what_A_bit_should_be line
      if line.index("=")
        if line[line.index("=") + 1 .. -1].include? "M"
          "1"
        else
          "0"
        end
      else
        "0"
      end
    end

    def comp line
      if line.index("=")
        line[line.index("=") + 1 .. -1]
      else
        line[0 .. line.index(";") - 1]
      end
    end

    def dest line
      return "null" unless line.index("=")
      line[0 .. line.index("=") - 1]
    end

    def jump line
      return "null" unless line.index(";")
      line[line.index(";") + 1 .. -1]
    end

    def remove_comments
      @lines.reject! do |line|
        line[0..1] == "//"
      end
      @lines.map! do |line|
        line.gsub! /\/\/.*$/, ""
        line
      end
    end

    def remove_blank_lines
      @lines.map! do |line|
        line.gsub!(/\s+/, "")
      end.
      reject! do |line|
        line == ""
      end
    end

    def to_16_bit_padded_number number
      ("%16.16s" % number.to_i.to_s(2)).gsub!(/\ /, "0")
    end
end
