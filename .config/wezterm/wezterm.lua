-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = { '/usr/local/bin/fish', '-l' }

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha (Gogh)'
config.font = wezterm.font_with_fallback { "FiraCode Nerd Font Mono", "Monaco" }

function editable(filename)
    -- "foo.bar" -> ".bar"
    local extension = filename:match("^.+(%..+)$")
    if extension then
        -- ".bar" -> "bar"
        extension = extension:sub(2)
        local binary_extensions = {
            jpg = true,
            jpeg = true,
            -- and so on
        }
        if binary_extensions[extension] then
            -- can't edit binary files
            return false
        end
    end

    -- if there is no, or an unknown, extension, then assume
    -- that our trusty editor will do something reasonable

    return true
end

function extract_filename(uri)
    local start, match_end = uri:find("$EDITOR:");
    if start == 1 then
        -- skip past the colon
        return uri:sub(match_end + 1)
    end

    -- `file://hostname/path/to/file`
    local start, match_end = uri:find("file:");
    if start == 1 then
        -- skip "file://", -> `hostname/path/to/file`
        local host_and_path = uri:sub(match_end + 3)
        local start, match_end = host_and_path:find("/")
        if start then
            -- -> `/path/to/file`
            return host_and_path:sub(match_end)
        end
    end

    return nil
end

wezterm.on("open-uri", function(window, pane, uri)
    local name = extract_filename(uri)
    if name and editable(name) then
        -- Note: if you change your VISUAL or EDITOR environment,
        -- you will need to restart wezterm for this to take effect,
        -- as there isn't a way for wezterm to "see into" your shell
        -- environment and capture it.
        local editor = os.getenv("VISUAL") or os.getenv("EDITOR") or "code"

        -- To open a new window:
        --[[
    local action = wezterm.action{SpawnCommandInNewWindow={
        args={editor, name}
      }};
    ]]

        -- To open in a pane instead
        local action = wezterm.action { SplitHorizontal = {
            args = { editor, name }
        } };

        -- and spawn it!
        window:perform_action(action, pane);

        -- prevent the default action from opening in a browser
        return false
    end
end)

config.hyperlink_rules = {
    -- These are the default rules, but you currently need to repeat
    -- them here when you define your own rules, as your rules override
    -- the defaults

    -- URL with a protocol
    {
        regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
        format = "$0",
    },

    -- implicit mailto link
    {
        regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
        format = "mailto:$0",
    },

    -- new in nightly builds; automatically highly file:// URIs.
    {
        regex = "\\bfile://\\S*\\b",
        format = "$0"
    },

    -- Now add a new item at the bottom to match things that are
    -- probably filenames
    {
        regex = "[/.A-Za-z0-9_-]+\\.[A-Za-z0-9]+(:\\d+)*(?=\\s*|$)",
        format = "$EDITOR:$0"
    },
}

config.mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=wezterm.action.CompleteSelection("PrimarySelection"),
    },

    -- and make CTRL-Click open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="CMD",
      action=wezterm.action.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of CMD+Click to avoid weird program behaviors
    {
      event={Down={streak=1, button="Left"}},
      mods="CMD",
      action=wezterm.action.Nop,
    },
}

-- and finally, return the configuration to wezterm
return config
