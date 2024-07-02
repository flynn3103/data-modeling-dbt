FROM --platform=linux/amd64 mcr.microsoft.com/mssql/server:2022-latest
ENV DEFAULT_MSSQL_SA_PASSWORD=Admin@123
ENV ACCEPT_EULA=Y
USER root

COPY restore-db.sh entrypoint.sh /opt/mssql/bin/
RUN chmod +x /opt/mssql/bin/restore-db.sh /opt/mssql/bin/entrypoint.sh

ADD backup/*.bak /var/opt/mssql/data
# RUN chown -R mssql:root /var/opt/mssql/data && \
#                 chmod 0755 /var/opt/mssql/data && \
#                 chmod -R 0650 /var/opt/mssql/data/*

RUN /opt/mssql/bin/restore-db.sh
CMD [ "/opt/mssql/bin/sqlservr" ]
ENTRYPOINT [ "/opt/mssql/bin/entrypoint.sh" ]
