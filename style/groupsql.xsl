<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml"/>
	<xsl:template match="//document">
		<doc2>
			<document>
			<xsl:copy-of select="./*"/>
			</document>
			<xsl:if test='string-length(//groupID) &gt; 0'>
				<groupTitle>
					<sql:execute-query >
						<sql:query name="GroupTitle">
							SELECT GroupTitle FROM Groups WHERE GroupID = '<xsl:value-of select="//groupID"/>'
						</sql:query>
					</sql:execute-query>
				</groupTitle>
			</xsl:if><!---->
			<xsl:if test='string-length(//searchLocationID) &gt; 0'>
				<searchLocation>
					<sql:execute-query >
						<sql:query name="searchLocationID">
							SELECT Name FROM Geography WHERE GeoID = '<xsl:value-of select="//searchLocationID"/>'
						</sql:query>
					</sql:execute-query>
				</searchLocation>
			</xsl:if><!---->
		</doc2>
	</xsl:template>
</xsl:stylesheet>