local configManager = require("lib.config-manager.index")
local logger = require("lib.oc-logger.index")

local heliofusionExoticizerController = require("src.heliofusion-exoticizer-controller")

---@class Config
---@field enableAutoUpdate boolean
---@field logger Logger
---@field controller HeliofusionExoticizerController

local configTemplate = {
  enableAutoUpdate = configManager.validators.boolean:new(),

  logger = configManager.validators.object:new(
    {
      template = {
        name = configManager.validators.string:new(),
        timeZone = configManager.validators.number:new({
          isInteger = {value = true}
        }),
        handlers = configManager.validators.typedObjectList:new({
          templates = {
            ["discord"] = configManager.validators.object:new(
              {
                template = {
                  logLevel = configManager.validators.enum:new({
                    "debug", "info", "warning", "error"
                  }),
                  messageFormat = configManager.validators.string:new(),
                  discordWebhookUrl = configManager.validators.string:new({
                    isNullable = {value = true}
                  }),
                },
                objectFactory = function (value)
                  return logger.handlers.discord:new(value.logLevel, value.messageFormat, value.discordWebhookUrl)
                end
              }
            ),
            ["file"] = configManager.validators.object:new(
              {
                template = {
                  logLevel = configManager.validators.enum:new({
                    "debug", "info", "warning", "error"
                  }),
                  messageFormat = configManager.validators.string:new(),
                  filePath = configManager.validators.string:new(),
                },
                objectFactory = function (value)
                  return logger.handlers.file:new(value.logLevel, value.messageFormat, value.filePath)
                end
              }
            ),
            ["scrollList"] = configManager.validators.object:new(
              {
                template = {
                  logLevel = configManager.validators.enum:new({
                    "debug", "info", "warning", "error"
                  }),
                  messageFormat = configManager.validators.string:new(),
                  logsListSize = configManager.validators.number:new({
                    min = {value = 5}
                  }),
                },
                objectFactory = function (value)
                  return logger.handlers.scrollList:new(value.logLevel, value.logsListSize)
                end
              }
            ),
          }
        }),
      },
      objectFactory = function (value)
        return logger.logger:new(value.name, value.timeZone, value.handlers)
      end
    }
  ),

  controller = configManager.validators.object:new({
    template = {
      magmatterMode = configManager.validators.boolean:new(),
      outputMeInterfaceAddress = configManager.validators.address:new(),
      inputMeInterfaceAddress = configManager.validators.address:new(),
      transposerAddress = configManager.validators.address:new(),
      meIoPortSide = configManager.validators.side:new(),
      meDriveSide = configManager.validators.side:new(),
      redstoneIoAddress = configManager.validators.address:new(),
      redstoneIoSide = configManager.validators.side:new(),
    },
    objectFactory = function (value)
      return heliofusionExoticizerController:new(
        value.magmatterMode,
        value.outputMeInterfaceAddress,
        value.inputMeInterfaceAddress,
        value.transposerAddress,
        value.redstoneIoAddress,
        value.meIoPortSide,
        value.meDriveSide,
        value.redstoneIoSide
      )
    end
  })
}

return configTemplate