return {
    "rcarriga/nvim-notify",
    config = function()
        local notify = require("notify")

        notify.setup({
            stages = "fade",
            timeout = 3000,
            background_colour = "#1e222a",
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎",
            },
        })

        -- Set nvim-notify as the default notification handler
        vim.notify = notify
    end,
}

