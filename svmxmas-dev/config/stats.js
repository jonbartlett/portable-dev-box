// Attempt to pull stats via NodeJS - Work in Progress
const SegfaultHandler = require('segfault-handler');
SegfaultHandler.registerHandler('crash.log');
var sqlite3 = require('sqlite3').verbose();
const { writeToPath } = require('@fast-csv/format');
var path = require('path');
var db = new sqlite3.Database('fsa.db');


const tableCounts=[["Table Name","Count","Page Size"]];
let totalTables=0;

function init(){
	var all_tabs_sql = "SELECT name as tb_name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'";
	db_all(all_tabs_sql).then((rows)=>{
		totalTables=rows.length;
		console.log('totalTables '+totalTables);
		isTableFilled();//Time interval that runs every 5 seconds to check if all table's counts are completed and added to the array
		rows.forEach((item, index, arr)=>{
			//console.log(item.tb_name);
			var countSql = 'SELECT COUNT(*) as cnt FROM "'+ item.tb_name +'" c';
			db_all(countSql).then((countRows)=>{
				countRows.forEach((ctitem, ctindex, ctarr)=>{
					//console.log(item.tb_name+'--'+ctitem.cnt);
					var sizeSql = "SELECT SUM(\"pgsize\") as sz FROM dbstat WHERE name ='"+item.tb_name+"'";
					db_all(sizeSql).then((sizeRows)=>{
						sizeRows.forEach((szitem, szindex, szarr)=>{
							tableCounts.push([item.tb_name,ctitem.cnt,szitem.sz])
						})				
					});
				})				
			});		
		})
	});
}

function db_all(query){
    return new Promise(function(resolve,reject){
        db.all(query, function(err,rows){
           if(err){return reject(err);}
           resolve(rows);
         });
    });
}

init();

function isTableFilled(){
	var myVar = setInterval(function(){
			if(totalTables<=tableCounts.length){
				clearInterval(myVar);
				writeToPath(path.resolve('./', 'output.csv'), tableCounts)
					.on('error', err => console.error(err))
					.on('finish', () => console.log('Done writing.'));
			}else{
				console.log('tableCounts '+tableCounts.length);
			}
	}, 5000)
}