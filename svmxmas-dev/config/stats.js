/*
Run this script with the command 
node stats.js > test.csv
*/

// Attempt to pull stats via NodeJS - Work in Progress
const SegfaultHandler = require('segfault-handler');
SegfaultHandler.registerHandler('crash.log');


var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('fsa.db');

db.serialize(function() {
	//  db.run("CREATE TABLE lorem (info TEXT)");
//
//  var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
//  for (var i = 0; i < 10; i++) {
//      stmt.run("Ipsum " + i);
//  }
//  stmt.finalize();
   var all_tabs_sql = "SELECT name as tb_name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'";


//  db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
   db.each(all_tabs_sql , function(err, row) {
//      console.log(row.id + ": " + row.info);

      var tab_name = row.tb_name;

      var cnt_sql = "SELECT COUNT(*) as cnt FROM \"" + tab_name +"\" c";
		db.each(cnt_sql, function(err1, row1) {
		  if (err1) {
			throw err1;
		  }
			return row1
				? console.log(row.tb_name+","+row1.cnt)
				: console.log(`No Count found`);
	  });

   });
   
});

