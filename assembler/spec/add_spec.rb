require_relative '../src/assembler'

describe 'assembler ' do

  it 'assembles add.asm' do
    assembler = Assembler.new 'spec/Add.asm'
    expect(assembler.assemble).to eq "0000000000000010
    1110110000010000
    0000000000000011
    1110000010010000
    0000000000000000
    1110001100001000".gsub(/\ \ \ \ /,"")
  end

end
