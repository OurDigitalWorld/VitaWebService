/* 
global variables
	reset as appropriate within certain functions
*/

var searchQ = "";
var spellQ = "";
var queryTerms = "";
var unparsedQuery = "";
var searchSet = "OurOntario";
var indexServer = "http://localhost:8080/solr/vitapub_Test/";
var DMindexServer = "http://localhost:8080/solr/vitadm_Test/";
var partsIndexServer = "http://localhost:8080/solr/vitaParts_Test/";
var facetList = "&fl=id,title,titleSort,thumbnail,url,localid,description,site,type,featureComment,featureMystery,bibliographicCitation,accessionNo,creator,contributor,publisher,itemLatitude,itemLongitude,subject,source,language,spatial,temporal,created,modified,madePublic,publicDisplay,multiPart,rightsCreativeCommons&facet=true&facet.field=geoid&f.geoid.mincount=1&f.geoid.limit=50&facet.field=site&f.site.mincount=0&facet.field=fGroupName&f.fGroupName.mincount=1&facet.field=type&f.type.mincount=0&facet.field=itemType&facet.field=fSubject&f.fSubject.sort=count&f.fSubject.limit=50&facet.field=featureComment&facet.field=featureMystery&facet.field=rightsCreativeCommons&facet.mincount=1";
var facetDates = "&facet.field=fDateYear&f.fDateYear.sort=index&f.fDateYear.facet.limit=-1&f.fDateYear.facet.mincount=1&facet.field=fDateDecade&f.fDateDecade.sort=index&facet.field=fDateCentury&f.fDateCentury.sort=index"
var defaultRows = "40";
var defaultMobileRows = "5";

function main() {
	/* collect the possible parameters from the search screens*/
	parseSearch("main");
}
function essayResults() {
	/* collect the possible parameters from the search screens*/
	parseSearch("essayResults");
}
function publicResults() {
	parseSearch("publicResults");
}
function mobileResults() {
	parseSearch("mobileResults");
}
function parts() {
	//print("OOT Parts: started test again and again");
	parseSearch("parts");
}
function count() {
	/* collect the possible parameters from the search screens*/
	parseSearch("count");
}
function countGeo() {
	/* collect the possible parameters from the search screens*/
	parseSearch("countGeo");
}
function rss() {
	parseSearch("rss");
}
function atom() {
	parseSearch("atom");
}
function dc() {
	parseSearch("dc");
}
function kml() {
	/* collect the possible parameters from the search screens*/
	parseSearch("kml");
}
function checklists() {
	parseSearch("checklists");
}
function slideshow() {
	parseSearch("slideshow");
}
function prevnext() {
	parseSearch("prevnext");
}
function publicPrevNext() {
	parseSearch("publicPrevNext");
}

/* ==============================================================================*/

function publicSubjects() {
	/* Limit by record owner value*/
	var ro = String(cocoon.request.get("ro"));
	searchQ = "";
	if (ro.length > 0 & ro != "null"){
		searchQ = searchQ + " recordOwner:" + escape(ro) +"";
	}else{
		ro = null;
	}
	searchQ = searchQ + "+searchSet:" +searchSet
	var queryString = "&facet=true&facet.field=fSubject&facet.mincount=1&facet.limit=-1&rows=0";
	
	cocoon.sendPage("style/solrPublicSubjects",
		{
			"searchQ" : searchQ,
			"queryString" : queryString,
			"indexServer" : indexServer
		}
	)
}
/* ==============================================================================*/

function publicNames() {
	/* Limit by record owner value*/
	var ro = String(cocoon.request.get("ro"));
	var prefix = String(cocoon.request.get("pre"));
	searchQ = "";
	if (ro.length > 0 & ro != "null"){
		searchQ = searchQ + " recordOwner:" + escape(ro) +"";
	}else{
		ro = null;
	}
	searchQ = searchQ + "+searchSet:" +searchSet
	var queryString = "&facet=true&facet.field=l_fLastName&facet.mincount=1&facet.prefix=" + prefix + "&facet.limit=-1&rows=0";
	
	cocoon.sendPage("style/solrPublicSubjects",
		{
			"searchQ" : searchQ,
			"queryString" : queryString,
			"indexServer" : indexServer
		}
	)
}
	
/* ==============================================================================*/

function solrSearch(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var spellQ = "";
	spellQ = String(cocoon.parameters["spellQ"]);
	spellQ = spellQ.replace(/ZZxyZZ/g,"+");
	spellQ = spellQ.replace(/ZZslashZZ/g,"/");
	spellQ = spellQ.replace(/ZZampZZ/g,"&");
	spellQ = spellQ.replace(/ZZhyphenZZ/g,"-");
	spellQ = spellQ.replace(/ZZcommaZZ/g,",");
	spellQ = spellQ.replace(/ZZcolonZZ/g,":");
	spellQ = spellQ.replace(/ZZaposZZ/g,"'");
	//print("OOT spellQ line98 : "+spellQ);
	var start = String(cocoon.parameters["start"]);
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	var queryString = "&fl=id,title,titleSort,thumbnail,url,localid,description,site,type,featureComment,featureMystery,bibliographicCitation,accessionNo,madePublic,publicDisplay,creator,contributor,publisher,itemLatitude,itemLongitude,subject,source,language,spatial,temporal,created,modified,multiPart,enclosureURL,enclosureLength,enclosureType&facet=true&facet.field=type&f.type.mincount=0&facet.field=geoid&f.geoid.mincount=1&f.geoid.limit=50&facet.field=fSubject&f.fSubject.missing=true&f.fSubject.mincount=1&f.fSubject.limit=50&facet.field=fGroupName&f.fGroupName.mincount=1&facet.field=site&f.site.mincount=0&facet.field=itemType&facet.field=featureComment&facet.field=featureMystery&facet.field=publicDisplay&facet.mincount=1&facet.sort=true";
	queryString += "&hl=on&hl.fl=fulltext,title&hl.simple.pre=<strong><em>&hl.simple.post=</em></strong>&hl.fragsize=300";
//	spellcheck
	//print("OOM DYM 91 query pre spellcheck cleanup: " + q);	
//	var queryTerms = q.replace(/\((\+*(spatial|itemLatitude|fGroupName|type|featureComment|featureMystery|fSpatial|fGroupName|fSubject|Subject|site|itemType|recordOwner)\:\(?\"[^\"]*\"\)?\)?/g, "");
	//queryTerms = queryTerms.replace(/\)\+\(recordOwner\:\(\"CIN\"\+OR\+\"MHGL\"\)/, "");
	//queryTerms = queryTerms.replace(/searchSet.*$/i, "");
	//queryTerms = queryTerms.replace(/\+$/i, "");
	//print("Portal pgw Test query post spellcheck cleanup: " + queryTerms);
	//if( queryTerms.indexOf("(") != -1 ) {
	//	var first = queryTerms.indexOf("(") == -1 ? 0 : queryTerms.indexOf("(");
	//	var last = queryTerms.lastIndexOf(")") == -1 ? queryTerms.length : queryTerms.lastIndexOf(")");
	//	queryTerms = queryTerms.substring( first+1, last );
	//}
	//queryTerms = queryTerms.replace(/~.*$/i, "");
	if (spellQ.length > 0 && spellQ != "null"){
		queryString += "&spellcheck=true&spellcheck.collate=true&spellcheck.count=17&spellcheck.q=" + spellQ;
	}

//	queryString += "&facet.field=fCreator&facet.field=dateNewest&facet.field=fSource";
	var fullQuery = DMindexServer + "select?q=" + q + queryString + "&start=" +start+ "&rows="+rows;
    //commented out by art - jan 13, 2009
	//print("OOT Test5 122: " + fullQuery);
	//print("Portal Test fullQuery: "+fullQuery);

	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function solrCountGeo(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("Portal Test q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	q = "itemLatitude:[*+TO+*]" + q;
	
	//print("q2: "+q);
	var start = String(cocoon.parameters["start"]);
	var fullQuery = indexServer + "select?q=" + q + "&start=" +start+ "&rows=0";
    //commented out by art - jan 13, 2009
	//print("Portal Test fullQuery: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}

/* ==============================================================================*/

function solrDidYouMean(){
	var q = String(cocoon.parameters["q"]);
	//print("OOT DYM4 145 q: " + q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	
	var spellQ = "";
	spellQ = String(cocoon.parameters["spellQ"]);
	spellQ = spellQ.replace(/ZZxyZZ/g,"+");
	spellQ = spellQ.replace(/ZZslashZZ/g,"/");
	spellQ = spellQ.replace(/ZZampZZ/g,"&");
	spellQ = spellQ.replace(/ZZhyphenZZ/g,"-");
	spellQ = spellQ.replace(/ZZcommaZZ/g,",");
	spellQ = spellQ.replace(/ZZcolonZZ/g,":");
	spellQ = spellQ.replace(/ZZaposZZ/g,"'");
	//print("OOT spellQ line98 : "+spellQ);
	
	var start = String(cocoon.parameters["start"]);
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	var bl = String(cocoon.parameters["bl"]);
	var collation = String(cocoon.parameters["collation"]);
	collation = collation.replace(/ZZhyphenZZ/g,"-");
	//print("OOT Test5 180 collation: " + collation);
	
	//	check for multiple terms
/*	var queryTerms = q.replace(/\((\+*(spatial|itemLatitude|fGroupName|type|featureComment|featureMystery|fSpatial|fGroupName|fSubject|Subject|site|itemType|recordOwner)\:\(?\"[^\"]*\"((\+|\s)OR(\+|\s)\"[^\"]*\")?(\+|\s)?\)?\)?/g, "");
	queryTerms = queryTerms.replace(/\)\+\(recordOwner\:\(\"CIN\"\+OR\+\"MHGL\"\)/, "");
	queryTerms = queryTerms.replace(/searchSet.*$/i, "");
	queryTerms = queryTerms.replace(/\+$/i, "");
	if( queryTerms.indexOf("(") != -1 ) {
		var first = queryTerms.indexOf("(") == -1 ? 0 : queryTerms.indexOf("(");
		var last = queryTerms.lastIndexOf(")") == -1 ? queryTerms.length : queryTerms.lastIndexOf(")");
		queryTerms = queryTerms.substring( first+1, last );
	}
	queryTerms = queryTerms.replace(/~.*$/i, "");
	queryTerms = queryTerms.replace( /(\+| )+/g, " " );
	print("OOM DYM4 171 queryTerms1: ["+queryTerms+"]");
	if (queryTerms.length > 0){
	// test for multiple terms (aka is there a space?)
		var splitDelimiter = /\s+|\+/;
		var splitQ = queryTerms.replace("+OR+", "");
		var splitQ = splitQ.split(splitDelimiter);
		if (splitQ.length > 1){
			//print("DYM4 180 test splitQ: "+splitQ.length);
			//print("DidYouMean test bl: "+bl);
			//then multiple terms
			if (bl == "or") {
				// try the collation
				q = q.replace(queryTerms, collation);
				//print("DYM4 186 test OR collation: "+collation);
				//print("DYM4 187 test q OR: "+q);
			}else{
				//substitute OR and push on
				collation = splitQ.join("+OR+");
				q = q.replace(queryTerms, collation);
				//print("DYM4 192 test not OR collation: "+collation);
				//print("DidYouMean test q OR: "+q);
				//print("DYM4 194 test q: "+q);
			}
		}else{
			//there is only one term; do the collation search
			//print("DidYouMean test queryTerms: "+queryTerms);
			//print("DidYouMean test collation: "+collation);
			q = q.replace(queryTerms, collation);
			//print("DYM4 200 test q2: "+q);
		}
	}
	*/
	q = q.replace(spellQ, collation);
	var queryString = facetList;


	var fullQuery = indexServer + "select?q=" + q + queryString + "&start=" +start+ "&rows="+rows;
	//print("OOT Test5 240: " + fullQuery);
	cocoon.redirectTo(fullQuery);/**/
}
/* ==============================================================================*/

function publicSearch(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var spellQ = "";
	spellQ = String(cocoon.parameters["spellQ"]);
	spellQ = spellQ.replace(/ZZxyZZ/g,"+");
	spellQ = spellQ.replace(/ZZslashZZ/g,"/");
	spellQ = spellQ.replace(/ZZampZZ/g,"&");
	spellQ = spellQ.replace(/ZZhyphenZZ/g,"-");
	spellQ = spellQ.replace(/ZZcommaZZ/g,",");
	spellQ = spellQ.replace(/ZZcolonZZ/g,":");
	spellQ = spellQ.replace(/ZZaposZZ/g,"'");
	//print("OOT spellQ line98 : "+spellQ);
	var start = String(cocoon.parameters["start"]);
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	var queryString = facetList + facetDates;
	queryString += "&hl=on&hl.fl=fulltext,description,title&hl.simple.pre=<strong><em>&hl.simple.post=</em></strong>&hl.fragsize=300";
//	spellcheck
	//print("OOT Test7 262 Test query pre spellcheck cleanup: " + q);
//	var queryTerms = q.replace(/\((\+*(spatial|itemLatitude|fGroupName|type|featureComment|featureMystery|fSpatial|fGroupName|fSubject|Subject|site|itemType|recordOwner)\:\(?\"[^\"]*\"((\+|\s)OR(\+|\s)\"[^\"]*\")?(\+|\s)?\)?\)?/g, "");
	//queryTerms = queryTerms.replace(/\)\+\(recordOwner\:\(\"CIN\"\+OR\+\"MHGL\"\)/, "");
	//queryTerms = queryTerms.replace(/searchSet.*$/i, "");
	//queryTerms = queryTerms.replace(/\+$/i, "");
	//print("OOM DYM 232 Test query post spellcheck cleanup: " + queryTerms);
	//if( queryTerms.indexOf("(") != -1 ) {
	//	var first = queryTerms.indexOf("(") == -1 ? 0 : queryTerms.indexOf("(");
	//	var last = queryTerms.lastIndexOf(")") == -1 ? queryTerms.length : queryTerms.lastIndexOf(")");
	//	queryTerms = queryTerms.substring( first+1, last );
	//}
	//queryTerms = queryTerms.replace(/~.*$/i, "");
	if (spellQ.length > 0 && spellQ != "null"){
		queryString += "&spellcheck=true&spellcheck.collate=true&spellcheck.count=17&spellcheck.q=" + spellQ;
	}

//	queryString += "&facet.field=fCreator&facet.field=dateNewest&facet.field=fSource";
	var fullQuery = indexServer + "select?q=" + q + queryString + "&start=" +start+ "&rows="+rows;
	//print("OOT Test7 280: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function mobileSearch(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var spellQ = "";
	spellQ = String(cocoon.parameters["spellQ"]);
	spellQ = spellQ.replace(/ZZxyZZ/g,"+");
	spellQ = spellQ.replace(/ZZslashZZ/g,"/");
	spellQ = spellQ.replace(/ZZampZZ/g,"&");
	spellQ = spellQ.replace(/ZZhyphenZZ/g,"-");
	spellQ = spellQ.replace(/ZZcommaZZ/g,",");
	spellQ = spellQ.replace(/ZZcolonZZ/g,":");
	spellQ = spellQ.replace(/ZZaposZZ/g,"'");
	//print("OOT spellQ line98 : "+spellQ);
	var start = String(cocoon.parameters["start"]);
	var rows = defaultMobileRows;
	var queryString = "&fl=id,title,titleSort,thumbnail,url,localid,description,site,type,featureComment,featureMystery,bibliographicCitation,accessionNo,creator,contributor,publisher,itemLatitude,itemLongitude,subject,source,language,spatial,temporal,created,modified,madePublic,publicDisplay&facet=true&facet.field=site&facet.field=fGroupName&facet.field=type&facet.field=itemType&facet.field=featureComment&facet.field=featureMystery&facet.mincount=1&facet.limit=-1";
	queryString += "&hl=on&hl.fl=fulltext,description,title&hl.simple.pre=<strong><em>&hl.simple.post=</em></strong>&hl.fragsize=300";

	if (spellQ.length > 0 && spellQ != "null"){
		queryString += "&spellcheck=true&spellcheck.collate=true&spellcheck.count=17&spellcheck.q=" + spellQ;
	}

//	queryString += "&facet.field=fCreator&facet.field=dateNewest&facet.field=fSource";
	var fullQuery = indexServer + "select?q=" + q + queryString + "&start=" +start+ "&rows="+rows;
	//print("OOT Test7 280: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function partsSearch(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("OOT Parts test q: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var queryString = "&hl=on&hl.fl=text&fl=id,docid,partURL,label,partSort&hl.fragsize=75";

	var fullQuery = partsIndexServer + "select?q=" + q + queryString + "&start=0&rows=200";
	//print("OOT Parts Test 368: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function publicRSS(){
	var q = String(cocoon.parameters["q"]);
	var start = String(cocoon.parameters["start"]);
	if (start = "undefined")
	{
		start= "0";
	}
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	var fullQuery = indexServer + "select?q=" + q + "&fl=title,url,description,madePublic,itemLatitude,itemLongitude,thumbnail,enclosureURL,enclosureLength,enclosureType&start=" +start+ "&rows="+rows;
	//print("OOT RSS: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/
function publicAtom(){
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	var fullQuery =  indexServer + "select?q=" + q + "&fl=title,url,description,madePublic,itemLatitude,itemLongitude,thumbnail,site,creator";
	//print("OOT Atom: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/
function publicDublinCore(){
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	var start = String(cocoon.parameters["start"]);
	
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	var queryString = "&fl=title,url,description,madePublic,itemLatitude,itemLongitude,thumbnail,site,creator,contributor,publisher,bibliographicCitation,subject,source,type,language,spatial,temporal,created,modified";
	
	var fullQuery = indexServer + "select?q=" + q + queryString + "&start=" +start+ "&rows="+rows;
	//print("OOT DC: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function publicChecklists(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	//q = q.replace(/ZZbackslashZZ/g,"\");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	
	var queryString = "&facet=true&facet.field=fSubject&f.fSubject.facet.limit=10&f.fSubject.facet.sort=true&facet.field=itemType&facet.field=type&facet.field=featureMystery&facet.field=featureComment&facet.field=fSpatial&facet.field=geoid&facet.field=rightsCreativeCommons&facet.mincount=1&facet.limit=-1";
	var fullQuery = indexServer + "select?q=" + q + queryString + "&rows=0";
	//print("OOM SS fullQuery: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}/* ==============================================================================*/

function publicSlideshow(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	//q = q.replace(/ZZbackslashZZ/g,"\");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	
	var queryString = "&fl=title,url,localid,description,madePublic,thumbnail,mystery,type";
	var fullQuery = indexServer + "select?q=" + q + queryString + "&rows=" + rows;
	//print("OOM SS fullQuery: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function dmPrevNext(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	//q = q.replace(/ZZbackslashZZ/g,"\");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var rows = String(cocoon.parameters["rows"]);
	if (rows == "undefined")
	{
		rows= defaultRows;
	}
	var start = String(cocoon.parameters["start"]);
	
	var queryString = "&fl=localid";
	var fullQuery = DMindexServer + "select?q=" + q + queryString  + "&start=" +start+ "&rows="+rows;
	//print("OOT PN fullQuery: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/

function incPublicPrevNext(){
	//var q = String(cocoon.request.get("q"));
	var q = String(cocoon.parameters["q"]);
	//print("q1: "+q);
	q = q.replace(/ZZxyZZ/g,"+");
	q = q.replace(/ZZslashZZ/g,"/");
	//q = q.replace(/ZZbackslashZZ/g,"\");
	q = q.replace(/ZZampZZ/g,"&");
	q = q.replace(/ZZhyphenZZ/g,"-");
	q = q.replace(/ZZcommaZZ/g,",");
	q = q.replace(/ZZcolonZZ/g,":");
	q = q.replace(/ZZaposZZ/g,"'");
	//print("q2: "+q);
	var rows = String(cocoon.parameters["rows"]);
	var start = String(cocoon.parameters["start"]);
	var queryString = "&fl=localid";
	var fullQuery = indexServer + "select?q=" + q + queryString  + "&start=" +start+ "&rows="+rows;
	//print("OOT PN fullQuery: "+fullQuery);
	cocoon.redirectTo(fullQuery);
}
/* ==============================================================================*/
function parseSearch(callFunction){
	
	/* set of options based on calling function*/
	if (callFunction == "main"){
		var redirectScript = "style/solrQueryValues";
	}else if (callFunction == "essayResults"){
		var redirectScript = "style/essayQueryValues";
		var queryString = "";
	}else if (callFunction == "prevnext"){
		var redirectScript = "style/solrPrevNext";
		var queryString = "";
		var spage = parseInt(cocoon.request.get("spage"));
		var start = String(spage);
	}else if (callFunction == "rss"){
		var redirectScript = "style/solrRSS";
		var queryString = "";
	}else if (callFunction == "atom"){
		var redirectScript = "style/solrAtom";
		var queryString = "";
	}else if (callFunction == "dc"){
		var redirectScript = "style/solrDublinCore";
		var queryString = "";
	}else if (callFunction == "kml"){
		var redirectScript = "style/solrKML";
	}else if (callFunction == "count"){
		var redirectScript = "style/solrCount";
		var ll = "";
	}else if (callFunction == "countGeo"){
		var redirectScript = "style/solrCountGeo";
		var queryString = "";	
	}else if (callFunction == "publicResults"){
		var redirectScript = "style/publicQueryValues";	
	}else if (callFunction == "mobileResults"){
		var redirectScript = "style/mobileQueryValues";
		var rows = defaultMobileRows;
	}else if (callFunction == "parts"){
		var redirectScript = "style/solrPartsSearchValues";
		var rows = "50";
	}else if (callFunction == "checklists"){
		var redirectScript = "style/solrPublicChecklists";
	}else if (callFunction == "slideshow"){
		var redirectScript = "style/solrPublicSlideshow";
		var blnSlideShow = 1;
	}else if (callFunction == "publicPrevNext"){
		var redirectScript = "style/publicPrevNext";
		var queryString = "&fl=localid";
		var spage = parseInt(cocoon.request.get("spage"));
		var start = String(spage);
	}

	//print("OOT Test1 385: " + callFunction); 
	
// Test for errors in data input
	var qs = String(cocoon.request.getQueryString());

	// Did someone send a URL?
	//print("Search portal: "+qs);
		if (qs.search(/http%3A%2F/i) > -1)
		{
			//print("Search portal: Got to http redirect");
			cocoon.sendPage("error", 
				{"errMsg" : "The system won't process urls."}
			);
		}

	//Did someone send a left truncated search?
		var parameterNames = new Array();
		parameterNames = cocoon.request.getParameterNames();
		for (var i = 0; parameterNames != null && i < parameterNames.length; i++)
		{
			var parameterValues = new Array();
			parameterValues = cocoon.request.getParameterValues(parameterNames[i]);
			for( var j = 0; parameterValues != null && j < parameterValues.length; j++) {
				var tcElement = String(parameterValues[j]);
				if (tcElement.search(/\*|\?/) == 0 )
				{
					//print("Search portal: Got to left truncate problem");
					cocoon.sendPage("error", 
						{"errMsg" : "The system won't search for '*' or '?' in the first position."}
					);
				}
			}
		}

// Carry on processing data input

	var q = String(cocoon.request.get("q"));
	/* q2 is previous search logic, already encoded?*/
	spellQ = q;
	var q1 = q;
	var q1 = LuceneCharEscape(q1);
	//print("Test 032: line 652: "+q);
	var q2 = String(cocoon.request.get("q2"));
	
	if ((q2.length > 0) && (q2 != "null") && (q2 != undefined)){
		spellQ += " " + q2;
	}
	/* bl is boolean logic*/
	var bl = String(cocoon.request.get("bl"));
	/* searchWhere triggers the inclusion of the previous logic choices are "a" for "all" or "c" for "add to current search logic" */
	var w = String(cocoon.request.get("w"));
	/* search type limits the scope of the search with the current "q" value to specific fields: kw, ti, su to start": default kw */
	var st = String(cocoon.request.get("st"));
	if (!st){
		st = "kw";
	}
	/* fuzziness: qualifies the "q" value with a Lucene fuzzy search: expect 0,1,2,3" */
	var fz = String(cocoon.request.get("fz"));
	
	/* docid: scopes parts searches to individual records in main indexserver */
	var did = String(cocoon.request.get("docid"));

	/* Limit by subject as array (fSubject)*/
	var fSubjectsTest = String(cocoon.request.get("fsu"));
	var fSubjects = new Array();
	if (fSubjectsTest.length > 0 && fSubjectsTest != "null"){
		fSubjects = cocoon.request.getParameterValues('fsu');
	}
	var fsu = "";

	/* Limit by location as array (fSpatial)*/
	var fSpatialTest = String(cocoon.request.get("lc"));
	var fSpatial = new Array();
	if (fSpatialTest.length > 0 && fSpatialTest != "null"){
		fSpatial = cocoon.request.getParameterValues('lc');
	}
	var lc = "";
		/* boolean flag for suppressing/displaying additional Spatial facets */
		var lcmore = String(cocoon.request.get("lcmore"));

	/* Limit by location as keyword search(Spatial)*/
	var sp = String(cocoon.request.get("sp"));
	var sp1 = sp;

	/* Limit by location as id (which may get selected more than once) (geoid)*/
	var GeoidTest = String(cocoon.request.get("gid"));
	var aGeoid = new Array();
	if (GeoidTest.length > 0 && GeoidTest != "null"){
		aGeoid = cocoon.request.getParameterValues('gid');
	}
	var gid = "";

	/* Limit by group using id (groupid)*/
	var GroupIDTest = String(cocoon.request.get("grd"));
	var aGroupid = new Array();
	if (GroupIDTest.length > 0 && GroupIDTest != "null"){
		aGroupid = cocoon.request.getParameterValues('grd');
	}
	var grd = "";

	/* Limit site by group using id (groupid)
		specifically ad to solr scope; but do not return as part of unparsed query, etc.
		*/
	var SiteGroupIDTest = String(cocoon.request.get("sgrd"));
	var aSiteGroupid = new Array();
	if (SiteGroupIDTest.length > 0 && SiteGroupIDTest != "null"){
		aSiteGroupid = cocoon.request.getParameterValues('sgrd');
	}
	var sgrd = "";

	/* Limit by group using faceted group name (fGroupName)*/
	var GroupNameTest = String(cocoon.request.get("grn"));
	var afGroupName = new Array();
	if (GroupNameTest.indexOf(',') > 0)
	{
		if (GroupNameTest.length > 0 && GroupNameTest != "null"){
			afGroupName = cocoon.request.getParameterValues('grn');
		}
	}else{
		if (GroupNameTest.length > 0 && GroupNameTest != "null")
		{
			afGroupName[0] = GroupNameTest;
		}
		
	}
	//print("Test O31 line 620: " + GroupNameTest);
	//var parm = new String(afGroupName[0].getBytes("ASCII"), "UTF-8");
	//print("Test O31 line 626b: " + afGroupName[0]);
	var grn = "";
	
		/* boolean flag for suppressing/displaying additional group name facets */
		var grnMore = String(cocoon.request.get("grnMore"));
		/* boolean flag for ordering site facets: expect 'a' (alpha) or n(normal number/descending frequency) */
		var grnSort = String(cocoon.request.get("grnSort"));

	/* Limit by item type  (itemType)*/
	var ItemTypeTest = String(cocoon.request.get("itype"));
	/*var aItemType = new Array();
	if (ItemTypeTest.length > 0 && ItemTypeTest != "null"){
		aItemType = cocoon.request.getParameterValues('itype');
	}*/
	var aItemType1 = new Array();
	var aItemType2 = new Array();
	var iItemType2 = 0;
	if (ItemTypeTest.length > 0 && ItemTypeTest != "null"){
		aItemType1 = cocoon.request.getParameterValues('itype');
		for (var iItemType = 0; iItemType < aItemType1.length; iItemType++) {
			var ItemTypeStr = String(aItemType1[iItemType]);
			var aItemTypeSplit = ItemTypeStr.split(";");
			for (var iItemTypeSplit=0; iItemTypeSplit < aItemTypeSplit.length; iItemTypeSplit++){
				if (aItemTypeSplit[iItemTypeSplit].length > 0){
					aItemType2[iItemType2] = aItemTypeSplit[iItemTypeSplit];
					iItemType2++;
				}
			}
		}
	}
	var itype = "";
	
	/* Limit site by item type  (also itemType)*/
	/*
	var SItemTypeTest = String(cocoon.request.get("sitype"));
	var aSItemType1 = new Array();
	var aSItemType2 = new Array();
	var iSItemType2 = 0;
	if (SItemTypeTest.length > 0 && SItemTypeTest != "null"){
		aSItemType1 = cocoon.request.getParameterValues('sitype');
		print("OOT Test1 75: " + aSItemType1); 
		for (var iSItemType = 0; iSItemType < aSItemType1.length; iSItemType++) {
			var SItemTypeStr = String(aSItemType1[iSItemType]);
			var aSItemTypeSplit = SItemTypeStr.split(";");
			for (var iSItemTypeSplit=0; iSItemTypeSplit < aSItemTypeSplit.length; iItemTypeSplit++){
				if (aSItemTypeSplit[iSItemTypeSplit].length > 0){
					aSItemType2[iSItemType2] = aSItemTypeSplit[iSItemTypeSplit];
					iSItemType2++;
				}
			}
		}
	}
	var sitype = "";
	*/
	
	/* Limit by mediaType  ("type" in solr)*/
	var MediaTypeTest = String(cocoon.request.get("mt"))
	var aMediaType = new Array();
	if (MediaTypeTest.length > 0 && MediaTypeTest != "null"){
		aMediaType = cocoon.request.getParameterValues('mt');
	}
	var mt = "";

	/* Limit by mediaType  ("type" in solr)*/
	var SiteMediaTypeTest = String(cocoon.request.get("smt"))
	var aSiteMediaType = new Array();
	if (SiteMediaTypeTest.length > 0 && SiteMediaTypeTest != "null"){
		aSiteMediaType = cocoon.request.getParameterValues('smt');
	}
	var smt = "";

	/* Limit by presence of comments in record (featureComment)*/
	var featureCommentTest = String(cocoon.request.get("fc"))
	var afeatureComment = new Array();
	if (featureCommentTest.length > 0 && featureCommentTest != "null"){
		afeatureComment = cocoon.request.getParameterValues('fc');
	}
	var fc = "";

	/* Limit by presence of mysteries in record (featureMystery)*/
	var featureMysteryTest = String(cocoon.request.get("fm"))
	var afeatureMystery = new Array();
	if (featureMysteryTest.length > 0 && featureMysteryTest != "null"){
		afeatureMystery = cocoon.request.getParameterValues('fm');
	}
	var fm = "";

	/* Limit by specific Creative Commons rights values (rightsCreativeCommons)*/
	var rightsCCTest = String(cocoon.request.get("cc"));
	/*var arightsCreativeCommons = new Array();
	if (rightsCreativeCommonsTest.length > 0 && rightsCreativeCommonsTest != "null"){
		arightsCreativeCommons = cocoon.request.getParameterValues("cc");
	}
	var aSize = arightsCreativeCommons.length; // the size of the array will be changing so we need to know how many originated
	for(var i = 0; i < aSize; i++ ) {
		var str = arightsCreativeCommons.shift(); // removes the first element of the array
		// could remove excess whitespace here
		var aSplit = str.split(/[,;]/); // this takes the character ',' or ';' to split on
		arightsCreativeCommons = arightsCreativeCommons.concat( aSplit); // adds the new array to the old array or will re-add the original string if no need to split
	}
	*/
	var arightsCC1 = new Array();
	var arightsCC2 = new Array();
	var irightsCC2 = 0;
	if (rightsCCTest.length > 0 && rightsCCTest != "null"){
		arightsCC1 = cocoon.request.getParameterValues('cc');
		for (var iCC = 0; iCC < arightsCC1.length; iCC++) {
			var ccStr = String(arightsCC1[iCC]);
			var aCCSplit = ccStr.split(/[,;]/);
			for (var iCCSplit=0; iCCSplit < aCCSplit.length; iCCSplit++){
				if (aCCSplit[iCCSplit].length > 0){
					arightsCC2[irightsCC2] = aCCSplit[iCCSplit];
					irightsCC2++;
				}
			}
		}
	}
	var cc = "";
	// arghtsCreativeCommons contains all the cc values each with its own index

	/* Limit by presence of Creative Commons in record -- but drawing from the results facet panel (rightsCreativeCommons)*/
	var facetCCTest = String(cocoon.request.get("fcc"))
	var afacetCC = new Array();
	if (facetCCTest.length > 0 && facetCCTest != "null"){
		afacetCC = cocoon.request.getParameterValues('fcc');
	}
	var fcc = "";


	/* Limit by status of publicDisplay */
	var pd = String(cocoon.request.get("pd"));

	/* Limit by site value*/
	var siteTest = String(cocoon.request.get("site"))
		//print("Portal Test siteTest arrived: "+siteTest);
	var aSite1 = new Array();
	var aSite2 = new Array();
	var iSite2 = 0;
	if (siteTest.length > 0 && siteTest != "null"){
		aSite1 = cocoon.request.getParameterValues('site');
		for (var iSite = 0; iSite < aSite1.length; iSite++) {
			var siteStr = String(aSite1[iSite]);
			var aSiteSplit = siteStr.split(";");
			for (var iSiteSplit=0; iSiteSplit < aSiteSplit.length; iSiteSplit++){
				if (aSiteSplit[iSiteSplit].length > 0){
					aSite2[iSite2] = aSiteSplit[iSiteSplit];
					iSite2++;
				}
			}
		}
	}
	var site = "";
		/* boolean flag for suppressing/displaying additional site facets */
		var siteMore = String(cocoon.request.get("siteMore"));
		/* boolean flag for ordering site facets: expect 'a' (alpha) or n(normal number/descending frequency) */
		var siteSort = String(cocoon.request.get("siteSort"));

	/* Limit by record owner value*/
	var ro = String(cocoon.request.get("ro"));

	/*Limit by year*/
	var yearTest = String(cocoon.request.get("year"));
	var aYear = new Array();
	if(yearTest.length > 0 && yearTest != "null") {
		aYear = cocoon.request.getParameterValues('year');
	}
	var year = "";
	var yearMore = String(cocoon.request.get("yearMore"));
	var yearSort = String(cocoon.request.get("yearSort"));
	
	/* Search by Date */
	var dateAfter = String(cocoon.request.get("da"));
	var dateBefore = String(cocoon.request.get("db"));
	var dateYearSearch = String(cocoon.request.get("dt"));
	var dateYearFuzziness = parseInt(cocoon.request.get("dtfz"));
	var dateYearFacet = String(cocoon.request.get("dy"));
	var dateDecade = String(cocoon.request.get("dd"));
	var dateCentury = String(cocoon.request.get("dc"));
	
	/*Limit by source*/
	var sourceTest = String(cocoon.request.get("source"));
	var aSource = new Array();
	if(sourceTest.length > 0 && sourceTest != "null") {
		aSource = cocoon.request.getParameterValues('source');
	}
	var source = "";
	var sourceMore = String(cocoon.request.get("sourceMore"));
	var sourceSort = String(cocoon.request.get("sourceSort"));
		
	/*Limit by creator*/
	var creatorTest = String(cocoon.request.get("creator"));
	var aCreator = new Array();
	if( creatorTest.length > 0 && creatorTest != "null") {
		aCreator = cocoon.request.getParameterValues('creator');
	}
	var creator = "";
	var creatorMore = String(cocoon.request.get("creatorMore"));
	var creatorSort = String(cocoon.request.get("creatorSort"));
	
	/*Search by names*/
	  /*last name*/
	var LastNameTest = String(cocoon.request.get("ln"));
	var aLastName = new Array();
	if( LastNameTest.length > 0 && LastNameTest != "null") {
		aLastName = cocoon.request.getParameterValues('ln');
	}
	var ln = "";
	var LastName = "";
	  /*Personal name*/
	var PersNameTest = String(cocoon.request.get("pn"));
	var aPersName = new Array();
	if( PersNameTest.length > 0 && PersNameTest != "null") {
		aPersName = cocoon.request.getParameterValues('pn');
	}
	var pn = "";
	var PersName = "";
	  /*Corporate name*/
	var CorpNameTest = String(cocoon.request.get("cn"));
	var aCorpName = new Array();
	if( CorpNameTest.length > 0 && CorpNameTest != "null") {
		aCorpName = cocoon.request.getParameterValues('cn');
	}
	var cn = "";
	var CorpName = "";

	/*Limit by title*/
	var title = String(cocoon.request.get("title"));
	
	/* field to sort the result set: default score */
	var SortTest = String(cocoon.request.get("sort"));
	var aSort = new Array();
	var sort = "";
	if( SortTest.length > 0 && SortTest != "null") 
	{
		aSort = cocoon.request.getParameterValues('sort');
	}
	var aSortLength = aSort.length;
	if (aSortLength > 0)
	{
		aSortLength = aSortLength - 1;
		sort = aSort[aSortLength];
	}else{
		sort = "score+desc";
	}
	/* p is page number */
	var p = parseInt (cocoon.request.get("p"));
	if (!p){
		p = 1;
	}
	/* number of rows for paging the result set: default 40*/
	var getRows = cocoon.request.get("rows");
	if (callFunction == "mobileResults"){
		rows = parseInt(defaultMobileRows);
	}else if (!getRows){
		rows = parseInt(defaultRows);
	}else {
		rows = parseInt(getRows);
	}
	if (callFunction == "kml"){
		rows = 200;
	}

/* add the fixed parameters */

/* start manipulating values*/

	/* paging */
	if (!start)
	{
		var start = ((p - 1) * rows);
	}
	/* reset values to String to drop Rhino's ".0" value */
	p = String(p);
	rows = String(rows);
	start = String(start);


/* query */
	searchQ = "";
	unparsedQuery = "";
	/* work on q as array if "or" required or fuzzy logic required*/
	if ((q.length > 0) && (q != "null") && (q != undefined))
		unparsedQuery = unparsedQuery +"q="+q1+"&";
	else{
		q = null;
		unparsedQuery = unparsedQuery +"q=&";
	}
	if (bl=="null")
	{
		bl = null;
	}else{
		unparsedQuery = unparsedQuery +"bl="+bl+"&";
	}
	if ((fz.length > 0) && (fz != "null") && (fz != undefined) && (fz != 0) && (String(fz) != "0"))
	{
		unparsedQuery = unparsedQuery +"fz="+fz+"&";
	}else{
		fz = "0";
	}
	if (st=="null")
	{
		st= null;
	}else if (st != "kw"){
		unparsedQuery = unparsedQuery +"st="+st+"&";
	}
	if (q1)
	{

	/* trim extra spaces and break q into words */
		var splitDelimiter = /\s+/;
		var splitQ = q1.split(splitDelimiter);
		//var lengthQ = splitQ.length;

		if (fz == "1"){
			/* regular expression to tack "~0.75" to the end of each word*/
			var fuzzyModifier = "~0.70";
		}else if (fz == "2"){
			var fuzzyModifier = "~0.60";
		}else if (fz == "3"){
			var fuzzyModifier = "~0.50";
		}else {
			var fuzzyModifier = "";
			fz = "0";
		}

	/* in lieu of a good trim, shift the populated values to a new array*/
		//print("q:" + q);
		var arrayQ = new Array();
		var aIndex = 0;
		for (var index=0; index < splitQ.length; index++){
			if (splitQ[index].length > 0  && (splitQ[index] != "null") && (splitQ[index] != undefined))
			{
				arrayQ[aIndex] = splitQ[index];
				aIndex++;
			}
		}
	/* reassemble the q value without the possible extraneous elements
		and add the Q modifiers if q is not empty */

		var lengthQ = arrayQ.length;
		lengthQ = aIndex;
		if (aIndex > 0)
		{
			q1 = arrayQ.join(" ");

			/*add the fuzzyModifier if necessary*/
				if (fz|bl=="or"){
					for (index=0; index < arrayQ.length; index++){
						arrayQ[index] = arrayQ[index]+fuzzyModifier;
					}
				}
			/* assemble the array values as a string again, appropriately joined*/
				if (bl=="or"){
					searchQ = arrayQ.join(" OR ");
				}else{
					searchQ = arrayQ.join(" ");
				}
				if (bl!="or" && bl!="phrase")
				{
					bl = null;
				}
				
	searchQ = searchQ.replace( /(\+| )+/g, " " );

	/* save searchQ at this stage to partsQ for passing to multiPart searching*/
		var partsQ = searchQ;
		partsQ = partsQ.replace(/\x26/g,"%26");

			/* if boolean is a phrase put in quotes, otherwise in parentheses*/
				if (bl=="phrase"){
					searchQ = searchQ.replace( /"/g, ""); 
					searchQ = "\"" + searchQ + "\"";
					/* if a phrase is requested via the bl parameter adjust the q parameter 
						to have double quotes so as to persist through other searches */
					q = q.replace( /"/g, "");
					q = "\"" + q + "\"";
				}else{
					if (searchQ.charAt(0)!="("){
						searchQ = "(" + searchQ + ")";
					}
				}
				if (bl=="null"){
					bl = null;
				}

			/* qualify by searchType (st)*/
				if (st == "ti"){
					searchQ = "title:" + searchQ;
				}else if (st == "su"){
					searchQ = "subject:" + searchQ;
				}else if (st == "au"){
					searchQ = "((creator:" + searchQ + ") OR (contributor: "  + searchQ + "))" ;
				}else if (st == "ln"){
					searchQ = "l_LastName:" + searchQ;
				}else if (st == "pn"){
					searchQ = "l_PersName:" + searchQ;
				}else if (st == "cn"){
					searchQ = "l_CorpName:" + searchQ;
				}else if (st == "ac"){
					searchQ = "accessionNo:" + searchQ;
				}else if (st == "sr"){ // source
					searchQ = "source:" + searchQ;
				}else if (st == "md"){ // meta-data only
					searchQ = "text" + searchQ;
				}else{
					st = null;
				}
		}else{
			q1 = null;
		}
	}else{
		q1 = null;
	}

	if (fz=="null"){
		fz = null;
	}
//print("searchQ: " + searchQ);
if (searchQ=="(null)"){
	searchQ = "";
}else{
	searchQ = searchQ.replace(/\x26/g,"%26");
}
//print("searchQ2: " + searchQ);
/* ****************** Now add alternates to the q value************ */

/* add did -- docid -- for parts searches */
	if (did.length > 0 & did != "null"){
		if (searchQ.length > 0 & searchQ != "null"){
			searchQ = searchQ + "+AND+docid:(" +did +")";
		}else{
			searchQ = searchQ + "docid:(" +did +")";
		}
	}
/*qualify by Subjects as facet*/
	fsu = parseValue("fsu", "fSubject", fSubjects);

/*qualify by Search Location as facet*/
	lc = parseValue("lc", "fSpatial", fSpatial);
	/* process the show more value: either null, 0 or 1 */
		if (lcmore.length > 0 & lcmore != "null"){
			unparsedQuery = unparsedQuery +"lcmore="+lcmore+"&";
		}else{
			lcmore = null;
		}

/*qualify by Location as keyword search*/
	//print( "Portal pgw spatial: " + sp1 );
	if ((sp1.length > 0) && (sp1 != "null") && (sp1 != undefined)){
		searchQ = searchQ + " spatial:(" +sp1 +")";
		unparsedQuery = unparsedQuery +"sp="+sp1+"&";
	}else{
		sp = null;
	}
/*qualify by Location as geoid*/
	gid = parseValue("gid", "geoid", aGeoid);

/*qualify by Group using groupid*/
	if (aGroupid != null && aGroupid.length > 0) {
		grd = aGroupid[0];
		/* deal with the possibility that this is a slideshow call*/
		//mystery?
		if (String(grd) == String(99999)){
			searchQ = searchQ + " featureMystery: true";
			unparsedQuery = unparsedQuery + "grd="+grd+"&";
			//print( "wrl OOT Test7 got to line 905");
		//What's new
		}else if (String(grd) == String(99998)){
			rows = String(15);
			sort = "madePublic+desc";
		//regular group
		}else{
			//print( "wrl OOT Test7 got to line 909");
			grd = parseValue("grd", "groupid", aGroupid);
			//sort by first groupid in the parameter set... because we have to pick one
			sort = "groupid_"+aGroupid[0]+"+asc";
		}
	}

/*qualify Site by group name as facet*/
	sgrd = parseValue("sgrd", "groupid", aSiteGroupid);
	

/*qualify by group name as facet*/
	//print("Test O29: line 1039: "+afGroupName[0]);

	grn = parseValue("grn", "fGroupName", afGroupName);
	grnMore = listMore("grnMore", grnMore);
	grnSort = listMore("grnSort", grnSort);
	
	//print("Test O29: line 1045: "+grn);

/*qualify by site*/
	site = parseValue("site", "site", aSite2, " OR ");
	siteMore = listMore("siteMore", siteMore);
	siteSort = listMore("siteSort", siteSort);

/*qualify by dateNewest*/
	year = parseValue("year", "dateNewest", aYear);
	yearMore = listMore( "yearMore", yearMore );
	yearSort = listMore( "yearSort", yearSort );

/*qualify by date*/
	if ((dateAfter != null && dateAfter.length > 0 && dateAfter != "null") && (dateBefore != null && dateBefore.length > 0 && dateBefore != "null")){
		searchQ = searchQ + " dateSort:["+dateAfter +" TO "+dateBefore +"]";
		unparsedQuery = unparsedQuery +"da="+dateAfter+"&db="+dateBefore+"&";
	}else if (dateAfter != null && dateAfter.length > 0 && dateAfter != "null") {
		searchQ = searchQ + " dateSort:["+dateAfter +" TO *]";
		unparsedQuery = unparsedQuery +"da="+dateAfter+"&";
	}else if (dateBefore != null && dateBefore.length > 0 && dateBefore != "null") {
		searchQ = searchQ + " dateSort:[* TO "+dateBefore +"]";
		unparsedQuery = unparsedQuery +"db="+dateBefore+"&";
	}
	if (dateAfter == "null")
	{
		dateAfter = null;
	}
	 if (dateBefore == "null")
	{
		dateBefore = null;
	}
	if (dateYearSearch == "null" )
	{
		dateYearSearch = null;
	}
	 if (dateYearFuzziness == "null")
	{
		dateYearFuzziness = null;
	}
	if (dateYearFacet != null && dateYearFacet > 0 && dateYearFacet != "null") {
			searchQ = searchQ + " fDateYear:"+dateYearFacet;
			unparsedQuery = unparsedQuery +"dy="+dateYearFacet+"&";
	}else if (dateYearFacet == "null")
	{
		dateYearFacet = null;
	}
	if (dateDecade != null && dateDecade > 0 && dateDecade != "null") {
			searchQ = searchQ + " fDateDecade:"+dateDecade;
			unparsedQuery = unparsedQuery +"dd="+dateDecade+"&";
	}else if (dateDecade == "null")
	{
		dateDecade = null;
	}
	if (dateCentury != null && dateCentury > 0 && dateCentury != "null") {
			searchQ = searchQ + " fDateCentury:"+dateCentury;
			unparsedQuery = unparsedQuery +"dc="+dateCentury+"&";
	}else if (dateCentury == "null")
	{
		dateCentury = null;
	}

/* qualify by fuzzy date search .. with fq*/
	var filterQ = "";
	if (dateYearSearch != null && dateYearSearch > 0 && dateYearSearch != "null") {
		if (dateYearFuzziness != null && dateYearFuzziness > 0 && dateYearFuzziness != "null") {
			var dateOld = dateYearSearch - dateYearFuzziness;
			var dateNew = parseFloat(dateYearSearch) + parseFloat(dateYearFuzziness);
			filterQ = filterQ + "&fq=(dateOldest:[* TO "+dateNew+"] AND dateNewest:["+dateOld+" TO *])";
			unparsedQuery = unparsedQuery +"dt="+dateYearSearch+"&dtfz="+dateYearFuzziness+"&";
		}else{
			filterQ = filterQ + "&fq=dateOldest:[* TO "+dateYearSearch+"] dateNewest:["+dateYearSearch+" TO *]";
			unparsedQuery = unparsedQuery +"dt="+dateYearSearch+"&";
		}
	}
/*qualify by fCreator*/
	creator = parseValue("creator", "fCreator", aCreator);
	creatorMore = listMore( "creatorMore", creatorMore );
	creatorSort = listMore( "creatorSort", creatorSort );
	
/*qualify by Last Name */
	ln = parseValue("ln", "l_LastName", aLastName, " OR ");
/*qualify by Personal Name */
	pn = parseValue("pn", "l_PersName", aPersName, " OR ");
/*qualify by Last Name */
	cn = parseValue("cn", "l_CorpName", aCorpName, " OR ");

/*qualify by fSource*/
	source = parseValue("source", "fSource", aSource);
	sourceMore = listMore( "sourceMore", sourceMore );
	sourceSort = listMore( "sourceSort", sourceSort );
	
/*qualify by title*/
	if (title.length > 0 & title != "null") {
		searchQ = searchQ + " title:\"" + title + "\"";
		unparsedQuery = unparsedQuery +"title="+title+"&";
	}
/*qualify by recordOwner*/
	if (ro.length > 0 & ro != "null"){
		searchQ = searchQ + " (recordOwner:" + ro +")";
	}else{
		ro = null;
	}
/*qualify by itemType (itype)*/
	itype = parseValue("itype", "itemType", aItemType2, " OR ");
	
/*qualify by site itemType (sitype)*/
/*
	sitype = parseValue("sitype", "itemType", aSItemType2, " OR ");
	print("OOT Test1 853: " + sitype); 
*/
/*qualify by mediaType (mt)*/
	mt = parseValue("mt", "type", aMediaType);

/*qualify Site by mediaType (smt)*/
	smt = parseValue("smt", "type", aSiteMediaType);

/*qualify by presence of Comment*/
	fc = parseValue("fc", "featureComment", afeatureComment);

/*qualify by presence of Mystery*/
	fm = parseValue("fm", "featureMystery", afeatureMystery);

/*qualify by presence of Creative Commons rights*/
	cc = parseValue("cc", "rightsCreativeCommons", arightsCC2, " OR ");

/*qualify by presence of Creative Commons rights*/
	fcc = parseValue("fcc", "rightsCreativeCommons", afacetCC);

/*qualify by status of publicDisplay*/
	if (pd)
	{
		if (pd.length > 0 & pd != "null"){
			searchQ = searchQ + " publicDisplay:" + pd;
			unparsedQuery = unparsedQuery +"pd="+pd+"&";
		}else{
			pd = null;
		}
	}
/*add in values from previous search(es) */
	if ((q2.length > 0) && (q2 != "null") && (q2 != undefined) && (q2 != " ")){
		searchQ = searchQ + " " + q2;
		unparsedQuery = unparsedQuery +"q2="+q2+"&";
	}else{
		q2 = null;
	}

/*add in sort value if it is not the default sort*/
	if ((sort.length > 0) && (sort != "null") && (sort != undefined) && (sort != "score+desc")){
		unparsedQuery += "sort=" + sort;
	}

/* add for KML*/
if (callFunction == "kml"||callFunction == "countGeo"){
	searchQ = searchQ + " itemLatitude:[* TO *]"
}
/* add searchSet and sort constraints  if there isn't already a docid to constrain to*/
if (did.length == 0 | did == "null"){	
	searchQ += " searchSet:" + searchSet + "&sort=" +sort;
}else{	
	searchQ +="&sort=partSort+asc";
}
searchQ = searchQ + filterQ;

/* substitute for some pita characters*/
	//print( "wrl OOM Test3 searchQ: [" + searchQ +"]");
	//print("Portal Test2 searchQ: "+searchQ);
	var decodeQ = searchQ;
	//print("Portal Test2 decodeQ 847: "+decodeQ);
	decodeQ = decodeQ.replace(/ /g,"ZZxyZZ");
	//decodeQ = decodeQ.replace(/+/g,"ZZxyZZ");
	decodeQ = decodeQ.replace(/\x2F/g,"ZZslashZZ");
	decodeQ = decodeQ.replace(/\x26/g,"ZZampZZ");
	decodeQ = decodeQ.replace(/\x2D/g,"ZZhyphenZZ");
	decodeQ = decodeQ.replace(/\x8211/g,"ZZhyphenZZ");
	decodeQ = decodeQ.replace(/\x2C/g,"ZZcommaZZ");
	decodeQ = decodeQ.replace(/\x3A/g,"ZZcolonZZ");
	decodeQ = decodeQ.replace(/\x60/g,"ZZaposZZ");
	decodeQ = decodeQ.replace(/\x27/g,"ZZaposZZ");
	decodeQ = decodeQ.replace(/\x8242/g,"ZZaposZZ");
	decodeQ = decodeQ.replace(/\x8216/g,"ZZaposZZ");
	decodeQ = decodeQ.replace(/\x8217/g,"ZZaposZZ");
	decodeQ = decodeQ.replace(/\x8218/g,"ZZaposZZ");
	//print("Portal Test2 decodeQ 860: "+decodeQ);
	
	 
	spellQ = spellQ.replace(/ /g,"ZZxyZZ");
	//spellQ = spellQ.replace(/+/g,"ZZxyZZ");
	spellQ = spellQ.replace(/\x2F/g,"ZZslashZZ");
	spellQ = spellQ.replace(/\x26/g,"ZZampZZ");
	spellQ = spellQ.replace(/\x2D/g,"ZZhyphenZZ");
	spellQ = spellQ.replace(/\x8211/g,"ZZhyphenZZ");
	spellQ = spellQ.replace(/\x2C/g,"ZZcommaZZ");
	spellQ = spellQ.replace(/\x3A/g,"ZZcolonZZ");
	spellQ = spellQ.replace(/\x27/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x60/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x27/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x8242/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x8216/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x8217/g,"ZZaposZZ");
	spellQ = spellQ.replace(/\x8218/g,"ZZaposZZ");
	//print("OOT SpellQ: " + spellQ);

	/*trim unparsed query's trailing &amp;*/
	var strlength = unparsedQuery.length;
	//unparsedQuery = unparsedQuery.substr(0,strlength-1)
	
/* add some values for statistical purposes*/
	var vitaSite = String(cocoon.request.get("vitaSite"));
	var UserSessionID = String(cocoon.request.get("UserSessionID"));
	var UserAgent = String(cocoon.request.get("UserAgent"));
	var IPAddress = String(cocoon.request.get("IPAddress"));
	//print("IPAddress: " + IPAddress);
	var date = new Date();
	var timestamp = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+"-"+date.getHours()+"-"+date.getMinutes()+"-"+date.getSeconds();  //yyyy-MM-dd-hh-mm-ss
	var titleTrim = urlShortTitle(q); //drop '/'; single space to _; drop non A-Za-z0-9; trim to 20; trim leading and trailing spaces;

/* for companion search counts that need to suppress null searches */
	var query = q  != null ? q.replace(/ /g, "+").replace( "*:*", "") : "";
	var query2 = q2 != null ? q2.replace(/ /g, "+").replace( "*:*", "") : "";

	//print("fullQuery:" + fullQuery);
	//cocoon.sendPage("style/solrQueryValues",
	cocoon.sendPage(redirectScript,
		{
			"searchQ" : searchQ,
			"spellQ" : spellQ,
			"partsQ" : partsQ,
			"q" : q,
			"q2" : q2,
			"bl" : bl,
			"w" : w,
			"st" : st,
			"fsu" : fsu,
			"fz" : fz,
			"lc" : lc,
			"sp" : sp,
			"gid" : gid,
			"dateAfter" : dateAfter,
			"dateBefore" : dateBefore,
			"dateYearSearch" : dateYearSearch,
			"dateYearFuzziness" : dateYearFuzziness,
			"dateYearFacet" : dateYearFacet,
			"dateDecade" : dateDecade,
			"dateCentury" : dateCentury,
			"ln": ln,
			"pn": pn,
			"cn": cn,
			"site" : site,
			"grd" : grd,
			"grn" : grn,
			"ro" : ro,
			"itype" : itype,
			//"sitype" : sitype,
			"mt" : mt,
			"fm" : fm,
			"fc" : fc,
			"cc" : cc,
			"fcc" : fcc,
			"pd" : pd,
			"sort" : sort,
			"p" : p,
			"rows" : rows,
			"queryString" : queryString,
			"unparsedQuery" : unparsedQuery,
			"start" : start,
			"decodeQ" : decodeQ,
			"vitaSite" : vitaSite,
			"UserSessionID" : UserSessionID,
			"UserAgent" : UserAgent,
			"IPAddress" : IPAddress,
			"timestamp": timestamp,
			"titleTrim" : titleTrim
		}
	);
}

function parseValue(valuePair, solrField, valueArray, blnOption){
	var returnString = "";
    //commented out by art - jan 13, 2009
	//print("blnOption4 valueArray count:(" + valueArray.length+") "+blnOption);
	if (valueArray != null && valueArray.length > 0) {
		searchQ += " (";
		for (var i = 0; i < valueArray.length; i++) {
			var individualValue = String(valueArray[i]);
			individualValue = individualValue.replace(/^\s+/, '');
			individualValue = individualValue.replace(/\x26/g,"%26");
			individualValue = LuceneCharEscape(individualValue);
			if (blnOption)
			{
                //commented out by art - jan 13, 2009
				//print("blnOption 1514:(" + solrField+") "+blnOption);
				searchQ += " " + solrField +":\"" + individualValue + "\"" + blnOption;
				
                //commented out by art - jan 13, 2009
				//print("blnOption4 (searchQ):(" + searchQ + ") ");
			}else{
				searchQ += " " + solrField +":\"" + individualValue +"\" ";
			}
			if (valuePair != 'smt')
			{
				unparsedQuery += valuePair + "=" + individualValue + "&";
			}
            //commented out by art - jan 13, 2009
			//print("blnOption4 2 (unparsedQuery):(" + unparsedQuery + ") ");
			if (i > 0)
			{
				//if (blnOption){
				//	returnString = returnString + blnOption + "\"" + valueArray[i] + "\"";
				//}else{
					returnString = returnString + "; " + valueArray[i];
				//}
			}else{
				//returnString = "\"" + valueArray[i] + "\"";
				returnString = valueArray[i];
			}
		}//for
		if (blnOption){
			searchQ = searchQ.replace(/ OR $/,"");
			//searchQ = "(" + searchQ + ")";
			//print("Test6 (searchQ):(" + searchQ + ") ");
            //commented out by art - jan 13, 2009
			//print("Test6 (returnString):(" + returnString + ") ");


		}
		searchQ += ")";
	}//if 
	return returnString;
}

function listMore(label, value) {
	if (value.length > 0 && value != "null"){
		unparsedQuery += label + "=" + value +"&";
	}else{
		return null;
	}
	return value;
}

function LuceneCharEscape(value) {
	// escape various characters in user entered data that Lucene is troubled by
	// exception for paired quotes being used as user entered phrase logic
	//print "Test 032: " + value;
	if (value.length > 0 && value != "null"){
		var DoubleQuoteCount = value.match( "\"");
		var DoubleQuoteRemainder = 0;
		if (DoubleQuoteCount != null)
		{
			DoubleQuoteRemainder = DoubleQuoteCount.length % 2;
		}
		if (DoubleQuoteRemainder == 0 )
		{
			value = value.replace( /[\:\-\!\(\)\[\]\{\}\^\~\?\\]/g,"\\$&");
		}else{
			value = value.replace( /[\:\-\!\(\)\[\]\{\}\^\"\~\?\\]/g,"\\$&");
		}
	}else{
		return null;
	}
	return value;
}

function urlShortTitle (input){
	if (input){
		var maxLength = 20;
		var ret = "";
		// replace encoded spaces
		input = input.replace(/%20/g, " ");
		// remove all non-ascii characters
		input = input.replace(/[^A-Za-z0-9 ]/g, "");
		// remove multiple spaces
		input = input.replace(/\s+/g, " ");
		// remove leading and trailling spaces
		input = input.replace(/^\s+|\s$/g, "");
		if (maxLength >= input.length){
			ret=input;
		}else if(" " == input.charAt(maxLength-1)){
			ret = input.substring(0, maxLength-1);
		}else if(" " == input.charAt(maxLength)){
			ret = input.substring(0, maxLength);
		}else if(input.substring(0, maxLength).indexOf(" ") > 0){
			ret = input.substring(0, input.substring(0, maxLength).lastIndexOf(" "));
		}else{
			ret = input.substring(0, maxLength);
		}
		return ret;
	}else{
		return input;
	}
}
