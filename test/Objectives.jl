using CBX.Objectives
using Test

function test_Quadratic()
  ob = Quadratic()
  ob_twice = Quadratic(α = 2)

  ### Test minimum
  @test apply!(ob, [0.0]) == 0
  @test apply!(ob, [0.0, 0.0]) == 0
  @test apply!(ob_twice, [0.0, 0.0, 0.0]) == 0

  ### Test reference values
  @test apply!(ob, [1.0]) == 1 / 2
  @test apply!(ob, [3.0, 4.0]) == 5^2 / 2
  @test apply!(ob_twice, [3.0, 4.0, 12.0]) == 13^2
end

function test_Rastrigin()
  ob = Rastrigin()
  ob_shift_2 = Rastrigin(b = 2)
  ob_plus_3 = Rastrigin(c = 3)

  ### Test minimum
  @test apply!(ob, [0.0]) == 0
  @test apply!(ob, [0.0, 0.0]) == 0
  @test apply!(ob, [0.0, 0.0, 0.0]) == 0

  @test apply!(ob_shift_2, [2.0]) == 0
  @test apply!(ob_shift_2, [2.0, 2.0]) == 0
  @test apply!(ob_shift_2, [2.0, 2.0, 2.0]) == 0

  @test apply!(ob_plus_3, [0.0]) == 3
  @test apply!(ob_plus_3, [0.0, 0.0]) == 3
  @test apply!(ob_plus_3, [0.0, 0.0, 0.0]) == 3

  ### Test reference values (from https://en.wikipedia.org/wiki/Rastrigin_function)
  ### Note values are scaled by 1/d
  @test apply!(ob, [1.0, 0.0]) == 1 / 2
  @test apply!(ob, [1.0, -1.0]) == 2 / 2
  @test apply!(ob, [2.0, -1.0]) == 5 / 2
  @test apply!(ob, [2.0, -2.0]) == 8 / 2
  @test apply!(ob, [3.0, -2.0]) == 13 / 2
  @test apply!(ob, [3.0, -3.0]) == 18 / 2
  @test apply!(ob, [4.0, -3.0]) == 25 / 2
  @test apply!(ob, [4.0, -4.0]) == 32 / 2
  @test apply!(ob, [-4.5, 4.5]) == 80.5 / 2
end

function tests()
  @testset "Quadratic" test_Quadratic()
  @testset "Rastrigin" test_Rastrigin()
end

tests()
