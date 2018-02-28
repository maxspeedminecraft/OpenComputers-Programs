--------------------------------------------------
-- Module: Paint
--------------------------------------------------
local Paint = {}

--------------------------------------------------
-- Imports
--------------------------------------------------

local component = require("component")
local gpu = component.gpu
local screen = component.screen
local term = require("term")
local os = require("os")

--------------------------------------------------
-- Globals
--------------------------------------------------

local colors = {
    white = 0xFFFFFF,
    black = 0x000000,
    red   = 0xFF0000,
    green = 0x00FF00,
    blue  = 0x0000FF,
    yellow = 0xFFFF00
}

--------------------------------------------------
-- Functions
--------------------------------------------------

function Paint.clear(color)
    color = color or colors["black"]
    local b = gpu.getBackground()
    gpu.setBackground(color)
    term.clear()
    gpu.setBackground(b)
end

function Paint.fill(x,y,w,h,color)
    local b = gpu.getBackground()
    gpu.setBackground(color)
    gpu.fill(x,y,w,h," ")
    gpu.setBackground(b)
end

function Paint.write(str,x,y,fg,bg)
    local f, b = gpu.getForeground(), gpu.getBackground()
    fg = fg or f
    bg = bg or b
    gpu.setBackground(bg)
    gpu.setForeground(fg)
    gpu.set(x,y,tostring(str))
    gpu.setBackground(b)
    gpu.setForeground(f)
end

function Paint.listwrite(tbl,x,y,fg,bg)
    local f, b = gpu.getForeground(), gpu.getBackground()
    fg = fg or f
    bg = bg or b
    gpu.setBackground(bg)
    gpu.setForeground(fg)
    for _,str in pairs(tbl) do
        gpu.set(x,y,tostring(str))
        y = y + 1
    end
    gpu.setBackground(b)
    gpu.setForeground(f)
end

--------------------------------------------------
--------------------------------------------------
return Paint