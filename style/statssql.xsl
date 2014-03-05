<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:java="http://xml.apache.org/xslt/java" 
xmlns:sql="http://apache.org/cocoon/SQL/2.0"
xmlns:xsp-session="http://apache.org/xsp/session/2.0">
  <xsl:output method="xml"/>
	<xsl:template match="//document">
		<doc2>
			<document>
			<xsl:copy-of select="./*"/>
			</document>
			<sql:execute-query >
				<sql:query name="InsertResults">
					INSERT INTO Search (search, query, q2, bl, w, st, fz, lc, sp, site, it, mt, fc, p, fsu, gid, grd, grn, ro, fm, pd, sort, rows, ResultCount, SessionID, UserAgent, IPAddress) Values('<xsl:value-of select="//vitaSite"/>','<xsl:value-of select="//query"/>','<xsl:value-of select="//query2"/>','<xsl:value-of select="//boolean"/>','<xsl:value-of select="//searchWhere"/>','<xsl:value-of select="//searchType"/>','<xsl:value-of select="//fuzzyQuery"/>','<xsl:value-of select="//searchLocation"/>','<xsl:value-of select="//searchLocationText"/>','<xsl:value-of select="//searchSite"/>','<xsl:value-of select="//itemType"/>','<xsl:value-of select="//mediaType"/>', '<xsl:value-of select="//featureComment"/>', '<xsl:value-of select="//page"/>', '<xsl:value-of select="//fSubject"/>', '<xsl:value-of select="//searchLocationID"/>', '<xsl:value-of select="//groupID"/>', '<xsl:value-of select="//groupName"/>', '<xsl:value-of select="//recordOwner"/>', '<xsl:value-of select="//featureMystery"/>', '<xsl:value-of select="//publicDisplay"/>', '<xsl:value-of select="//sort"/>', '<xsl:value-of select="//rows"/>', '<xsl:value-of select="//result/@numFound"/>','<xsl:value-of select="//UserSessionID"/>','<xsl:value-of select="//UserAgent"/>','<xsl:value-of select="java:org.ourontario.stats.StatsFunctions.hashIP(//IPAddress)"/>')
				</sql:query>
			</sql:execute-query>
		</doc2>
	</xsl:template>
</xsl:stylesheet>