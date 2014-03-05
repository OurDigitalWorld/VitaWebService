<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:cinclude="http://apache.org/cocoon/include/1.0">

<xsl:output method="xml"/>
<xsl:param name="solr"/>

<xsl:template match="/">

	<document>
		<!-- Execute the cinclude query to solr-->
		<cinclude:includexml>
		    <cinclude:src>${solr}q=${searchQ}&amp;rows=0
			</cinclude:src>
		</cinclude:includexml>
	</document>

</xsl:template>
</xsl:stylesheet>
