local keyboard = require("keyboard")

local configManager = require("lib.config-manager.index")
local programController = require("lib.program-controller.index")
local simpleGui = require("lib.simple-gui.index")

local configTemplate = require("src.config-template")
local scrollList = require("src.gui-widgets.scroll-list")

package.loaded.config = nil
local config = require("config")
local version = require("version")

---@type Config
local config = configManager.manager:new(configTemplate):build(config)

local repository = "Navatusein/GTNH-OC-God-Forge-Control"
local branch = "main"
local archiveName = "GodForgeControl"

local program = programController.program:new(config.enableAutoUpdate, version, repository, branch, archiveName)
local gui = simpleGui.gui:new(program)

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
    logsScrollList = scrollList:new("logs", keyboard.keys.up, keyboard.keys.down)
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
    state = config.controller:getCurrentState(),
    logs = config.logger.handlers["scrollList"]["logs"]
  })
end

local function errorButtonHandler()
  config.controller:resetError()
end

local function clearErrorList()
  ---@type ScrollListLoggerHandler|LoggerHandler
  local logger = config.logger.handlers["scrollList"]
  logger:clearLogs()
end

program:registerLogo(logo)
program:registerOnInit(init)
program:registerThread(loop)
program:registerTimer(guiLoop, math.huge, 1)
program:registerKeyHandler(keyboard.keys.enter, errorButtonHandler)
program:registerKeyHandler(keyboard.keys.delete, clearErrorList)
program:start()