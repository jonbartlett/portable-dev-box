db="/vagrant_data/fsa.db"
for i in `sqlite3 "$db" "SELECT name FROM sqlite_master WHERE 
type='table';"`; do echo -n $i\ \,\ ; sqlite3 "$db" "SELECT 
COUNT(*) FROM $i;"; done
