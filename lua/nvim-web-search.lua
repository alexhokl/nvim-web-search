local M = {}

local default_options = {
  keymaps = {
    ["jp"] = "https://www.google.com/search?q={}",
  }
}

local function get_visual_selection()
  -- Save the current register 'a' content
  local a_save = vim.fn.getreg('a')
  local a_save_type = vim.fn.getregtype('a')

  -- Yank the visual selection to register 'a'
  vim.cmd('normal! "ay')

  -- Get the yanked text
  local selection = vim.fn.getreg('a')

  -- Restore the original register 'a' content
  vim.fn.setreg('a', a_save, a_save_type)

  return selection
end

local function open_browser(url_template)
  local selected_text = get_visual_selection()
  local url = url_template:gsub("{}", selected_text)
  vim.fn.jobstart({ "open", url }, { detach = true })
end

M.setup = function(options)
  M.options = vim.tbl_deep_extend("force", default_options, options or {})
  for keymap, url_template in pairs(M.options.keymaps) do
    vim.keymap.set(
      "x",
      keymap,
      function() open_browser(url_template) end,
      { noremap = true, silent = true }
    )
  end
end

return M
