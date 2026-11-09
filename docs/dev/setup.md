# Development setup

Development happens on Linux; the game runs on Windows. No Lua install is needed anywhere:
tests execute the addon's Lua through `lupa`, which embeds Lua 5.1, the dialect the WoW client
uses.

## Linux (tests, data build)

```bash
python -m venv .venv && . .venv/bin/activate
pip install -e '.[dev]'
pytest                              # Python tests, and the Lua tests they drive
python -m tools.build_data          # compile data/*.yaml into LevelCoach/Data/*.lua
python -m tools.build_data --check  # CI mode: fail if generated files are stale
```

## Windows (the game PC)

See `windows-deploy.md` for cloning the repo next to the game, junctioning the addon folder into
`Interface\AddOns`, and running the API probe.

## Conventions

- Every addon Lua file starts with `local addonName, ns = ...` and puts shared state on `ns`.
- `Core/Engine.lua` and `Core/Detectors.lua` never touch the WoW API; `Core/State.lua` does.
- `LevelCoach/Data/*.lua` are generated. Edit the YAML under `data/` and rebuild.
- Lint: `luacheck LevelCoach` (runs in CI; locally only if you have luacheck installed).
