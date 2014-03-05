var aIPAddresses = new Array("127.0.0.1");

var publicIndex = "solr/vitapub_Test";
var dmIndex = "solr/vitadm_Test";
var partsIndex = "solr/vitaParts_Test";
var appPath = "Vita40Test";

function main() {
/* collect the possible parameters from the search screens*/
	
	//"id" is a string with the id from Vita
	var id = String(cocoon.request.get("id"));
	//"pub" is a string with the id from Vita
	var pd = false;
	pd = String(cocoon.request.get("pd"));
	var pubdisplay = pd.toLowerCase();
	var IPAddress = String(cocoon.request.getRemoteAddr());


	//build array of acceptable addresses
	
	//test if IPAddress in that list
	var IPAddressCheck = false;
	for (var count=0;count < aIPAddresses.length  ;count++ )
	{
		if (aIPAddresses[count] == IPAddress)
		{
			IPAddressCheck = true;
		}else{
			//nothing much has to change
		}
	}
	if (IPAddressCheck == true)
	{
		if (pubdisplay == "true")
		{
			var ResponsePage = "style/solrPDResponse";
		}else{
			var ResponsePage = "style/solrResponse";
		}
	}else{
		var ResponsePage = "style/solrNoResponse";
	}
	cocoon.sendPage(ResponsePage,
		{
			"id" : id,
			"pd" : pd,
			"pubdisplay" : pubdisplay,
			"IPAddressCheck" : IPAddressCheck,
			"IPAddress" : IPAddress,
			"publicIndex" : publicIndex,
			"dmIndex" : dmIndex,
			"appPath" : appPath
		}
	);
}

function parts(){
/* collect the possible parameters from the search screens*/
	
	//"id" is a string with the id from Vita
	var id = String(cocoon.request.get("id"));
	var IPAddress = String(cocoon.request.getRemoteAddr())

	//print("OOT parts Index.js (7:08): id:" + id);
	//test if IPAddress in that list
	var IPAddressCheck = false;
	for (var count=0;count < aIPAddresses.length  ;count++ )
	{
		if (aIPAddresses[count] == IPAddress)
		{
			IPAddressCheck = true;
		}else{
			//nothing much has to change
		}
	}
	if (IPAddressCheck == true)
	{
		var ResponsePage = "style/solrParts";
	}
	cocoon.sendPage(ResponsePage,
		{
			"id" : id,
			"IPAddressCheck" : IPAddressCheck,
			"IPAddress" : IPAddress,
			"partsIndex" : partsIndex,
			"appPath" : appPath
		}
	);
}
function batch(){
/* collect the possible parameters from the search screens*/
	
	//"id" is a string with the id from Vita
	var querystring = String(cocoon.request.getQueryString());
	//querystring = querystring.replace(/&/g,"&amp;");
	querystring = querystring.replace(/&/g,"%26");
	var type = String(cocoon.request.get("t"));
	var index = "";
	if (type == "pb")
	{
		index = publicIndex;
	}else if(type == "dm"){
		index = dmIndex;
	}else{
		index = partsIndex;
	}
	var IPAddress = String(cocoon.request.getRemoteAddr())

	//print("OOT parts Index.js (7:08): id:" + id);
	//test if IPAddress in that list
	var IPAddressCheck = false;
	for (var count=0;count < aIPAddresses.length  ;count++ )
	{
		if (aIPAddresses[count] == IPAddress)
		{
			IPAddressCheck = true;
		}else{
			//nothing much has to change
		}
	}
	if (IPAddressCheck == true)
	{
		var ResponsePage = "style/solrBatch";
	}
	cocoon.sendPage(ResponsePage,
		{
			"IPAddressCheck" : IPAddressCheck,
			"IPAddress" : IPAddress,
			"index" : index,
			"appPath" : appPath,
			"querystring" : querystring
		}
	);
}
function deleteRecord() {
	//"id" is a string with the id from Vita
	var id = String(cocoon.request.get("id"));
	//"pd" is a string with true|false from Vita
	var pd = false;
	pd = String(cocoon.request.get("pd"));
	var pubdisplay = pd.toLowerCase();
	//build array of acceptable ip addresses
	
	var IPAddressCheck = false;

	//test if server's IPAddress is in that list
	var IPAddress = String(cocoon.request.getRemoteAddr());
	
	//print("OOT delete Index.js: IPAdress:" + IPAddress);
	for (var count=0;count < aIPAddresses.length  ;count++ )
	{
		if (aIPAddresses[count] == IPAddress)
		{
			IPAddressCheck = true;
		}else{
			//nothing much has to change
		}
	}
	//if IP address OK, set the response page
	if (IPAddressCheck == true)
	{
		if (pubdisplay == true|pubdisplay == "true")
		{
			var ResponsePage = "style/solrPubDelResponse";
		}else{
			var ResponsePage = "style/solrDMDelResponse";
		}
	}else{
		var ResponsePage = "style/solrNoResponse";
	}
	// set exit strategy
	cocoon.sendPage(ResponsePage,
		{
			"id" : id,
			"pd" : pd,
			"pubdisplay" : pubdisplay,
			"IPAddressCheck" : IPAddressCheck,
			"IPAddress" : IPAddress,
			"publicIndex" : publicIndex,
			"dmIndex" : dmIndex,
			"partsIndex" : partsIndex,

			"appPath" : appPath

		}



	);

}



function deletePart() {

	//"id" is a string with the id from Vita

	var id = String(cocoon.request.get("id"));

	

	var IPAddressCheck = false;



	//test if server's IPAddress is in that list

	var IPAddress = String(cocoon.request.getRemoteAddr());

	

	//print("OOT delete Index.js: IPAdress:" + IPAddress);

	for (var count=0;count < aIPAddresses.length  ;count++ )

	{

		if (aIPAddresses[count] == IPAddress)

		{

			IPAddressCheck = true;

		}else{

			//nothing much has to change

		}

	}

	//if IP address OK, set the response page

	if (IPAddressCheck == true)

	{

		var ResponsePage = "style/solrPartDelResponse";

	}else{

		var ResponsePage = "style/solrNoResponse";

	}

	// set exit strategy

	cocoon.sendPage(ResponsePage,

		{

			"id" : id,

			"IPAddressCheck" : IPAddressCheck,

			"IPAddress" : IPAddress,

			"partsIndex" : partsIndex,

			"appPath" : appPath
		}

	);
}