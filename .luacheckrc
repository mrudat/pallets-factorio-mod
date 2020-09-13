std = "lua52c"

max_line_length = false

read_globals = {
  log = {},
  serpent = {
    fields = {
      'block',
      'line'
    }
  },
  table = {
    fields = {
      'deepcopy'
    }
  },
  util = {
    fields = {
      'combine_icons',
      'parse_energy'
    }
  },
  '__DebugAdapter'
}

local data_settings = {
  read_globals = {
    data = {
      fields = {
        raw = {
          read_only = false,
          other_fields = true
        },
        'extend'
      }
    },
    'accumulator_picture',
    'mods'
  },
  globals = {
    'HighlyDerivative'
  }
}

local control_settings = {
  read_globals = {
    'game',
    'defines',
    'script'
  },
  globals = {
    'global',
  }
}

files["control.lua"] = control_settings

files["library.lua"] = data_settings

files["data.lua"] = data_settings
files["data-updates.lua"] = data_settings
files["data-final-fixes.lua"] = data_settings
