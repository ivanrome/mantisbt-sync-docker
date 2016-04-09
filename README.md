# mantisbt-sync-docker
Docker compose images for mantisbt-sync.
It will start a MySQL container and java container launching the core batch.
Additional cron job container can be added thank to [webwurst/docker-go-cron](https://github.com/webwurst/docker-go-cron) 

## Usage

The mantisbt-sync-core container exposes a data volume mapped to _/var/opt/applications/mantis-sync/core/batch/data/_ on the host and _/shared/data_ in the container.
This volume is designed for containing extra configuration files (for instance XML file for configuring the portal authentication) and CSV files for the fileSyncIssuesJob job.

The entry point is designed to accept JVM extra options and system properties (like proxy configuration) through the _command_ entry in the docker-compose file.

1. If portal authentication is needed, place the XML file in /var/opt/applications/mantis-sync/core/batch/data/ on the host
2. In the _docker-compose.yml_ file, fill the MANTIS\_ENDPOINT and MANTIS\_AUTH_FILEPATH (if needed) environment variables
3. If JVM level configuration is needed, add a _command_ with the extra options
4. Run docker-compose up and voilà :-)

## Example

The following _docker-compose.yml_ file shows an example configuration for :

* Endpoint : _http://mymantis.com/bugs/api/soap/mantisconnect.php_
* Portal authentication defined in the XML file _/var/opt/applications/mantis-sync/core/batch/data/connect.xml_ on the host
* HTTP and HTTPS proxy : _http://myproxy.com:8080_

```YAML
mantisbt-sync-core:
    build: ./core/
    environment:
        - SPRING_DATASOURCE_PLATFORM=mysql
        - SPRING_DATASOURCE_URL=jdbc:mysql://mantisbt-sync-mysql:3306/mantisbt
        - SPRING_DATASOURCE_USERNAME=mantisbt
        - SPRING_DATASOURCE_PASSWORD=mantisbt
        - MANTIS_ENDPOINT=http://mymantis.com/bugs/api/soap/mantisconnect.php
        - MANTIS_AUTH_FILEPATH=file:/shared/data/connect.xml
        - http_proxy=http://myproxy.com:8080
        - https_proxy=http://myproxy.com:8080
    command: [-Dhttp.proxyHost=myproxy.com, -Dhttp.proxyPort=8080, -Dhttps.proxyHost=myproxy.com, -Dhttps.proxyPort=8080]
    volumes:
        - /var/opt/applications/mantis-sync/core/batch/data/:/shared/data
    ports:
        - "8080"
    links:
        - mantisbt-sync-mysql
            
mantisbt-sync-mysql:
    image: mysql:latest
    environment:
        - MYSQL_ROOT_PASSWORD=mantisbt
        - MYSQL_DATABASE=mantisbt
        - MYSQL_USER=mantisbt
        - MYSQL_PASSWORD=mantisbt
    volumes:
        - /var/opt/applications/mantis-sync/core/mysql/:/var/lib/mysql
    ports:
        - "3306"
```

## Cron

For scheduling jobs, containers using the mantisbt-sync-cron image can be added.
The following environment variables must be provided :

* BASE_URL=http://mantisbt-sync-core:8080/batch
* SCHEDULE : based on [robfig/cron](https://github.com/robfig/cron) syntax. See [here](https://github.com/robfig/cron/blob/master/doc.go)
* COMMAND=/mantis-sync-cron/tasks.sh <job>, where <job> is one of : syncEnumsJob, syncProjectsJob, syncIssuesJob
* MANTIS_USERNAME : user name used to connect to MantisBT. Left it empty if anonymous access is used
* MANTIS_PASSWORD : password used to connect to MantisBT. Left it empty if anonymous access is used
* MANTIS\_PROJECT_ID : MantisBT project id

The following configuration will run issues sync job every 6 hours :

```YAML
mantisbt-sync-cron:
    build: ./cron/
    environment:
        - BASE_URL=http://mantisbt-sync-core:8080/batch
        - SCHEDULE=@every 6h
        - COMMAND=/mantis-sync-cron/tasks.sh syncIssuesJob
	- MANTIS_USERNAME=
	- MANTIS_PASSWORD=
	- MANTIS_PROJECT_ID=1
    ports:
        - "18080"
    links:
        - mantisbt-sync-core
```

** Note : the cron container can only launch one command. If multiple jobs scheduling is required, just add one container per job**