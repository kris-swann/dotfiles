require("obsidian").setup({
  dir = "~/Notes",
  disable_frontmatter = true,
  completion = {
    -- nvim_cmp = true,
  },
  daily_notes = {
    folder = "Content/Daily",
  },
})
