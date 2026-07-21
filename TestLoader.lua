-- Mini test - Nova UI
local ok, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/junin275/NOVA_UI_LIB/main/NovaUIBuilt.lua"))()
end)
warn("Nova UI loaded:", ok, lib)

if ok and lib then
    local w = lib:CreateWindow({Title = "Nova UI - Teste", Size = UDim2.new(0, 600, 0, 400)})
    warn("Window:", w)
    local t = w:CreateTab({Name = "Teste"})
    warn("Tab:", t)
    local s = t:CreateSection({Name = "Controles"})
    s:CreateButton({Name = "Clique aqui", Callback = function() warn("Botao clicado!") end})
else
    warn("Falha ao carregar Nova UI")
end
