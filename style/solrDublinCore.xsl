<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">

	<xsl:output method="xml"/>
	<xsl:template match="/">

		<document>
			<!-- separate the parameters into values to return to the presentation layer -->
			<decodeQ>${decodeQ}</decodeQ>
			<rows>${rows}</rows>
			<start>${start}</start>

			<!-- Execute the cinclude query to solr-->
			<cinclude:includexml>
				<cinclude:src>
				cocoon:/publicDublinCore-${start}-${rows}-${decodeQ}
				</cinclude:src>
			</cinclude:includexml>
		</document>

	</xsl:template>
</xsl:stylesheet>