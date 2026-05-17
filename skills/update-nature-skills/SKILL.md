---
name: update-nature-skills
description: Install all skills from https://github.com/Yuan1z0825/nature-skills.git into the local Codex skill library. Use when the user asks to update or install Nature skills (for example: "更新nature skills的技能", "安装 nature skills", "同步 nature skills").
---

# Update Nature Skills

When the user asks to update/install Nature skills, execute this workflow.

## 1) Prepare destination

- Set local skill library path to `${CODEX_HOME:-$HOME/.codex}/skills`.
- Ensure destination directory exists.

## 2) Fetch latest remote content

- Clone `https://github.com/Yuan1z0825/nature-skills.git` into a temporary directory.
- If `git` is unavailable or clone fails, report failure and stop.

## 3) Install all remote skills

- Enumerate all folders under remote `skills/`.
- Copy every remote skill folder into local `${CODEX_HOME:-$HOME/.codex}/skills`.
- Overwrite local folder with the same name to ensure full refresh.
- Do not delete local skills that are not present in the remote repository.

## 4) Report result

- Return a concise summary:
  - destination path;
  - list of installed/refreshed skills;
  - count of installed skills;
  - any errors.

## 5) Preferred command

Run:

```bash
bash skills/update-nature-skills/scripts/sync_nature_skills.sh
```

If the script path is not available in current working directory, locate this skill folder first and run the script by absolute path.
