return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        -- 'none' 會關閉預設的 Enter 補全行為
        ["<CR>"] = { "fallback" }, -- 讓 Enter 回歸原本功能（換行）

        -- 如果你想用 Tab 確認補全：
        ["<Tab>"] = { "select_and_accept", "fallback" },
      },
    },
  },
}
