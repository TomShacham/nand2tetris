require_relative 'parser'
require_relative 'symboltable'

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
