using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function tests()
  @test get_val("string") isa String
  @test get_val(:symbol) isa Symbol
  @test get_val(Val(:val)) isa Symbol
  @test get_val(Val(:val)) == :val
end

tests()
