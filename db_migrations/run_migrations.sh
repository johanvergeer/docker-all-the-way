POSTGRES_USER=$(cat $POSTGRES_USER_FILE)
DB=docker_all_the_way
SCRIPTS_DIR=/etc/opt/db

psql -U $POSTGRES_USER -d da_user -f $SCRIPTS_DIR/01_initial.sql
psql -U $POSTGRES_USER -d $DB -f $SCRIPTS_DIR/02_create_person_table.sql
