---@module 'luassert'

local util = require('tests.util')

---@param row integer
---@param icon string
---@param highlight string
---@return render.md.MarkInfo[]
local function checkbox(row, icon, highlight)
    ---@type render.md.MarkInfo
    local conceal_mark = {
        row = { row, row },
        col = { 0, 2 },
        conceal = '',
    }
    ---@type render.md.MarkInfo
    local checkbox_mark = {
        row = { row, row },
        col = { 2, 5 },
        virt_text = { { icon, util.hl(highlight) } },
        virt_text_pos = 'inline',
        conceal = '',
    }
    return { conceal_mark, checkbox_mark }
end

---@param row integer
---@return render.md.MarkInfo
local function dash(row)
    ---@type render.md.MarkInfo
    return {
        row = { row },
        col = { 0 },
        virt_text = { { string.rep('─', vim.opt.columns:get()), util.hl('Dash') } },
        virt_text_pos = 'overlay',
    }
end

describe('box_dash_quote.md', function()
    it('default', function()
        util.setup('demo/box_dash_quote.md')

        local expected, row = {}, util.row()

        vim.list_extend(expected, util.heading(row:get(), 1))

        vim.list_extend(expected, {
            checkbox(row:increment(2), '󰄱 ', 'Unchecked'),
            checkbox(row:increment(), '󰱒 ', 'Checked'),
            checkbox(row:increment(), '󰥔 ', 'Todo'),
            util.bullet(row:increment(), 0, 1),
        })

        table.insert(expected, dash(row:increment(2)))

        vim.list_extend(expected, {
            util.quote(row:increment(2), '  %s ', 'Quote'),
            util.quote(row:increment(), '  %s ', 'Quote'),
        })

        local actual = util.get_actual_marks()
        util.marks_are_equal(expected, actual)
    end)
end)
