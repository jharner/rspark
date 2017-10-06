/* WORK IN PROGRESS */
/* Simple NodeJS application to pair emails with host IPS */

var fs = require('fs');
const asyncFunction = Object.getPrototypeOf(async function(){}).constructor;

var files = ['emails', 'hosts', 'easthosts'];


/*
function callback () { console.log('all done'); }

var itemsProcessed = 0;

files.forEach((item, index, array) => {
	console.log(item);
  asyncFunction(item, () => {
  	console.log(item)
    itemsProcessed++;
    if(itemsProcessed === array.length) {
      callback();
    }
  });
});
*/
var emails = [];
var easthosts = []; 
var hosts = [];
/*
fs.readFile('emails',"utf8", (err, data) => {
  if (err) throw err;
  console.log(data);

});

fs.readFile('easthosts',"utf8", (err, data) => {
  if (err) throw err;
  console.log(data);
});

fs.readFile('hosts',"utf8", (err, data) => {
  if (err) throw err;
  console.log(data);
});
*/
var emailsArr = fs.readFileSync('emails').toString().split(",\n");
for(i in emailsArr) {
    emails.push(emailsArr[i]);
    //console.log(emails);
}

var hostsArr = fs.readFileSync('hosts').toString().split("[webserver]\n")[1].split("\n");
for(i in hostsArr) {
    hosts.push(hostsArr[i]);
    //console.log(hosts);
}
var easthostsArr = fs.readFileSync('easthosts').toString().split("[webserver]")[1].split("\n");
for(i in easthostsArr) {
    hosts.push(easthostsArr[i]);
    //console.log(hosts);
}

setTimeout(function(){
	var newArr = [];
	// remove blanks
	for (var j=0; j < hosts.length; j++) {
		if(hosts[j] == "") {
			hosts.splice(j, 1);
		}
	}
	// alternate adding email and host
	for (var i=0; i < emails.length; i++) {
		newArr.push(emails[i]);
		newArr.push("http://" + hosts[i] + ":8787");
	}
	console.log(newArr);
}, 1000);

console.log("synccheck");