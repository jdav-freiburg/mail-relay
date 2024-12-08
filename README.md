# JDAV Freiburg mail-relay

## Background

- open relay for mail sending

## Usage

### Setup

#### Setup credentials

> [!WARNING]
> Creation of `saslpass.db` is inaccurate and requires more work. For example, the command `postmap` can only be run when postfix is installed (e.g. inside the container). Also `docker-compose.yaml` mounts the file `data/saslpass.db` into the container, but that won't work if the file is not already present!

Create file `data/saslpass` with the following content

```shell
smtprelaypool.ispgateway.de support@jdav-freiburg.de:<insert password here>
```

Create `data/saslpass.db` by executing the following command

```shell
postmap saslpass
```

#### Finish setup

Make sure the `relayhost` in `data/main.cf` is correctly set to your provider

```shell
relayhost = [smtprelaypool.ispgateway.de]
```

Start mail-relay

```shell
docker compose up -d
```

### Test Functionality

Test whether postfix is running

```shell
docker compose exec -ti postfix sh -c "postfix status"
```

To test the mail-sending functionality, uncomment the port mapping option in `docker-compose.yaml` and restart with `docker compose up -d`, then use `telnet` to send a mail to your own e-mail address.

Start a telnet session

```shell
telnet localhost 25
```

Send an e-mail (The `.` is intentional and tells telnet that the end of the message is reached)

```shell
ehlo localhost
mail from: root@localhost
rcpt to: <your-email-address>
data
Subject: My first mail on Postfix

Hi,
meine erste Mail mit dem relay-service.
.
```

Exit telnet session

```shell
quit
```

> [!IMPORTANT]
> UNDO your changes to `docker-compose.yaml` and restart with `docker compose up -d`

### Usage: configure other services to use the mail-relay

Add network from the mail-relay to the `docker-compose.yaml` of the service which needs mail funcitonality.

```yaml
networks:
  mail:
    external: true
```

Configuration within the service (usually admin setting or a config file)

| Key            | Value                    |
| -------------- | ------------------------ |
| host           | mail                     |
| port           | 25                       |
| email-address  | support@jdav-freiburg.de |
| preferred name | "JDAV Freiburg Support"  |
| authentication | false                    |
| username       | ""                       |
| passwort       | ""                       |
| SSL            | false                    |

## Good to know

### Networking

This docker compose setup uses a network called `mail` which is used by the mail-relay and all other services that depend on the mail-relay.
By giving the network the attribute `name: mail` we ensure that it will be accessible by that name (without any prefixes) from other services.

By defining the `subnet` range the service will always use the same IP range.
This is important, because `data/main.cf` needs to specify that range as `mynetworks` and would have to be configured manually otherwise.

> Legacy setup: Check if network is correctly configured
>
>- Get "Gateway" network (eg. `172.19.0.1`) from mail network with `docker inspect network mail`
>- And add it to `data/main.cf` in `mynetworks = 127.0.0.1, 172.19.0.0/16`
