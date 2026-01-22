-- textAnim.lua

local TextAnim = {}
TextAnim.__index = TextAnim

function TextAnim.new(text, delay, x, y)
    local self = setmetatable({}, TextAnim)
    self:setText(text or "")
    self.delay = delay or 0.1
    self.x = x or 10
    self.y = y or 10
    self.time = 0
    self.isComplete = false
    return self
end

function TextAnim:setText(newText)
    self.fullText = newText or ""
    self.displayedText = ""
    self.chars = {}
    
    -- Разбиваем строку на символы UTF-8
    for i = 1, #self.fullText do
        local byte = self.fullText:byte(i)
        if byte < 128 or byte >= 192 then
            table.insert(self.chars, i)
        end
    end
    table.insert(self.chars, #self.fullText + 1)
    
    self.currentChar = 1
    self.time = 0
    self.isComplete = false
end

function TextAnim:setDelay(newDelay)
    self.delay = newDelay
end

function TextAnim:setPosition(newX, newY)
    self.x = newX
    self.y = newY
end

function TextAnim:update(dt)
    if not self.isComplete and self.currentChar < #self.chars then
        self.time = self.time + dt
        if self.time >= self.delay then
            self.time = 0
            local startIndex = self.chars[self.currentChar]
            local endIndex = self.chars[self.currentChar + 1] - 1
            self.displayedText = self.displayedText .. self.fullText:sub(startIndex, endIndex)
            self.currentChar = self.currentChar + 1
            
            if self.currentChar >= #self.chars then
                self.isComplete = true
            end
        end
    end
end

function TextAnim:draw()
    if #self.displayedText > 0 then
        love.graphics.print(self.displayedText, self.x, self.y)
    end
end

function TextAnim:skip()
    self.displayedText = self.fullText
    self.currentChar = #self.chars
    self.isComplete = true
end

return TextAnim