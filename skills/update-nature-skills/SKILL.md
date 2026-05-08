---
name: update-nature-skills
description: Sync and install the latest skills from https://github.com/Yuan1z0825/nature-skills.git into the local Codex skill library. Use when the user says they want to update nature skills (for example: "更新nature skills的技能", "更新 nature skills", "同步 nature skills").
---

# Update Nature Skills

When the user asks to update Nature skills, execute this workflow.

## 1) Prepare destination

- Set local skill library path to `${CODEX_HOME:-$HOME/.codex}/skills`.
- Ensure destination directory exists.

## 2) Fetch latest remote content

- Clone `https://github.com/Yuan1z0825/nature-skills.git` into a temporary directory.
- If `git` is unavailable or clone fails, report failure and stop.

## 3) Detect updated skills

- Compare `skills/` folders from remote and local destination.
- Treat as update when one of the following is true:
  - a skill exists remotely but not locally;
  - a skill exists in both locations but file hashes differ.

## 4) Install changed skills only

- Copy only changed/new skill folders from remote `skills/` into local `${CODEX_HOME:-$HOME/.codex}/skills`.
- Preserve full folder structure and overwrite changed files.
- Never delete existing local skills automatically.

## 5) Report result

- Return a concise summary:
  - destination path;
  - list of installed/updated skills;
  - count of unchanged skills;
  - any errors.

## 6) Preferred command

Run:

```bash
bash skills/update-nature-skills/scripts/sync_nature_skills.sh
```

If the script path is not available in current working directory, locate this skill folder first and run the script by absolute path.
