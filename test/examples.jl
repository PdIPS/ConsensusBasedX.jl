tests() =
  for (root, dirs, files) ∈ walkdir("../examples")
    for file ∈ files
      if !contains(file, "visualisation")
        path = joinpath(root, file)
        test_name = "Example: " * file
        @eval begin
          @safetestset $test_name begin
            @test_nowarn include($path)
          end
        end
      end
    end
  end

tests()
