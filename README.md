# JDAV Freiburg mail-relay 



## Background 

- open relay for mail sending



## Usage

- Clone repository 

- Create file `data/saslpass` with content:

  ```bash
  smtprelaypool.ispgateway.de support@jdav-freiburg.de:<insert password here>
  ```

- Execute `postmap saslpass` => creates `data/saslpass.db`

- Set `relayhost` in `main.cf`

- Create `mail` docker network 

  ```bash
  docker network create mail
  ```

- Start mail-relay docker container

  ```bash
  docker compose up -d
  ```

  



## How to get it connected with service

Add network from the mail-relay to the `docker-compose.yaml` of the service which needs mail funcitonality.

```yaml
networks:
  mail:
    external: true
...
```



Configuration within the service (usually admin setting or a config file)

| Key            | Value                   |
| -------------- | ----------------------- |
| host           | mail                    |
| port           | 25                      |
| email-address  | support@dav-freiburg.de |
| preferred name | "JDAV Freiburg Support" |
| authentication | false                   |
| username       | ""                      |
| passwort       | ""                      |
| SSL            | false                   |


