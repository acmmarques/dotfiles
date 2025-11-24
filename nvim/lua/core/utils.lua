--This file has my own functions
-- Function to execute a shell command and show the output via nvim-notify
function notify_shell_command(cmd)
    -- Execute the shell command
    local handle = io.popen(cmd)
    local output = handle:read("*a")
    handle:close()

    -- Display the output using nvim-notify
    if output and output ~= "" then
        require("notify")(output, "info", {
            title = "Shell Command Output",
            timeout = 5000,  -- Adjust timeout as needed
            on_open = function(window)
                local buffer = vim.api.nvim_win_get_buf(window)
                -- Wrap lines for better display
                vim.api.nvim_buf_set_option(buffer, "wrap", true)
                vim.api.nvim_buf_set_option(buffer, "modifiable", false)
            end,
        })
    else
        require("notify")("No output", "warn", { title = "Shell Command Output" })
    end
end

function prompt_and_notify_command()
    -- Ask the user for a command
    vim.fn.inputsave()  -- Ensure the input buffer is saved properly
    local cmd = vim.fn.input("$: ")  -- Using Neovim's input to get user input
    vim.fn.inputrestore()  -- Restore after input

    -- Call notify_shell_command if a command was entered
    if cmd and cmd ~= "" then
        notify_shell_command(cmd)
    else
        require("notify")("No command entered", "warn", { title = "Input Error" })
    end
end

-- Set up a key mapping to call prompt_and_notify_command
vim.api.nvim_set_keymap('n', '<leader>sc', [[<cmd>lua prompt_and_notify_command()<CR>]], { noremap = true, silent = true })
