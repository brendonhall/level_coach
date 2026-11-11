# Level Coach (and GuildKin)

Two World of Warcraft: Forever addons in one repository.

**Level Coach** is a leveling coach addon. It reads your character's real state
(level, class, zone, quests, skills) and shows a short, goal-based checklist of what to take
care of at this level, so you stop alt-tabbing to guide websites. A coach, not a GPS: it sits
alongside routing addons such as Questie or RestedXP.

**GuildKin** puts the player's name into every guildmate's officer note. Forever forbids addons
from writing guild notes, so GuildKin plans the notes and pre-fills Blizzard's own officer-note
dialog; the officer presses Enter. `/gk` opens its window. Design: `docs/superpowers/specs/2026-11-11-guildkin-design.md`.

Status: Level Coach has a working panel and data to level 20 (unverified in game beyond the API
probe); GuildKin is built and awaits its first in-game run.

- Design: [docs/superpowers/specs/2026-11-08-level-coach-design.md](docs/superpowers/specs/2026-11-08-level-coach-design.md)
- Coach agent architecture: [docs/superpowers/specs/2026-11-08-coach-agent-architecture.md](docs/superpowers/specs/2026-11-08-coach-agent-architecture.md)
- First character guide: [docs/guides/undead-affliction-warlock.md](docs/guides/undead-affliction-warlock.md)
- Addons for a leveling warlock: [docs/guides/addons-for-a-leveling-warlock.md](docs/guides/addons-for-a-leveling-warlock.md)
- Research digests (provenance for the guides): [docs/research/](docs/research/)
