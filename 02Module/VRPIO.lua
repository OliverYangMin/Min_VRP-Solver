-- name: VRPIO
-- purpose: Open VRP instance files and processing the data
-- start date: 2019-04-19
-- update log: 
-- 20190419-create the module      
-- authors: YangMin
module(..., package.seeall)

function read_solomon(filename, size)
    --vehicle types = 1, customer types = 1, customer size = size
    local inputf = assert(io.open('00Data/solomon/' .. size .. '/' .. filename, 'r'))
    nodes, Dis, Time, vehicle = {}, {}, {}, {{}}
    local i, sign, cap = 1, 0
    local column = {'id', 'x', 'y', 'weight', 'time1', 'time2', 'stime'}
    for line in inputf:lines() do
        if i>9 then 
            local node = {volume=0}
            local j = 1 
            for element in string.gmatch(line, "[0-9%.]+") do
                node[column[j]] = tonumber(string.match(element,'[0-9%.]+'))
                j = j + 1
            end
            if node.x then
                nodes[sign] = node
                sign = sign + 1
            end 
        end 
        if (not vehicle[1].cap) and i==5 then
            vehicle[1].cap = tonumber(string.match(line, "[0-9%.]+$"))
        end
        i = i + 1
    end 
    inputf:close()
    for i=0,nodes do
        Dis[i] = {}
        for j=0,#nodes do
            Dis[i][j] = i==j and false or math.floor(math.sqrt((nodes[i].x - nodes[j].x)^2 + (nodes[i].y - nodes[j].y)^2)+0.5)
        end 
    end 
    for i=0,#nodes do
        Time[i] = {}
        for j=0,#nodes do
            Time[i][j] = i==j and false or math.floor(math.sqrt((nodes[i].x - nodes[j].x)^2 + (nodes[i].y - nodes[j].y)^2)+0.5)
        end 
    end  
end 