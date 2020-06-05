# docker-mariadb-backup
Docker image to backup all databases of a mariadb host for a specific user (`root` for all databases).

## Usage
The default tag `latest` should be used for a x86-64 system.

### Automatic Backups
A cron daemon is running inside the container and the container keeps running in background.

Start backup container with default settings, considering that a mariadb server is running under `mariadb_backend` network (automatic backup every 2 hours)

```
docker run -d --restart=always --name mariadb_backup --network=mariadb_backend -e MARIADB_HOST="mariadb" -e MARIADB_USER="mysql" -e MARIADB_PASSWORD="password" pofilo/mariadb-backup:latest
```

### Manual Backups
You can add `manual` to run the container for one backup (can be used on your host cron or for one time use for examples).

```
docker run -d --restart=always --name mariadb_backup --network=mariadb_backend -v /tmp/mariadb-backup:/app/backup/ -e MARIADB_HOST="mariadb" -e MARIADB_USER="mysql" -e MARIADB_PASSWORD="password" -e pofilo/mariadb-backup:latest manual
```

## Environment variables
| ENV | Description | Default |
| ----- | ----- | ----- |
| MARIADB_HOST | Host of the mariadb server | **mandatory** |
| MARIADB_PORT | Port of the mariadb server | 3306 |
| MARIADB_USER | User of the mariadb server | **mandatory** |
| MARIADB_PASSWORD | Password of the mariadb server | **mandatory** |
| BACKUP_FOLDER | Destination folder of backups *inside the container* | /app/backup/ |
| USE_COMPRESS | Compress backups | true |
| CRON_TIME | Cron rule when automatic backup is used | "0 */2 * * *" |
| CRON_FILE | Path to the cron file *inside the container* | /etc/crontabs/root |
| LOG_FILE | Path to the log file *inside the container* | /app/log/backup.log |
| DELETE_AFTER_DAYS | Delete old backups after X days (0 means never) | 30 |

## Wrong timestamp
If you need timestamps in your local timezone you should mount `/etc/timezone:/etc/timezone:ro` and `/etc/localtime:/etc/localtime:ro` like it's done in the [docker-compose.yml](docker-compose.yml).

## License

This project is licensed under the GNU GPL License. See the LICENSE file for the full license text.

## Credits

+ [@Pofilo](https://git.pofilo.fr/pofilo/)

## Bugs

If you experience an issue, you have other ideas to the developpement or anything else, feel free to open an issue or to fix it with a PR!

