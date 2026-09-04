#!/usr/bin/env bash

# Simples Backup Script
# - [x] Tools für Backup: tar + xz
#
# - [ ] Zielverzeichnis für Backup festlegen
# - [x] 1. Zielverzeichnis ist fest im Script angegeben
# - [ ] 2. Zielverzeichnis ist dem Script als Argument zu übergeben
# - [ ] 3. Zielverzeichnis wird interaktiv abgefragt
#
# - [ ] Welches Verzeichnis wollen wir sichern?
# - [x] 1. zu sicherndes Verzeichnis ist fest im Script angegeben
# - [x] 2. zu sicherndes Verzeichnis ist dem Script als Argument zu übergeben
# - [x] 3. zu sicherndes Verzeichnis wird interaktiv abgefragt
#
## Ausbaustufen:
# - [ ] evtl. später: Tools für Backup: Kombination aus cp und hardlinks

TIMESTAMP=$(date +%Y_%m_%d_%H_%M)
DIRS_TO_BACKUP="$@"
DEST_DIR_BACKUP=/var/backups

check_if_root() {
	if [[ $UID -ne 0 ]]; then
		echo "ERROR: Dem Script muss mit Root Rechten ausgeführt werden."
		exit 1
	fi
}

make_backup() {
	BACKUP_NAME=$(basename "$DIR")
	ARCHIVE_NAME=backup_${BACKUP_NAME}_${TIMESTAMP}.tar

	# Sicherung mit tar (erstmal ohne Komprimierung)
	tar --create --file ${DEST_DIR_BACKUP}/${ARCHIVE_NAME} --exclude="backup_*" $DIR
}

check_if_root

for DIR in $DIRS_TO_BACKUP; do
	# Prüfung, ob dem Skript etwas übergeben wurde und wenn ja, ob
	# es sich um ein existierendes Verzeichnis handelt
	while [[ -z "$DIR" ]] || [[ ! -d "$DIR" ]]; do
		# TODO bei angabe eines Verzeichnisses mit Leerzeichen 
		#      wird der Loop immer wieder aufgerufen
		read -p "Bitte ein Verzeichnis angeben: " DIRS_TO_BACKUP
	done

	make_backup
done



