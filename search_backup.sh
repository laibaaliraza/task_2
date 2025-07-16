#!/bin/bash

#variable having default values
dir="./data"
backup_dir="backups"
date=$(date +%Y%m%d)
i_tag=false
report=false

#Use of getopts
while getopts ":d:ir" opt; do
  case $opt in
   d) dir="$OPTARG" ;;
   i) i_tag=true ;;
   r) report=true ;;
   \?) echo "Invalid option: -$OPTARG"; exit 1 ;;
  esac
done

#check if given directory exists or not 
if [ ! -d "$dir" ]; then
  echo " Directory does not exists: $dir "
  exit 1
fi

#make backup directory if directory does not exists
mkdir -p "$backup_dir"

#Use of rsync(-i is used in cronjob.txt)
if [ "$i_tag" = true ]; then       #incremental backup
  dest_dir="incremental-$date"
  prev_dir=$(ls -dt "$backup_dir"/incremental-* 2>/dev/null | head -n 1)
  if [ -n "$prev_dir" ]; then
    rsync -a --link-dest="$prev_dir" "$dir/" "$backup_dir/$dest_dir/" || exit 2
  else
    rsync -a "$dir/" "$backup_dir/$dest_dir/" || exit 2
  fi
else
  dest_dir="full-$date"    #do full backup(-i was not used)
  rsync -a "$dir/" "$backup_dir/$dest_dir/" || exit 2
fi

#make report.txt file
if [ "$report" = true ]; then
  count=$(find "$backup_dir/$dest_dir" -type f | wc -l)
  size=$(du -sh "$backup_dir/$dest_dir" | awk '{print$1}')
  echo "$count files archived, total $size" > report.txt
fi

git_backup="backup-$date"

if git rev-parse --git-dir > /dev/null 2>&1; then
  git add .
  git commit -m "Backup for $date"
  git tag "$git_backup"
  git push origin enhanced-backup
  git push origin "$git_backup"
else
  echo "Not a git repository, skipping version control steps."
fi

