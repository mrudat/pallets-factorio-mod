-- modules

local HighlyDerivative = require('__HighlyDerivative__/library')
local rusty_locale = require("__rusty-locale__.locale")
local rusty_icons = require("__rusty-locale__.icons")
local rusty_prototypes = require("__rusty-locale__.prototypes")
local ornodes = require("__OR-Nodes__/library").init()

-- external functions

local locale_of = rusty_locale.of
local icons_of = rusty_icons.of
local depend_on_all_recipe_ingredients = ornodes.depend_on_all_recipe_ingredients
local depend_on_item = ornodes.depend_on_item
local derive_name = HighlyDerivative.derive_name

-- "Constants"

local MOD_NAME = "Pallets"
local PREFIX = MOD_NAME .. "-"
local MOD_DIRECTORY = "__" .. MOD_NAME .. "__/"
local GRAPHICS_DIRECTORY = MOD_DIRECTORY .. "graphics/"

local ITEMS_WITH_INDIVIDUAL_STATE = {
  ['item-with-entity-data'] = true,
  ['item-with-label'] = true,
}

local PALLET_ICON_BASE = {
  {
    icon = GRAPHICS_DIRECTORY .. "icons/empty-pallet.png",
    icon_size = 64,
    scale = 0.5
  }
}
local PALLET_ICON_OFFSET = {
  scale = 0.75,
  shift = {0, -1}
}

local LOAD_PALLET_ICON_BASE = PALLET_ICON_BASE
local LOAD_PALLET_ICON_OFFSET = PALLET_ICON_OFFSET

local UNLOAD_PALLET_ICON_BASE = {
  {
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    scale = 32,
  },
  {
    icon = GRAPHICS_DIRECTORY .. "icons/empty-pallet.png",
    icon_size = 64,
    scale = 0.25,
    shift = {8, 0}
  }
}
local UNLOAD_PALLET_ICON_OFFSET = {
  scale = 0.5,
  shift = {-8, 0}
}


local EMPTY_PALLET_ITEM_NAME = "empty-pallet"

-- static items
do
  local new_things = {}

  new_things[#new_things+1] = {
    type = "item-group",
    name = "pallets",
    order = "ca",
    icon = GRAPHICS_DIRECTORY .. "technology/pallets.png",
    icon_size = 128,
  }

  new_things[#new_things+1] = {
    type = "item-subgroup",
    name = "load-pallet",
    group = "pallets",
    order = "d"
  }

  new_things[#new_things+1] = {
    type = "item-subgroup",
    name = "unload-pallet",
    group = "pallets",
    order = "e"
  }

  new_things[#new_things+1] = {
    type = "item",
    name = EMPTY_PALLET_ITEM_NAME,
    icons = PALLET_ICON_BASE,
    subgroup = "intermediate-product",
    order = "d[empty-pallet]",
    stack_size = 10
  }

  new_things[#new_things+1] = {
    type = "recipe",
    name = EMPTY_PALLET_ITEM_NAME,
    category = "crafting",
    energy_required = 1,
    subgroup = "intermediate-product",
    enabled = false,
    ingredients =
    {
      {type="item", name="steel-plate", amount=1},
      {type="item", name="plastic-bar", amount=1},
    },
    result = EMPTY_PALLET_ITEM_NAME,
  }

  local pallet_prerequisites = {"logistics-2"}

  new_things[#new_things+1] = {
    type = "technology",
    name = "pallets",
    icon = GRAPHICS_DIRECTORY .. "technology/pallets.png",
    icon_size = 128,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "empty-pallet"
      }
    },
    prerequisites = pallet_prerequisites,
    unit = {
      count = 150,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "c-o-a",
  }

  local steel_plate_technology = depend_on_item('steel-plate')
  log(serpent.line(steel_plate_technology))
  steel_plate_technology = steel_plate_technology[1]
  if steel_plate_technology then
    pallet_prerequisites[#pallet_prerequisites+1] = steel_plate_technology
  end

  local plastic_bar_technology = depend_on_item('plastic-bar')
  log(serpent.line(plastic_bar_technology))
  plastic_bar_technology = plastic_bar_technology[1]
  if plastic_bar_technology then
    pallet_prerequisites[#pallet_prerequisites+1] = plastic_bar_technology
  end

  data:extend(new_things)
  for i = 1,#new_things do
    -- FIXME shouldn't be necessary!
    HighlyDerivative.index(new_things[i])
  end
end

-- functions

local function is_pallet(item_name)
  return item_name:sub(1,PREFIX:len()) == PREFIX
end

local function make_pallet(new_things, item, item_name, _)
  if item.allow_on_pallet == false then return end

  local stack_size = item.stack_size or 1
  if stack_size == 1 then return end
  if stack_size > 0xffff then return end

  if is_pallet(item_name) then return end

  local names = locale_of(item)
  local icons = icons_of(item)

  local loaded_pallet_name = item_name .. "-pallet"
  if loaded_pallet_name:len() > 200 then
    loaded_pallet_name = derive_name(PREFIX, 'pallet', item_name)
  end

  local loaded_pallet = {
    type = "item",
    name = loaded_pallet_name,
    localised_name = {"item-name.loaded-pallet", names.name},
    icons = util.combine_icons(PALLET_ICON_BASE, icons, PALLET_ICON_OFFSET),
    subgroup = "load-pallet",
    order = item_name,
    stack_size = 1
  }

  local load_pallet_recipe_name = 'load-' .. item_name .. '-pallet'
  if load_pallet_recipe_name:len() > 200 then
    load_pallet_recipe_name = derive_name(PREFIX, 'load-pallet', item_name)
  end

  local load_pallet_recipe = {
    type = "recipe",
    name = load_pallet_recipe_name,
    localised_name = {"recipe-name.load-pallet", names.name},
    category = "advanced-crafting",
    energy_required = 0.2,
    subgroup = "load-pallet",
    order = item_name,
    enabled = false,
    icons = util.combine_icons(LOAD_PALLET_ICON_BASE, icons, LOAD_PALLET_ICON_OFFSET),
    ingredients =
    {
      {type = "item", name = item_name, amount = stack_size},
      {type = "item", name = EMPTY_PALLET_ITEM_NAME, amount = 1},
    },
    results=
    {
      {type = "item", name = loaded_pallet_name, amount = 1}
    },
    hide_from_stats = true,
    allow_decomposition = false
  }

  local unload_pallet_recipe_name = 'unload-' .. item_name .. '-pallet'
  if unload_pallet_recipe_name:len() > 200 then
    unload_pallet_recipe_name = derive_name(PREFIX, 'unload-pallet', item_name)
  end

  local unload_pallet_recipe =
  {
    type = "recipe",
    name = unload_pallet_recipe_name,
    localised_name = {"recipe-name.unload-pallet", names.name},
    category = "advanced-crafting",
    energy_required = 0.2,
    subgroup = "unload-pallet",
    order = item_name,
    enabled = false,
    icons = util.combine_icons(UNLOAD_PALLET_ICON_BASE, icons, UNLOAD_PALLET_ICON_OFFSET),
    ingredients =
    {
      {type = "item", name = loaded_pallet_name, amount = 1}
    },
    results=
    {
      {type = "item", name = item_name, amount = stack_size},
      {type = "item", name = EMPTY_PALLET_ITEM_NAME, amount = 1}
    },
    hide_from_stats = true,
    allow_decomposition = false
  }

  -- special case for pallet of pallets
  if item_name == EMPTY_PALLET_ITEM_NAME then
    local temp = {
      {type = "item", name = item_name, amount = stack_size + 1 }
    }
    load_pallet_recipe.ingredients = temp
    unload_pallet_recipe.results = temp
  end

  local technology_name = depend_on_all_recipe_ingredients(load_pallet_recipe, true)
  if not technology_name then
    HighlyDerivative.index()
    technology_name = depend_on_all_recipe_ingredients(load_pallet_recipe, true)
  end
  if technology_name then
    technology_name = technology_name[1]
    if not technology_name then
      -- shouldn't happen! given that we use an ingredient that is unlocked by our own technology, a technology should always be found.
      technology_name = 'pallets'
    end
  else
    technology_name = 'pallets'
  end

  local technology = data.raw.technology[technology_name]

  local function add_effects(technology_data)
    local effects = technology_data.effects
    if not effects then
      effects = {}
      technology_data.effects = effects
    end
    effects[#effects+1] = {
      type = "unlock-recipe",
      recipe = load_pallet_recipe_name
    }
    effects[#effects+1] = {
      type = "unlock-recipe",
      recipe = unload_pallet_recipe_name
    }
  end

  local normal = technology.normal
  local expensive = technology.expensive

  if normal or expensive then
    if normal then add_effects(normal) end
    if expensive then add_effects(expensive) end
  else
    add_effects(technology)
  end

  local flags = item.flags
  if flags then
    for i = 1,#flags do
      if flags[i] == "hidden" then
        loaded_pallet.flags = { "hidden" }
        load_pallet_recipe.flags = { "hidden" }
        unload_pallet_recipe.flags = { "hidden" }
      end
    end
  end

  new_things[#new_things+1] = loaded_pallet
  new_things[#new_things+1] = load_pallet_recipe
  new_things[#new_things+1] = unload_pallet_recipe
end

HighlyDerivative.register_derivation('item', make_pallet)

local function register_descendants(descendants)
  for prototype_type, value in pairs(descendants) do
    if not ITEMS_WITH_INDIVIDUAL_STATE[prototype_type] then
      HighlyDerivative.register_derivation(prototype_type, make_pallet)
      register_descendants(value)
    end
  end
end

register_descendants(rusty_prototypes.descendants('item'))