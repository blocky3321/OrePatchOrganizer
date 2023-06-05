--- @param area BoundingBox
--- @param snapValue integer
--- @param snapToNearest boolean
function SnapArea(area, snapValue, snapToNearest)
    local newArea = area
    snapToNearest = snapToNearest or false

    --round to whole numbers
    newArea.left_top.x = math.floor(newArea.left_top.x / snapValue) * snapValue
    newArea.left_top.y = math.floor(newArea.left_top.y / snapValue) * snapValue
    newArea.right_bottom.x = math.ceil(newArea.right_bottom.x / snapValue) * snapValue
    newArea.right_bottom.y = math.ceil(newArea.right_bottom.y / snapValue) * snapValue

    --Snap to value to chunk align
    if snapToNearest then
        newArea.left_top.x = newArea.left_top.x - (newArea.left_top.x % snapValue)
        newArea.left_top.y = newArea.left_top.y - (newArea.left_top.y % snapValue)
        newArea.right_bottom.x = newArea.right_bottom.x + (newArea.right_bottom.x % snapValue) - 1
        newArea.right_bottom.y = newArea.right_bottom.y + (newArea.right_bottom.y % snapValue) - 1
    end
    return (newArea)
end

--- @param area BoundingBox
function CountArea(area)
    local width = area.right_bottom.x - area.left_top.x
    local height = area.right_bottom.y - area.left_top.y
    return width * height
end

--- @param area BoundingBox
function PrintArea(area)
    game.print("Left Top X: " .. area.left_top.x)
    game.print("Left Top Y: " .. area.left_top.y)
    game.print("Right Bottom X: " .. area.right_bottom.x)
    game.print("Right Bottom Y: " .. area.right_bottom.y)
end

--- @param area BoundingBox
function IsZeroSize(area)
    return (area.left_top.x == area.right_bottom.x and area.left_top.y == area.right_bottom.y)
end

--- @param myTable table
function GenerateIndex(myTable)
    local index = 0
    for k, _ in pairs(myTable) do
        index = index + 1
        AllResources_Index[index] = k
    end
end

--- @param myTable table
--- @param oreName string
function GetOreFromIndex(myTable, oreName)
    local index = 0
    for k, v in pairs(myTable) do
        index = index + 1
        if k == oreName then
            return index
        end
    end
end

function Format_Int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    -- reverse the int-string back remove an optional comma and put the
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end
