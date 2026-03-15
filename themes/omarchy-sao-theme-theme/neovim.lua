return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#000000",
                bg_dark = "#000000",
                bg_highlight = "#2c3066",

                -- Foreground colors
                -- fg: Object properties, builtin types, builtin variables, member access, default text
                fg = "#cccccc",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#97d3df",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#2c3066",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#1720ab",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#303ded",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#40b2e3",
                -- green: Comments, strings, success states, git additions
                green = "#13b3f1",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#5c91b2",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#1e2cd2",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#1134ee",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#5f77fc",
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
