return {
    'numToStr/Comment.nvim',
    opts = {
        pre_hook = function(ctx)
            local comment_ft = require('Comment.ft')
            local ok, commentstring = pcall(comment_ft.calculate, ctx)

            if ok and commentstring then
                return commentstring
            end

            return comment_ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
        end,
    },
    config = function(_, opts)
        require('Comment.ft').set('tsx', { '//%s', '/*%s*/' })
        require('Comment').setup(opts)
    end,
}
