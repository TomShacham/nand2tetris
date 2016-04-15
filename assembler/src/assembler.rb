require_relative 'parser'

class Assembler
  attr_accessor :output
  def initialize file
    f = File.new(file)
    parser = Parser.new f.readlines
    @output = parser.parse
  end
  def assemble
    @output
  end
end
