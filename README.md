# Python + PostgreSQL + pgAdmin

## Table of Contents
- [Table of Contents](#table-of-contents)
- [Folder structure](#folder-structure)
- [Run Docker containers](#run-docker-containers)
- [Database credentials](#database-credentials)
- [Know issues and how to solve them](#known-issues-and-how-to-solve-them)
- [License and Credits](#license-and-credits)

## Folder Structure
```
.
├─ .devcontainer/
│  ├─ devcontainer.json       # VS Code Dev Container config
│  └─ servers.json            # Pre-configured connection to PostgreSQL

├─ Data/                      # CSV and Excel sample datasets
│  ├─ apartments_data_prepared.csv
│  ├─ Northwind_Database.xlsx
│  └─ *.csv (Northwind tables)
├─ SQL/
│  └─ *.sql                    # SQL queries
├─ docker-compose.yml          # Defines PostgreSQL & pgAdmin services
├─ Dockerfile                  # Custom image setup
├─ init-db.sql                 # Initial db objects
├─ requirements.txt            # Python dependencies
├─ *.ipynb                     # Jupyter notebooks
├─ .gitignore                  # Git ignore rules
└─ README.md                   # Documentation (this file)
```

## Run Docker containers (only when it does not start automatically)
```bash
VS Code -> left Menu -> search file 'docker-compose.yml' -> right click -> Compose Up

# After a new Compose Up also run the followng command in the Terminal ...
bash .devcontainer/start.sh
```

## Database credentials
```bash
Host: db
Port: 5432
Maintenance database: postgres
Username: pgadmin
Password: geheim
```

## License and credits
This project is intended for educational/demo purposes.   
Sample data includes public datasets such as *Northwind*.   
Please verify licenses if using in other contexts.  
