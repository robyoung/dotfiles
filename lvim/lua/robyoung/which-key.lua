
lvim.builtin.which_key.mappings["t"] = {
  name = "+tabs",
  n = { "<cmd>tabnext<cr>", "next" },
  p = { "<cmd>tabprevious<cr>", "previous" },
}
lvim.builtin.which_key.mappings["o"] = {
  name = "+org mode",
  ["*"] = { "toggle heading" },
  ["'"] = { "edit special" },
  ["$"] = { "archive" },
  a = { "agenda" },
  A = { "archive" },
  c = { "capture" },
  r = { "refile" },
  o = { "open" },
  e = { "export" },
  t = { "set tags" },
  K = { "move headline up" },
  J = { "move headline down" },
  x = {
    name = "clock",
    i = { "in" },
    o = { "out" },
    q = { "cancel" },
    j = { "goto" },
    e = { "effort estimate" },
  },
  i = {
    name = "insert",
    d = { "deadline" },
    s = { "schedule" },
    h = { "headline" },
    t = { "TODO" },
    T = { "TODO here" },
    ["."] = { "date under cursor" },
    ["!"] = { "inactive date under cursor" },
  }
}

require("which-key").register({
  c = {
    name = "org change",
    i = {
      name = "change",
      d = { "change date" },
      R = { "priority up" },
      r = { "priority down" },
      t = { "TODO next" },
      T = { "TODO previous" },
    }
  },
  g = {
    ["?"] = { "org mode help" },
    ["{"] = { "org parent" },
  }
}, {mode = "n", prefix = "", preset = true})
