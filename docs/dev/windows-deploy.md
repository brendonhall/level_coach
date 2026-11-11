# Windows deploy and the API probe

Done once on the game PC. Afterwards, updating is `git pull` in the clone and `/reload` in game.

## 1. Find the Forever folder

Open the Battle.net launcher, select World of Warcraft, click the gear icon next to Play and
choose **Show in Explorer**. Open the folder for the Forever version. Guides at launch show it as
`_forever_` (the beta used `_classic_beta_`). Note the exact name; it is used below as `<flavor>`.

Record what you found here: `<flavor> = ________` (edit this file).

## 2. Clone the repository

Install Git for Windows if it is missing (https://git-scm.com/download/win). Then, in PowerShell:

```powershell
git clone https://github.com/brendonhall/level_coach.git C:\dev\level_coach
```

## 3. Junction the addon folder into AddOns

Run PowerShell as Administrator, or have Developer Mode on. Replace `<WoW>` with the install
path, for example `C:\Program Files (x86)\World of Warcraft`.

```powershell
New-Item -ItemType Junction -Path "<WoW>\<flavor>\Interface\AddOns\LevelCoach" -Target "C:\dev\level_coach\LevelCoach"
New-Item -ItemType Junction -Path "<WoW>\<flavor>\Interface\AddOns\GuildKin" -Target "C:\dev\level_coach\GuildKin"
```

The second line adds GuildKin, the officer-notes addon; skip it on a character that is not a guild
officer.

If `Interface\AddOns` does not exist yet, create it first. A junction, unlike a symlink, needs
no special privileges on most setups and WoW follows it without complaint.

## 4. Enable the addon

Start the client. At character select, open **AddOns** and confirm **Level Coach** is listed and
ticked. If it shows as out of date, tick **Load out of date AddOns**; that means the client's
interface number moved past 16001 and the TOC needs a bump.

Install **BugSack** and **BugGrabber** (Forever files from CurseForge) so Lua errors are visible.
Forever hides them by default.

## 5. Run the probe

Log in and type:

```
/lc probe
```

A few dozen lines print to chat and are stored in the addon's saved data. Then walk to a flight
master, open the flight map once (the probe records the known nodes), and type `/reload` so the
client writes the saved data to disk.

## 6. Get the results back to the repository

The file is:

```
<WoW>\<flavor>\WTF\Account\<ACCOUNT NAME>\SavedVariables\LevelCoach.lua
```

Copy it to `C:\dev\level_coach\docs\research\probe\LevelCoach.lua`, then:

```powershell
cd C:\dev\level_coach
git checkout -b probe-results
git add docs/research/probe/LevelCoach.lua
git commit -m "probe: first run results"
git push -u origin probe-results
```

Or paste the chat output into a GitHub issue if git on the game PC is not set up yet. Either
way, the results feed `docs/research/api-probe.md`.

## Updating later

```powershell
cd C:\dev\level_coach; git pull
```

then `/reload` in game. New files listed in the TOC need a full client restart the first time.
