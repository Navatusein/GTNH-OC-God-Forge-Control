# GTNH-OC-God-Forge-Control

## Content

- [Information](#information)
- [Installation](#installation)
- [Setup](#setup)
- [Configuration](#configuration)

<a id="information"></a>

## Information

The program is designed to automate the production of Degenerate Quark Gluon Plasma 
and Molten Magmatter in the Heliofusion Exoticizer.
From the features, the program itself orders plasmas that are not enough, so you will 
not need to put a bunch of ME Level Maintainers.
It is also possible to send messages to Discord about out of service situations.
And there is also the possibility of auto update at startup.

#### Controls

<kbd>Q</kbd> - Closing the program

<kbd>Delete</kbd> - Clear scroll list

<kbd>Arrow Up</kbd> - Scroll list up

<kbd>Arrow Down</kbd> - Scroll list down

#### Interface

![Interface](/docs/interface.png)

<a id="installation"></a>

> [!CAUTION]
> If you are using 8 java, the installer will not work for you. 
> The only way to install the program is to manually transfer it to your computer.
> The problem is on the java side.

To install program, you need a computer with:
- Graphics Card (Tier 3): 1
- Central Processing Unit (CPU) (Tier 3): 1
- Memory (Tier 3.5): 2
- Hard Disk Drive (Tier 3) (4MB): 1
- EEPROM (Lua BIOS): 1
- Internet Card: 1

![Computer setup](/docs/computer.png)

Install the basic Open OS on your computer.
Then run the command to start the installer.

```shell
pastebin run ESUAMAGx
``` 

Then select the God Forge Control program in the installer.
If you wish you can add the program to auto download, for manual start write a command.

```shell
main
```

> [!NOTE]  
> For convenient configuration you can use the web configurator.
> [GTNH-OC-Web-Configurator](https://navatusein.github.io/GTNH-OC-Web-Configurator/#/configurator?url=https%3A%2F%2Fraw.githubusercontent.com%2FNavatusein%2FGTNH-OC-God-Forge-Control%2Fmain%2Fconfig-descriptor.yml)

<a id="setup"></a>

## Setup

To build a setup, you will need:

- Transposer: 1
- Adapter: 2
- Database Upgrade (Tier 3): 1
- Redstone IO: 1

> [!CAUTION]
> Be sure to use Database Upgrade (Tier 3).

For the program to work, you need to make a simple setup. On the Heliofusion Exoticizer module, 
it is necessary to connect the subnetwork that will receive dusts and liquids further it will 
be called the output subnetwork (On the diagram it is purple). It consists of “ME Dual Interface”, 
“Output Hatch (ME)”, “Output Bus (ME)”, “ME Fluid Storage Bus” and “ME Drive” where there are two 
disks for liquids of 5 types and one disk for dust. The “ME Fluid Storage Bus” is configured to send 
“Degenerate Quark Gluon Plasma” and “Molten Magmatter” to the input subnet (more about it later). 
We also have another subnet (In this guide we will consider a setup where the input subnet is our 
main subnet, but it is possible to separate them) it consists of “ME IO Port”, “ME Dual Interface” 
and “ME Fluid Level Emitter”. From now on in the guide I will refer to it as the input subnet 
(It is green in the diagram).

In the schematic we have 2 adapters connected to volume subnets, we also have a transposer 
to flip items from the output subnet to the input subnet. Also in one of the adapters we have 
“Database Upgrade (Tier 3)”.

In the input subnet “ME Dual Interface” stands in the environment of “Inventory Relay” 
which are directed to the quadruple input hatch. 

> [!CAUTION]
> To work properly, you need to put any liquid сraft template (which is pink) in the interface in input subnet.

The idea is that the program looks at what plasmas the machine wants and encodes a fake 
recipe with the right plasmas and in the right quantity, then orders this template. 
This approach makes it easy to transfer plasmas from AE to the machine and allows 
you to craft plasmas that are not enough.

![Front setup](/docs/front-setup.png)

You also need to adjust the “ME Fluid Level Emitter” to signal when the 
“Degenerate Quark Gluon Plasma” or “Molten Magmatter” is less than the 
desired amount, or you can put a lever and control it manually.

![Side setup](/docs/side-setup.png)

As for the bones of the input subnet, it is very simple. 
It must have a number of CPUs greater than the number of setups connected to it. It is 
also important that it has a “Fluid Discretizer” and all CPUs have a “Crafting Monitor”.

> [!CAUTION]
> In cases where the input subnet is your main network, the entire CPU must be equipped with a “Crafting Monitor”.

If, on the other hand, you want to separate the entry network from the main network. 
Then you need to show all 80+ plasmas in the input subnet and make the output of unnecessary 
dust and liquids from the input subnet. And make “Spatially Enlarged Fluid” and “Tachyon Rich 
Temporal Fluid” storage in it.

![Main ME](/docs/main-me.png)


<a id="configuration"></a>

## Configuration

> [!NOTE]  
> For convenient configuration you can use the web configurator.
> [GTNH-OC-Web-Configurator](https://navatusein.github.io/GTNH-OC-Web-Configurator/#/configurator?url=https%3A%2F%2Fraw.githubusercontent.com%2FNavatusein%2FGTNH-OC-God-Forge-Control%2Fmain%2Fconfig-descriptor.yml)

General configuration in file `config.lua`

Enable auto update when starting the program.

```lua
enableAutoUpdate = true, -- Enable auto update on start
```

In the `timeZone` field you can specify your time zone.

In the `discordWebhookUrl` field, you can specify the Discord Webhook link so that the program sends messages to the discord about emergency situations.
[How to Create a Discord Webhook?](https://www.svix.com/resources/guides/how-to-make-webhook-discord/)

```lua
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
```

In the `magmatterMode` field you specify program mode. If it `true` program will in be in the magmatter craft mode. 
If it `false` program will in be in the gluon plasma craft mode. 

In the `outputMeInterfaceAddress` field you specify address of the me interface witch connected to input subnet.

In the `inputMeInterfaceAddress` field you specify address of the me interface witch connected to output subnet.

In the `transposerAddress` field you specify address of the transposer witch connected to ME Drive and ME IO Port.

In the `meIoPortSide` field you specify side of the transposer witch connected to ME IO Port.

In the `meDriveSide` field you specify side of the transposer witch connected to ME Drive.

In the `redstoneIoAddress` field you specify address of the Redstone IO to switch production on and off.

In the `redstoneIoSide` field you specify side of the redstone IO which connected to ME Level Emitter or other controller.

```lua
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
```