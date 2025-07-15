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

# task_2
