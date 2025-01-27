local sides = require("sides")

local loggerLib = require("lib.logger-lib")
local discordLoggerHandler = require("lib.logger-handler.discord-logger-handler-lib")
local fileLoggerHandler = require("lib.logger-handler.file-logger-handler-lib")
local scrollListLoggerHandler = require("lib.logger-handler.scroll-list-logger-handler-lib")

local heliofusionExoticizerController = require("src.heliofusion-exoticizer-controller")

local config = {
  enableAutoUpdate = true, -- Enable auto update on start

  logger = loggerLib:newFormConfig({
    name = "God Forge Control",
    timeZone = 3, -- Your time zone
    handlers = {
      discordLoggerHandler:newFormConfig({
        logLevel = "warning",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        discordWebhookUrl = "" -- Discord Webhook URL
      }),
      fileLoggerHandler:newFormConfig({
        logLevel = "info",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        filePath = "logs.log"
      }),
      scrollListLoggerHandler:newFormConfig({
        logLevel = "debug",
        logsListSize = 32
      }),
    }
  }),


  controller = heliofusionExoticizerController:newFormConfig({
    magmatterMode = false, -- Enable mode of production magmatter.
    outputMeInterfaceAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of me interface which connected to output AE.
    inputMeInterfaceAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of me interface which connected to input AE.
    transposerAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of transposer.
    meIoPortSide = sides.east, -- Side of the transposer which connected to input AE ME IO Port.
    meDriveSide = sides.west, -- Side of the transposer which connected to output AE ME Drive.
    redstoneIoAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Redstone IO Address.
    redstoneIoSide = sides.east -- Side of the redstone IO which connected to ME Level Emitter or other controller.
  })
}

return config