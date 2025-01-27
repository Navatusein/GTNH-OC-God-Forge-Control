local keyboard = require("keyboard")

local programLib = require("lib.program-lib")
local guiLib = require("lib.gui-lib")

local scrollList = require("lib.gui-widgets.scroll-list")

package.loaded.config = nil
local config = require("config")

local version = require("version")

local repository = "Navatusein/GTNH-OC-God-Forge-Control"
local archiveName = "GodForgeControl"

local program = programLib:new(config.logger, config.enableAutoUpdate, version, repository, archiveName)
local gui = guiLib:new(program)

local logo = {
"  ____           _       _____                       ____            _             _ _           ",
" / ___| ___   __| |___  |  ___|__  _ __ __ _  ___   / ___|___  _ __ | |_ _ __ ___ | | | ___ _ __ ",
"| |  _ / _ \\ / _` / __| | |_ / _ \\| '__/ _` |/ _ \\ | |   / _ \\| '_ \\| __| '__/ _ \\| | |/ _ \\ '__|",
"| |_| | (_) | (_| \\__ \\ |  _| (_) | | | (_| |  __/ | |__| (_) | | | | |_| | | (_) | | |  __/ |   ",
" \\____|\\___/ \\__,_|___/ |_|  \\___/|_|  \\__, |\\___|  \\____\\___/|_| |_|\\__|_|  \\___/|_|_|\\___|_|   ",
"                                       |___/                                                  "
}

local mainTemplate = {
  width = 60,
  background = gui.palette.black,
  foreground = gui.palette.white,
  widgets = {
    logsScrollList = scrollList:new("logsScrollList", "logs", keyboard.keys.up, keyboard.keys.down)
  },
  lines = {
    "Mode: $mode$",
    "Status: $state$",
    "",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#",
    "#logsScrollList#"
  }
}

local function init()
  gui:setTemplate(mainTemplate)
  os.sleep(0.1)
  config.controller:init()
end

local function loop()
  while true do
    config.controller:loop()
    os.sleep(1)
  end
end

local function guiLoop()
  gui:render({
    mode = config.controller.magmatterMode and "Magmatter" or "Gluon Plasma",
    state = config.controller.stateMachine.currentState ~= nil and config.controller.stateMachine.currentState.name or "nil",
    logs = config.logger.handlers[3]["logs"].list
  })
end

local function errorButtonHandler()
  config.controller:resetError()
end

local function clearErrorList()
  ---@type ScrollListLoggerHandler|LoggerHandler
  local logger = config.logger.handlers[3]
  logger:clearList()
end

program:registerLogo(logo)
program:registerInit(init)
program:registerThread(loop)
program:registerTimer(guiLoop, math.huge)
program:registerKeyHandler(keyboard.keys.enter, errorButtonHandler)
program:registerKeyHandler(keyboard.keys.delete, clearErrorList)
program:start()