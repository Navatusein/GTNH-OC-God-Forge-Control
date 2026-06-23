local sides = require("sides")

local config = {
  enableAutoUpdate = true, -- Enable auto update on start

  logger = {
    name = "God Forge Control",
    timeZone = 3, -- Your time zone
    handlers = {
      ["discord"] = {
        type = "discord",
        logLevel = "warning",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        discordWebhookUrl = "" -- Discord Webhook URL
      },
      ["file"] = {
        type = "file",
        logLevel = "info",
        messageFormat = "{Time:%d.%m.%Y %H:%M:%S} [{LogLevel}]: {Message}",
        filePath = "logs.log"
      },
      ["scrollList"] = {
        type = "scrollList",
        logLevel = "debug",
        logsListSize = 32
      },
    }
  },

  controller = {
    magmatterMode = false, -- Enable mode of production magmatter.
    outputMeInterfaceAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of me interface which connected to output AE.
    inputMeInterfaceAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of me interface which connected to input AE.
    transposerAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Address of transposer.
    meIoPortSide = sides.east, -- Side of the transposer which connected to input AE ME IO Port.
    meDriveSide = sides.west, -- Side of the transposer which connected to output AE ME Drive.
    redstoneIoAddress = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", -- Redstone IO Address.
    redstoneIoSide = sides.east -- Side of the redstone IO which connected to ME Level Emitter or other controller.
  }
}

return config
