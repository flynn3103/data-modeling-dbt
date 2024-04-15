docker run -d --name sql_server --cap-add SYS_PTRACE \
  -e 'ACCEPT_EULA=1' \
  -e 'MSSQL_SA_PASSWORD=Admin@123' \
  -p 57000:1433 \
   mcr.microsoft.com/azure-sql-edge


docker exec -it sql_server /opt/mssql-tools/bin/sqlpackage /a:Import /sf:/var/opt/mssql/data/WideWorldImporters-Standard.bacpac /tsn:localhost /tdn:WWI /tu:sa /tp:Admin@123

docker cp -r backup/WideWorldImportersDW-Full.bak 23f4ad904c7d:/var/opt/mssql/data/
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Admin@123" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest


FROM mcr.microsoft.com/mssql/server:2022-latest
ENV DEFAULT_MSSQL_SA_PASSWORD=myStrongDefaultPassword
ENV ACCEPT_EULA=Y
USER root

COPY restore-db.sh entrypoint.sh /opt/mssql/bin/
RUN chmod +x /opt/mssql/bin/restore-db.sh /opt/mssql/bin/entrypoint.sh

ADD data.tar.gz /var/opt/mssql/
RUN chown -R mssql:root /var/opt/mssql/data && \
                chmod 0755 /var/opt/mssql/data && \
                chmod -R 0650 /var/opt/mssql/data/*

USER mssql
RUN /opt/mssql/bin/restore-db.sh
CMD [ "/opt/mssql/bin/sqlservr" ]
ENTRYPOINT [ "/opt/mssql/bin/entrypoint.sh" ]


# restore-db.sh

#!/bin/bash

export MSSQL_SA_PASSWORD=$DEFAULT_MSSQL_SA_PASSWORD
(/opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Server is listening on" && sleep 2

for restoreFile in /var/opt/mssql/data/*.bak
do
    fileName=${restoreFile##*/}
    base=${fileName%.bak}
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD -Q "RESTORE DATABASE [$base] FROM DISK = '$restoreFile'"
    rm -rf $restoreFile
done


# entrypoint.sh
#!/bin/bash

/opt/mssql-tools/bin/sqlcmd \
    -l 60 \
    -S localhost -U SA -P "$DEFAULT_MSSQL_SA_PASSWORD" \
    -Q "ALTER LOGIN SA WITH PASSWORD='${MSSQL_SA_PASSWORD}'" &

/opt/mssql/bin/permissions_check.sh "$@"




/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Admin@123' -Q "RESTORE DATABASE [WWI] FROM DISK = '/var/opt/mssql/data/WideWorldImporters-Full.bak'"
