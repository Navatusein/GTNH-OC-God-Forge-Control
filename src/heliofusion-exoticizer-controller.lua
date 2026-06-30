local event = require("event")
local computer = require("computer")
local term = require("term")

local classBuilder = require("lib.class-builder.index")
local componentDiscover = require("lib.component-discover.index")
local stateMachineBuilder = require("lib.state-machine-builder.index")

---@class OutputItem
---@field label string
---@field count number
---@field isLiquid boolean

---@class HeliofusionExoticizerData
---@field time number
---@field notifyLongIdle boolean
---@field notifyLongEndTime boolean
---@field waitEndTime number
---@field craftFailCount integer
---@field errorResetDelay integer
---@field outputs? table<string, OutputItem>
---@field errorMessage? string

---@type table<"Gluon"|"Magmatter", table<string, string>>
local plasmaList = {
  ["Gluon"] = {
    ["Aluminium"] = "plasma.aluminium",
    ["Americium"] = "plasma.americium",
    ["Antimony"] = "plasma.antimony",
    ["Ardite"] = "plasma.ardite",
    ["Argon"] = "plasma.argon",
    ["Arsenic"] = "plasma.arsenic",
    ["Barium"] = "plasma.barium",
    ["Beryllium"] = "plasma.beryllium",
    ["Cadmium"] = "plasma.cadmium",
    ["Caesium"] = "plasma.caesium",
    ["Calcium"] = "plasma.calcium",
    ["Carbon"] = "plasma.carbon",
    ["Cerium"] = "plasma.cerium",
    ["Chlorine"] = "plasma.chlorine",
    ["Cobalt"] = "plasma.cobalt",
    ["Copper"] = "plasma.copper",
    ["Curium"] = "plasma.curium",
    ["Desh"] = "plasma.desh",
    ["Deuterium"] = "plasma.deuterium",
    ["Dysprosium"] = "plasma.dysprosium",
    ["Erbium"] = "plasma.erbium",
    ["Europium"] = "plasma.europium",
    ["Fluorine"] = "plasma.fluorine",
    ["Gadolinium"] = "plasma.gadolinium",
    ["Gallium"] = "plasma.gallium",
    ["Germanium"] = "plasma.germanium",
    ["Gold"] = "plasma.gold",
    ["Hafnium"] = "plasma.hafnium",
    ["Helium"] = "plasma.helium",
    ["Holmium"] = "plasma.holmium",
    ["Hydrogen"] = "plasma.hydrogen",
    ["Indium"] = "plasma.indium",
    ["Iodine"] = "plasma.iodine",
    ["Iron"] = "plasma.iron",
    ["Lanthanum"] = "plasma.lanthanum",
    ["Lithium"] = "plasma.lithium",
    ["Lutetium"] = "plasma.lutetium",
    ["Magnesium"] = "plasma.magnesium",
    ["Manganese"] = "plasma.manganese",
    ["Mercury"] = "plasma.mercury",
    ["Meteoric Iron"] = "plasma.meteoriciron",
    ["Molybdenum"] = "plasma.molybdenum",
    ["Neodymium"] = "plasma.neodymium",
    ["Nickel"] = "plasma.nickel",
    ["Niobium"] = "plasma.niobium",
    ["Nitrogen"] = "plasma.nitrogen",
    ["Oriharukon"] = "plasma.oriharukon",
    ["Palladium"] = "plasma.palladium",
    ["Phosphorus"] = "plasma.phosphorus",
    ["Potassium"] = "plasma.potassium",
    ["Praseodymium"] = "plasma.praseodymium",
    ["Promethium"] = "plasma.promethium",
    ["Radon"] = "plasma.radon",
    ["Raw Silicon"] = "plasma.silicon",
    ["Rhenium"] = "plasma.rhenium",
    ["Rhodium"] = "plasma.rhodium",
    ["Rubidium"] = "plasma.rubidium",
    ["Ruthenium"] = "plasma.ruthenium",
    ["Samarium"] = "plasma.samarium",
    ["Silver"] = "plasma.silver",
    ["Sodium"] = "plasma.sodium",
    ["Strontium"] = "plasma.strontium",
    ["Sulfur"] = "plasma.sulfur",
    ["Tantalum"] = "plasma.tantalum",
    ["Tellurium"] = "plasma.tellurium",
    ["Terbium"] = "plasma.terbium",
    ["Thallium"] = "plasma.thallium",
    ["Thorium 232"] = "plasma.thorium232",
    ["Thulium"] = "plasma.thulium",
    ["Tin"] = "plasma.tin",
    ["Titanium"] = "plasma.titanium",
    ["Tritium"] = "plasma.tritium",
    ["Tungsten"] = "plasma.tungsten",
    ["Uranium 235"] = "plasma.uranium235",
    ["Uranium 238"] = "plasma.uranium",
    ["Vanadium"] = "plasma.vanadium",
    ["Ytterbium"] = "plasma.ytterbium",
    ["Yttrium"] = "plasma.yttrium",
    ["Zinc"] = "plasma.zinc",
    ["Zirconium"] = "plasma.zirconium"
  },
  ["Magmatter"] = {
    ["Awakened Draconium"] = "plasma.draconiumawakened",
    ["Bedrockium"] = "plasma.bedrockium",
    ["Celestial Tungsten"] = "plasma.celestialtungsten",
    ["Chromatic Glass"] = "plasma.chromaticglass",
    ["Cosmic Neutronium"] = "plasma.cosmicneutronium",
    ["Draconium"] = "plasma.draconium",
    ["Dragonblood"] = "plasma.dragonblood",
    ["Flerovium"] = "plasma.flerovium_gt5u",
    ["Hypogen"] = "plasma.hypogen",
    ["Ichorium"] = "plasma.ichorium",
    ["Infinity"] = "plasma.infinity",
    ["Neutronium"] = "plasma.neutronium",
    ["Rhugnor"] = "plasma.rhugnor",
    ["Six-Phased Copper"] = "plasma.sixphasedcopper",
    ["Tritanium"] = "plasma.tritanium",
    ["Spatially Enlarged Fluid"] = "spatialfluid",
    ["Tachyon Rich Temporal Fluid"] = "temporalfluid"
  }
}

---@class HeliofusionExoticizerController
---@field stateMachine StateMachine<HeliofusionExoticizerData>
---@field magmatterMode boolean
---@field meIoPortSide number
---@field meDriveSide number
---@field redstoneIoSide number
---@field outputMeInterfaceAddress string
---@field inputMeInterfaceAddress string
---@field transposerAddress string
---@field redstoneIoAddress string
---@field inputMeInterfaceProxy fluid_interface
---@field outputMeInterfaceProxy fluid_interface
---@field transposerProxy transposer
---@field redstoneIoProxy redstone
---@field databaseProxy database
---@field fakeRecipeName string
local heliofusionExoticizerController = {}

---Constructor
---@param magmatterMode boolean
---@param outputMeInterfaceAddress string
---@param inputMeInterfaceAddress string
---@param transposerAddress string
---@param redstoneIoAddress string
---@param meIoPortSide number
---@param meDriveSide number
---@param redstoneIoSide number
---@return HeliofusionExoticizerController
function heliofusionExoticizerController:constructor(
  magmatterMode,
  outputMeInterfaceAddress,
  inputMeInterfaceAddress,
  transposerAddress,
  redstoneIoAddress,
  meIoPortSide,
  meDriveSide,
  redstoneIoSide
)
  self.magmatterMode = magmatterMode
  self.meIoPortSide = meIoPortSide
  self.meDriveSide = meDriveSide
  self.redstoneIoSide = redstoneIoSide

  self.outputMeInterfaceAddress = outputMeInterfaceAddress
  self.inputMeInterfaceAddress = inputMeInterfaceAddress
  self.transposerAddress = transposerAddress
  self.redstoneIoAddress = redstoneIoAddress

  self.stateMachine = stateMachineBuilder.stateMachine:new()

  return self
end

---Init
function heliofusionExoticizerController:init()
  term.clear()

  term.write("Init components: ")
  self:initComponents()
  term.write("ok\n")

  term.write("Init state machine: ")
  self:initStateMachine()
  term.write("ok\n")

  term.write("Reset to idle state: ")
  self:resetToIdleState()
  term.write("ok\n")
end

---Loop
function heliofusionExoticizerController:loop()
  self.stateMachine:loop()
end

---Get current state
---@return string
function heliofusionExoticizerController:getCurrentState()
  return self.stateMachine:getCurrentStateName()
end

---Reset error state
function heliofusionExoticizerController:resetError()
  if self.stateMachine:getCurrentStateKey() == "error" then
    self.stateMachine:setState("idle")
  end
end

---Init components
---@private
function heliofusionExoticizerController:initComponents()
  self.outputMeInterfaceProxy = componentDiscover.proxy(self.outputMeInterfaceAddress, "fluid_interface", "Output Me Interface")
  self.inputMeInterfaceProxy = componentDiscover.proxy(self.inputMeInterfaceAddress, "fluid_interface", "Input Me Interface")
  self.transposerProxy = componentDiscover.proxy(self.transposerAddress, "transposer", "Transposer")
  self.redstoneIoProxy = componentDiscover.proxy(self.redstoneIoAddress, "redstone", "Redstone io")

  self.databaseProxy = componentDiscover.component("database", "Database")

  self.fakeRecipeName = "Fake recipe "..self.databaseProxy.address:sub(0, 8)

  self.databaseProxy.set(1, "minecraft:paper", 0, "{display:{Name:\""..self.fakeRecipeName.."\"}}")
end

---Init state machine
---@private
function heliofusionExoticizerController:initStateMachine()
  self.stateMachine:createState("idle", "Idle", {
    onInit = function ()
      self.stateMachine.data.time = computer.uptime()
      self.stateMachine.data.notifyLongIdle = false

      if self.stateMachine.data.notifyLongEndTime == true then
        event.push("log_warning", "Successfully went to Idle state after a long Wait End state")
      end
    end,
    onUpdate = function ()
      local signal = self.redstoneIoProxy.getInput(self.redstoneIoSide)

      if signal ~= 0 then
        local items, itemsCount = self:getOutputs()
        local diff = math.ceil(computer.uptime() - self.stateMachine.data.time)

        if itemsCount >= (self.magmatterMode == true and 3 or 7) then
          self.stateMachine.data.outputs = items
          self.stateMachine:setState("encodeFakePattern")
        elseif diff > 240 and self.stateMachine.data.notifyLongIdle == false then
          self.stateMachine.data.notifyLongIdle = true
          event.push("log_warning", "More than four minutes in the idle state: "..diff)
        end
      end
    end
  })

  self.stateMachine:createState("encodeFakePattern", "Encode Fake Pattern", {
    onInit = function ()
      if self.stateMachine.data.notifyLongIdle == true then
        event.push("log_warning", "Successfully went to Encode Fake Pattern state after a long Idle state")
      end

      local success, outputsCount = self:encodePattern(self.stateMachine.data.outputs)

      if success == false then
        self.stateMachine.data.errorMessage = "Found an unidentified object in the output subnet"
        self.stateMachine.data.errorResetDelay = 0
        self.stateMachine:setState("error")
        return
      end

      local expectedCount = self.magmatterMode == true and 3 or 7

      if outputsCount ~= expectedCount then
        self.stateMachine.data.errorMessage = "Number of objects ("..outputsCount..") doesn't match the expected ("..expectedCount..")"
        self.stateMachine.data.errorResetDelay = 0
        self.stateMachine:setState("error")
        return
      end

      self.stateMachine:setState("clearOutputAe")
    end,
  })

    self.stateMachine:createState("clearOutputAe", "Clear Output AE", {
    onInit = function ()
      self:clearAe()
      self.stateMachine:setState("requestFakePattern")
    end,
  })

  self.stateMachine:createState("requestFakePattern", "Request Fake Pattern", {
    onInit = function ()
      self.stateMachine.data.craftFailCount = 0
    end,
    onUpdate = function ()
      if self:getFreeCpusCount() >= 1 then
        if self:requestFakeRecipe() == true or self:hasFakeRecipe() == true then
          self.stateMachine.data.craftFailCount = 0
          self.stateMachine:setState("waitEnd")
        else
          if self.stateMachine.data.craftFailCount >= 3 then
            self.stateMachine.data.craftFailCount = 0
            self.stateMachine.data.errorMessage = "Cant request craft: "..self.fakeRecipeName
            self.stateMachine.data.errorResetDelay = 60
            self.stateMachine:setState("error")
            return
          else
            self.stateMachine.data.craftFailCount = self.stateMachine.data.craftFailCount + 1
            os.sleep(1)
          end
        end
      else
        os.sleep(2)
      end
    end
  })

  self.stateMachine:createState("waitEnd", "Wait End", {
    onInit = function ()
      self.stateMachine.data.waitEndTime = computer.uptime()
      self.stateMachine.data.notifyLongEndTime = false
    end,
    onUpdate = function ()
      local _, itemsCount = self:getOutputs()

      local diff = math.ceil(computer.uptime() - self.stateMachine.data.waitEndTime)

      if itemsCount ~= 0 then
        while self:tryCancelFakeRecipe() == false do
          os.sleep(0.1)
        end

        self.stateMachine.data.outputs = nil
        self.stateMachine:setState("idle")
      elseif diff > 240 and self.stateMachine.data.notifyLongEndTime == false then
        self.stateMachine.data.notifyLongEndTime = true
        event.push("log_warning", "More than four minutes in the wait end state: "..diff)
      end
    end
  })

  self.stateMachine:createState("error", "Error", {
    onInit = function ()
      while self:tryCancelFakeRecipe() == false do
        os.sleep(1)
      end

      event.push("log_error", self.stateMachine.data.errorMessage)
      event.push("log_info","&red;Press Enter to confirm")

      self.stateMachine.data.errorMessage = nil
    end,
  })

  self.stateMachine:setState("idle")
end

---Reset setup state for idle state
---@private
function heliofusionExoticizerController:resetToIdleState()
  self:clearPattern()

  while self:tryCancelFakeRecipe() == false do
    os.sleep(1)
  end
end

---Clear inputs and outputs of the fake pattern
---@private
function heliofusionExoticizerController:clearPattern()
  local pattern = self.inputMeInterfaceProxy.getInterfacePattern(1)

  if pattern == nil then
    error("No pattern in Interface")
  end

  self.inputMeInterfaceProxy.setInterfacePatternOutput(1, 1, self.databaseProxy.address, 1, 1)
  self.inputMeInterfaceProxy.setInterfacePatternInput(1, 1, self.databaseProxy.address, 1, 1)

  for key, _ in pairs(pattern.outputs) do
    if key ~= 1 then
      self.inputMeInterfaceProxy.clearInterfacePatternOutput(1, key)
    end
  end

  for key, _ in pairs(pattern.inputs) do
    if key ~= 1 then
      self.inputMeInterfaceProxy.clearInterfacePatternInput(1, key)
    end
  end
end

---Encode fake pattern with the right plasmas
---@param outputs table<string, OutputItem>
---@return boolean
---@return integer
---@private
function heliofusionExoticizerController:encodePattern(outputs)
  local index = 1
  local count = 0

  for key, value in pairs(outputs) do
    if self.magmatterMode == true then
      if key == "Spatially Enlarged Fluid" or key == "Tachyon Rich Temporal Fluid" then
        count = value.count
      else
        count = math.abs(outputs["Spatially Enlarged Fluid"].count - outputs["Tachyon Rich Temporal Fluid"].count) * 144
      end
    else
      count = value.count * (value.isLiquid == true and 1000 or 144)
    end

    local plasma = plasmaList[self.magmatterMode and "Magmatter" or "Gluon"][value.label]

    if plasma ~= nil then
      self.inputMeInterfaceProxy.setInterfacePatternInput(1, index, {name = plasma, size = count}, "fluid")
    else
      return false, index - 1
    end

    index = index + 1
  end

  return true, index - 1
end

---Get items from output ae
---@return table<string, OutputItem>
---@return number
---@private
function heliofusionExoticizerController:getOutputs()
  local items = self.outputMeInterfaceProxy.getItemsInNetwork({})
  local liquids = self.outputMeInterfaceProxy.getFluidsInNetwork()

  ---@type table<string, OutputItem>
  local outputs = {}
  local count = 0

  for _, value in pairs(items) do
    local label = value.label:match("Pile of%s(.+)%sDust")
    local coefficient = 1

    if label == nil then
      label = value.label:match("(.+) Dust")
      coefficient = 9
    end

    if label == nil then
      outputs[value.label] = {label = value.label, count = value.size * coefficient, isLiquid = false}
    else
      outputs[label] = {label = label, count = value.size * coefficient, isLiquid = false}
    end

    count = count + 1
  end

  for _, value in pairs(liquids) do
    local label = value.label:match("^(.-)%s?[Gg]?[Aa]?[Ss]?$")

    if label == nil then
      outputs[value.label] = {label = value.label, count = value.amount, isLiquid = true}
    else
      outputs[label] = {label = label, count = value.amount, isLiquid = true}
    end

    count = count + 1
  end

  return outputs, count
end

---Clear output ae by move items in input ae
---@private
function heliofusionExoticizerController:clearAe()
  for i = 1, 3, 1 do
    self.transposerProxy.transferItem(self.meDriveSide, self.meIoPortSide, 1)
  end

  while self.transposerProxy.getSlotStackSize(self.meIoPortSide, 9) ~= 1 do
    os.sleep(0.1)
  end

  for i = 1, 3, 1 do
    self.transposerProxy.transferItem(self.meIoPortSide, self.meDriveSide, 1)
  end
end

---Get free cpus
---@return integer
---@private
function heliofusionExoticizerController:getFreeCpusCount()
  local cpus = self.inputMeInterfaceProxy.getCpus()
  local freeCpusCount = 0

  for _, value in pairs(cpus) do
    if value.cpu.isBusy() == false then
      freeCpusCount = freeCpusCount + 1
    end
  end

  return freeCpusCount
end

---Request fake pattern
---@private
function heliofusionExoticizerController:requestFakeRecipe()
  local recipe = self.inputMeInterfaceProxy.getCraftables({label = self.fakeRecipeName})[1]
  local craft = recipe.request(1)

  while craft.isComputing() == true do
    os.sleep(0.1)
  end

  return craft.hasFailed() == false
end

---Try cancel craft of the faker pattern
---@private
function heliofusionExoticizerController:tryCancelFakeRecipe()
  local cpus = self.inputMeInterfaceProxy.getCpus()

  for _, value in pairs(cpus) do
    if value.cpu.isBusy() == true then
      local output = value.cpu.finalOutput()

      if output == nil then
        return false
      end

      if output.label == self.fakeRecipeName then
        local isCanceled = value.cpu.cancel()
        return isCanceled
      end
    end
  end

  return true
end

---Check if craft of the fake pattern is failed
---@private
function heliofusionExoticizerController:hasFakeRecipe()
  local cpus = self.inputMeInterfaceProxy.getCpus()

  for _, value in pairs(cpus) do
    if value.cpu.isBusy() == true then
      local output = value.cpu.finalOutput()

      if output ~= nil and output.label == self.fakeRecipeName then
        return true
      end
    end
  end

  return false
end

return classBuilder.createClass(heliofusionExoticizerController, heliofusionExoticizerController.constructor, "HeliofusionExoticizerController")