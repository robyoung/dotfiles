local colorscheme = "catppuccin"

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end

require("catppuccin").setup {
    flavour = "auto",
    background = {
        light = "latte",
        dark = "mocha"
    },

}
