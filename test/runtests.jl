using Test
import OMKParser

@testset "Simple standalone modules" begin

  @test true == begin
    try
      res = OMKParser.parseFile("HelloWorld.mo")
      true
    catch err
      @info("Test failed with the following error:")
      @info "Error:" err
      false
    end
  end
  
  @test true == begin
    try
      res = OMKParser.parseFile("Influenza.mo")
      true
    catch err
      @info("Test failed with the following error:")
      @info "Error:" err
      false
    end
  end
  
  @test true == begin
    try
      res = OMKParser.parseFile("Casc12800.mo")
      true
    catch err
      @info("Test failed with the following error:")
      @info "Error:" err
      false
    end
  end
  
end

@testset "Test OMCompiler.jl specific extensions" begin
  @test true == begin
    try
      res = OMKParser.parseFile("BreakingPendulum.mo")
      true
    catch err
      @info("Test failed with the following error:")
    @info "Error:" err
      false
    end
  end
end

#= Warning might be flaky... =#
@testset "Standard Library" begin
  @test true == begin
    try
      res = OMKParser.parseFile("msl.mo")
      true
    catch err
      @info("Test failed with the following error:")
      @info "Error:" err
      false
    end
  end
end
