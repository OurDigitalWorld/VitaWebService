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
			<decodeQ>${decodeQ}</decodeQ>
			<partsQ>${partsQ}</partsQ>
			<query>${q}</query>
			<query2>${q2}</query2>

			<!-- Execute the cinclude query to solr-->
			<cinclude:includexml>
				<cinclude:src>
				cocoon:/partsSearch-${decodeQ}
				</cinclude:src>
			</cinclude:includexml>
		</document>

	</xsl:template>
</xsl:stylesheet>