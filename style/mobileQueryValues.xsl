<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:output method="xml"/>
	<xsl:template match="/">

		<document>
			<!-- separate the parameters into values to return to the presentation layer -->
			<searchQ>${searchQ}</searchQ>
			<spellQ>${spellQ}</spellQ>
			<decodeQ>${decodeQ}</decodeQ>
			<query>${q}</query>
			<query2>${q2}</query2>
			<searchWhere>${w}</searchWhere>
			<boolean>${bl}</boolean>
			<searchType>${st}</searchType>
			<fuzzyQuery>${fz}</fuzzyQuery>
			<searchSite>${site}</searchSite>
			<recordOwner>${ro}</recordOwner>
			<searchLocation>${lc}</searchLocation>
			<searchLocationText>${sp}</searchLocationText>
			<searchLocationID>${gid}</searchLocationID>
			<groupID>${grd}</groupID>
			<groupName>${grn}</groupName>
			<fSubject>${fsu}</fSubject>
			<dateAfter>${dateAfter}</dateAfter>
			<dateBefore>${dateBefore}</dateBefore>
			<dateYear>${dateYear}</dateYear>
			<dateYearFuzziness>${dateYearFuzziness}</dateYearFuzziness>
			<itemType>${itype}</itemType>
			<mediaType>${mt}</mediaType>
			<featureMystery>${fm}</featureMystery>
			<featureComment>${fc}</featureComment>
			<publicDisplay>${pd}</publicDisplay>
			<fullQuery>${fullQuery}</fullQuery>
			<decodeQ>${decodeQ}</decodeQ>
			<queryString>${queryString}</queryString>
			<lengthQ>${lengthQ}</lengthQ>
			<lengthSQ>${lengthSQ}</lengthSQ>
			<vitaSite>${vitaSite}</vitaSite>
			<timestamp>${timestamp}</timestamp>
			<titleTrim>${titleTrim}</titleTrim>
			<IPAddress>${IPAddress}</IPAddress>
			<UserAgent>${UserAgent}</UserAgent>
			<UserSessionID>${UserSessionID}</UserSessionID>
			<currentQuery>${searchQ}&amp;sort=${sort}</currentQuery>
			<unparsedQuery>${unparsedQuery}</unparsedQuery>
			<sort>${sort}</sort>
			<rows>${rows}</rows>
			<page>${p}</page>
			<start>${start}</start>

			<!-- Execute the cinclude query to solr-->
			<cinclude:includexml>
				<cinclude:src>
				cocoon:/mobileSearch-${start}-${rows}-${decodeQ}-${spellQ}
				</cinclude:src>
			</cinclude:includexml>
		</document>

	</xsl:template>
</xsl:stylesheet>