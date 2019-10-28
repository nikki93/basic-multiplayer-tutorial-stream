require 'common'

local server = clientServer.server

if USE_LOCAL_SERVER then
    server.enabled = true
    server.start('22122')
else
    server.useCastleConfig()
end

local share = server.share
local homes = server.homes

function server.load()
    share.players = {}
end

function server.connect(clientId)
    print('server: client ' .. clientId .. ' connected!')

    share.players[clientId] = {
        x = math.random(40, 800 - 40),
        y = math.random(40, 450 - 40),
    }
end

function server.disconnect(clientId)
    print('server: client ' .. clientId .. ' disconnected!')

    share.players[clientId] = nil
end

function server.receive(clientId, message, ...)
    if message == 'pressedKey' then
        local key = ...
        server.send('all', 'otherClientPressedKey', clientId, key)
    end
end

function server.update(dt)
    for clientId, player in pairs(share.players) do
        local home = homes[clientId]
        if home.x and home.y then
            player.x, player.y = home.x, home.y
        end

        if home.me and not player.me then
            player.me = home.me
        end
    end
end