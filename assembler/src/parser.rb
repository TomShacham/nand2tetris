require_relative 'code'

class Parser
  attr_accessor :lines

  def initialize lines
    @lines = lines
    @codifier = Code.new
  end

  def parse
    remove_blank_lines
    remove_comments
    @lines.map! do |line|
      case command_type line
      when :A_COMMAND || :L_COMMAND
        ("%16.4s" % symbol(line).to_i.to_s(2)).gsub!(/\ /, "0")
      else
        "1110"                            +
        @codifier.codify_comp(comp line) +
        @codifier.codify_dest(dest line) +
        @codifier.codify_jump(jump line)
      end
    end
    @lines.join("\n")
  end

  private
    def command_type line
      if line[0] == '@'
        return :A_COMMAND
      elsif line.index("=")
        return :C_COMMAND
      else return :L_COMMAND
      end
    end

    def symbol line
      line[1..-1]
    end

    def comp line
      line[line.index("=") + 1 .. -1]
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
    end

    def remove_blank_lines
      @lines.map! do |line|
        line.gsub!(/\s+/, "")
      end.
      reject! do |line|
        line == ""
      end
    end
end
