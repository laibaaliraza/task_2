#Enhanced Backup Service

This is an enhanced backup automation script written in Bash. It performs full or incremental backups, generates reports, uses Git for versioning, and can be scheduled via cron.

# Features

-  Command-line flags (`-d`, `-i`, `-r`) using `getopts`
-  Full and incremental backups using `rsync`
-  Daily report of archived files and total size
-  Git tagging and commit after each run
-  Cron-ready automation

# Usage

Run the script with optional flags:
             ./search_backup.sh -d ./data -i -r
# Cronjob Setup

To schedule daily backups at 1 AM:

crontab cronjob.txt

# Git Tagging Workflow

After every backup run, the script adds a Git tag in the format:
  backup-YYYYMMDD

Example:
  git tag backup-20250716
  git push origin backup-20250716

# Folder Naming

Backups are stored in:
  backups/incremental-YYYYMMDD/  (for incremental backups)
  backups/full-YYYYMMDD/         (for full backups)

## Web Server Setup (Nginx)

- Installed via:
  sudo apt update && sudo apt install nginx

- Backups copied to web root:
  sudo cp -r backups /var/www/html/

- Nginx Config: see web-config/nginx-default.conf

- Reload:
  sudo systemctl reload nginx

- Verify:
  curl http://localhost/backups/

# task_2
