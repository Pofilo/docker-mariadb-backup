#!/bin/sh

DATE=`date +"%Y%m%d-%H%M%S"`

# TODO: use the one defined in entrypoint file
CREDENTIALS="-u ${MARIADB_USER} -p${MARIADB_PASSWORD} -h ${MARIADB_HOST} -P ${MARIADB_PORT}"

# Get the list of databases but <Database> and <information_schema>
LIST_DATABASES=$(mysql ${CREDENTIALS} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)")

cd ${BACKUP_FOLDER}
for database in ${LIST_DATABASES}; do
    # Backup database in sql file
    mysqldump ${CREDENTIALS} --skip-lock-tables ${database} > ${DATE}_${database}.sql
    if [ "$USE_COMPRESS" = true ]; then
        # Compress sql file with best compression with xz
        XZ_OPT=-e9 tar -Jcf ${DATE}_${database}.sql.tar.xz ${DATE}_${database}.sql
        # Delete sql file
        rm ${DATE}_${database}.sql
    fi
done

if [ ! -z ${DELETE_AFTER_DAYS} ] && [ ${DELETE_AFTER_DAYS} -gt 0 ]; then
    find . -type f -mtime +${DELETE_AFTER_DAYS} -delete
fi

