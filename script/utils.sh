`pre-commit run --all-files`
`airflow db init`
`export AIRFLOW_HOME=$PWD`
`airflow webserver -p 8080`
`airflow scheduler`
`airflow users create \
    --username admin \
    --password admin \
    --firstname Flynn \
    --lastname Tran \
    --role Admin \
    --email spiderman@superhero.org`

`airflow sync-perm`
sudo lsof -i :8080
sudo kill -9 PID
airflow scheduler
