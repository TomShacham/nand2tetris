class SymbolTable
  attr_accessor :table, :heap_counter

  def initialize
    @heap_counter = 15
    @table = {
      "SP" => 0,
      "LCL" => 1,
      "ARG" => 2,
      "THIS" => 3,
      "THAT" => 4,
      "R0" => 0, "R1" => 1, "R2" => 2, "R3" => 3,
      "R4" => 4, "R5" => 5, "R6" => 6, "R7" => 7,
      "R8" => 8, "R9" => 9, "R10" => 10, "R11" => 11,
      "R12" => 12, "R13" => 13, "R14" => 14, "R15" => 15,
      "SCREEN" => 16384,
      "KEYBOARD" => 24576
    }
  end

  def add_entry symbol, pc
    return if contains? symbol
    @table[symbol] = pc
  end

  def add_var symbol
    @heap_counter += 1
    @table[symbol] = @heap_counter
  end

  def contains? symbol
    @table.has_key? symbol
  end

  def get_address symbol
    @table[symbol]
  end
end
