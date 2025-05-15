using Test, DocumenterVitepress

@testset "DocumenterVitepress" begin
    @testset "Inventory" begin
        include("inventory.jl")
    end
end