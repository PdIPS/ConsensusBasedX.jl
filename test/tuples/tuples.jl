using ConsensusBasedX, ConsensusBasedX.ConsensusBasedXLowLevel, Test

function tests()
  tuple = (; a = 1, b = 2.0, c = "three")
  @test forced_convert_2_NamedTuple(tuple) == tuple

  dict = Dict(:a => 1, :b => 2.0, :c => "three")
  @test forced_convert_2_NamedTuple(dict) == tuple

  string_dict = Dict("a" => 1, "b" => 2.0, "c" => "three")
  string_dict_tuple = forced_convert_2_NamedTuple(string_dict)
  @test string_dict_tuple.a == tuple.a
  @test string_dict_tuple.b == tuple.b
  @test string_dict_tuple.c == tuple.c

  @test_throws ArgumentError forced_convert_2_NamedTuple(values(tuple))
end

tests()
