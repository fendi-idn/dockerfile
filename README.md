## USAGE :

Navigate to Laravel folder then :

```
docker-compose up nginx redis mysql workspace hansip mig rabbitmq
```

MIG And Hansip env Settings is on env-example-unix

Hansip default :

        - AAA_SERVER_HOST=0.0.0.0
        - AAA_SERVER_PORT=3000
        - AAA_SERVER_TIMEOUT_WRITE=300 seconds
        - AAA_SERVER_TIMEOUT_READ=300 seconds
        - AAA_SERVER_TIMEOUT_IDLE=300 seconds
        - AAA_SERVER_TIMEOUT_GRACESHUT=300 seconds
        - AAA_SETUP_ADMIN_ENABLE=false
        - AAA_SERVER_LOG_LEVEL=TRACE
        - AAA_DB_TYPE=MYSQL
        - AAA_DB_MYSQL_USER=root
        - AAA_DB_MYSQL_PASSWORD=root
        
MIG default :

        - IDNAC_POPMAMA_API_BASE_URI=https://internal-api.popmama.local
        - IDNAC_POPMAMA_API_KEY=
        - IDNAC_IDNTIMES_API_BASE_URI=https://writerexperience-api.idntimes.com
        - IDNAC_IDNTIMES_API_KEY=f50c129a-8a5e-43ca-8826-57af80e6b23e
        - IDNAC_HANSIP_API_BASE_URI=http://hansip-idn.media:3000
        - IDNAC_HANSIP_API_KEY=
        - IDNAC_RABBITMQ_AQMP_URI=amqp://guest:guest@rabbitmq/
        
        
## Rebuild MIG / Account migrate :

```
docker rm idn-core
docker image rm laravel_mig
```

## Rebuild Hansip / AAA :

```
docker rm hansip
docker image rm laravel_hansip
```
