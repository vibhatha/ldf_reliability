# ldf_reliability

## Usage

Build the docker image

```bash
export KUMA_DATA_BACKUP_VERSION=v4
docker build --build-arg KUMA_DATA_BACKUP_VERSION=${KUMA_DATA_BACKUP_VERSION} -t ldf/healthcheck .
```

Run the docker image

```bash
docker run -d --name ldf-healthcheck -p 3001:3001 --env-file .env ldf/healthcheck
```

Make a backup of the uptime kuma data

```bash
docker cp ldf-healthcheck:/app/data ${BACKUP_DIR}
```

Once you make a new backup if you need that to be the latest version to be used, make sure to update the `KUMA_DATA_BACKUP_VERSION` in the `.env` file.

## Deploying in Choreo

If you want to deploy this in Choreo, you can use the following steps:

1. Create a new service in Choreo
2. Add the following environment variables:
    - `KUMA_DATA_BACKUP_VERSION`
3. Make sure to test the service locally before deploying it to Choreo. Namely you may want to do config changes and make necessary backups locally and then deploy to Choreo.


