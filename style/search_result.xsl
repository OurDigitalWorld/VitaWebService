<?xml version="1.0" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="xsl java msxsl"
	version="1.0">

<xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8"/>
 <xsl:variable name="start"><xsl:value-of select="number(//document/start)" /></xsl:variable>
 <xsl:variable name="resultCount"><xsl:value-of select="//result/@numFound"/></xsl:variable>
 <xsl:variable name="defaultRows">40</xsl:variable>
 <xsl:variable name="styleConstant">84</xsl:variable>
 <xsl:variable name="tag1">75</xsl:variable>
 <xsl:variable name="tag2">85</xsl:variable>
 <xsl:variable name="tag3">95</xsl:variable>
 <xsl:variable name="tag4">105</xsl:variable>
 <xsl:variable name="tag5">120</xsl:variable>
 <xsl:variable name="tag6">135</xsl:variable>
 <xsl:variable name="tag7">150</xsl:variable>
 
 <xsl:variable name="graphicsServerURL">http://graphics.ourontario.ca/</xsl:variable>

<xsl:variable name="icon_audio">icon_audio.jpg</xsl:variable>
<xsl:variable name="icon_collection">icon_collection.jpg</xsl:variable>
<xsl:variable name="icon_image">icon_image.jpg</xsl:variable>
<xsl:variable name="icon_object">icon_object.jpg</xsl:variable>
<xsl:variable name="icon_text">icon_text.jpg</xsl:variable>
<xsl:variable name="icon_video">icon_video.jpg</xsl:variable>
<xsl:variable name="icon_website">icon_website.jpg</xsl:variable>
<xsl:variable name="icon_comment">icon_comment.gif</xsl:variable>
<xsl:variable name="icon_mystery">icon_mystery.gif</xsl:variable>
<xsl:variable name="sort_hits">sort_hits.gif</xsl:variable>
<xsl:variable name="sort_year">sort_year.gif</xsl:variable>
<xsl:variable name="sort_AZ">sort_AZ.gif</xsl:variable>
<xsl:variable name="HS_hide">HS_hide.gif</xsl:variable>
<xsl:variable name="HS_see">HS_see.gif</xsl:variable>

 <xsl:variable name="dateSortAsc">
   <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="//unparsedQuery"/>
        <xsl:with-param name="from"><xsl:value-of select="//sort"/></xsl:with-param>
        <xsl:with-param name="to">dateSort+asc</xsl:with-param>
    </xsl:call-template>
 </xsl:variable>
 <xsl:variable name="dateSortDesc">
   <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="//unparsedQuery"/>
        <xsl:with-param name="from"><xsl:value-of select="//sort"/></xsl:with-param>
        <xsl:with-param name="to">dateSort+desc</xsl:with-param>
    </xsl:call-template>	
 </xsl:variable>
 <xsl:variable name="sortScore">
   <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="//unparsedQuery"/>
        <xsl:with-param name="from"><xsl:value-of select="//sort"/></xsl:with-param>
        <xsl:with-param name="to">score+desc</xsl:with-param>
    </xsl:call-template>	
 </xsl:variable>

 <!--Main Template-->
 <xsl:template match="/">
	<xsl:choose>
	<xsl:when test="$resultCount &gt; 0">
		<xsl:call-template name="searchLogic" />
		<xsl:call-template name="paging"/>
		<table>
			<tr>
				<td class="resultpanel" width="100%">
					<table>
						<xsl:for-each select="//document/response/result/doc">
							<tr>
								<xsl:call-template name="document"/>
							</tr>
						</xsl:for-each>
					</table>
				</td>
				<td class="facetpanel">
					<xsl:call-template name="facetPanel"/>
				</td>
			</tr>
		</table>
		<xsl:call-template name="paging"/>
		<xsl:call-template name="geoid"/>
		<xsl:call-template name="resultCount"/>
		
	</xsl:when>
	<xsl:otherwise>
		<div class="noResults">No Results were found.<br/>
			<xsl:call-template name="searchLogic" />
			<!-- try to relax the constraints (OR) -->
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:text>results.asp?</xsl:text><xsl:call-template name="buildQuery"><xsl:with-param name="name">bl</xsl:with-param><xsl:with-param name="value">or</xsl:with-param></xsl:call-template>
				</xsl:attribute>
				Try this search again with relaxed constraints! 
			</xsl:element>	<br/>
			<!-- try a fuzzier query -->
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:text>results.asp?</xsl:text><xsl:call-template name="buildQuery"><xsl:with-param name="name">fz</xsl:with-param><xsl:with-param name="value">
						<xsl:choose>
							<xsl:when test="string-length(//fuzzyQuery) &gt; 0">
								<xsl:value-of select="number(//fuzzyQuery) + 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>1</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param></xsl:call-template>
				</xsl:attribute>
				Try this search again but fuzzier!
			</xsl:element> <br/>
			<form action="results.asp" method="get" class="SearchForm" name="Search">
				New Search:
				<input type="text" name="q" size="50"/>
				<input type="submit" value="Go" class="SearchGo" />
			</form>
		</div>
	</xsl:otherwise>
	</xsl:choose>
 </xsl:template>

 <!-- process each record -->
 <xsl:template name="document">
	<td class="cellTop">
			<div class="thumbnail">
				<xsl:call-template name="url"/>
			</div>
	</td>
	<td class="cellTop">
		<xsl:call-template name="title"/>
		<xsl:call-template name="description"/>
		<xsl:call-template name="docParts"/>
		<xsl:call-template name="accessionNo"/>
	</td>
 </xsl:template>
	
 <xsl:template name="url">
	<xsl:element name="a">
		<xsl:attribute name="href">
			<xsl:text>update1a.asp?id=</xsl:text>
			<xsl:value-of select="./str[@name='localid']" />
			<xsl:text>&amp;number=</xsl:text>
			<xsl:value-of select="$start + position()" />
		</xsl:attribute>
		<xsl:element name="img">
			<xsl:attribute name="src">
				<xsl:value-of select="./str[@name='thumbnail']"/>
			</xsl:attribute>
			<xsl:attribute name="class">ThumbnailImg</xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="./arr[@name='title']"/>&#160;<xsl:value-of
					select="./str[@name='description']"/></xsl:attribute>
		</xsl:element>
	</xsl:element>
 </xsl:template>
 <xsl:template name="title">
	<div class="resulttitle">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="concat('update1a.asp?id=', ./str[@name='localid'])"/>
			<xsl:text>&amp;number=</xsl:text>
			<xsl:value-of select="$start + position()" />
			</xsl:attribute>
			<xsl:value-of select="./arr[@name='title']"/>
		</xsl:element>
	</div>
 </xsl:template>
	<xsl:template name="docParts">
		<xsl:variable name="numPosition"><xsl:value-of select="$start + position()" /></xsl:variable>
		<xsl:variable name="url"><xsl:value-of select="./str[@name='url']" /></xsl:variable>
		<xsl:variable name="vitaSearchSetParts">
			<xsl:choose>
				<xsl:when test="./arr[@name='type']/str='website'">true</xsl:when>
				<xsl:when test="./arr[@name='type']/str='Website'">true</xsl:when>
				<xsl:when test="./arr[@name='type']/str='web site/page'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="./parts/response/result/@numFound &gt; 0">
			<div class="docParts">
				<div class="docPartsLabel">Pages/Parts:</div>
				<xsl:for-each select="./parts/response/result/doc">
					<xsl:variable name="localPartID"><xsl:value-of select="./str[@name='id']"/></xsl:variable>
					<xsl:variable name="localHighlight"><xsl:value-of select="concat(substring-before(//parts/response/lst[@name='highlighting']/lst[@name=$localPartID]/arr/str,'&lt;em&gt;'),substring-after(//parts/response/lst[@name='highlighting']/lst[@name=$localPartID]/arr/str,'&lt;em&gt;'))"/></xsl:variable>
					<div class="docPart">
						<xsl:element name="a">
							<xsl:attribute name="href">
                                <xsl:choose>
							         <xsl:when test="$vitaSearchSetParts='false'">EditImageFile1.asp?ifid=<xsl:value-of select="substring-after(./str[@name='id'],concat(./str[@name='docid'],'.'))"/>&amp;ID=<xsl:value-of select="substring-after(./str[@name='docid'],'OOI.')"/></xsl:when>
                                     <xsl:otherwise><xsl:value-of select="./str[@name='partURL']"/></xsl:otherwise>
						          </xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="title">
								... <xsl:value-of select="concat(substring-before($localHighlight,'&lt;/em&gt;'),substring-after($localHighlight,'&lt;/em&gt;'))"/> ...
							</xsl:attribute>
							<xsl:value-of select="./str[@name='label']"/>
						</xsl:element>
					</div>
				</xsl:for-each>
			</div>
		</xsl:if><xsl:if test="./parts/response/result/@numFound &gt; 10">
		<div class="docPartAll">
			<xsl:element name="a">
				<xsl:attribute name="href">
				<xsl:choose>
					<xsl:when test="$vitaSearchSetParts='false'">EditImageFile1.asp?ifid=<xsl:value-of select="substring-after(./parts/response/result/doc/str[@name='id'],concat(./parts/response/result/doc//str[@name='docid'],'.'))"/>&amp;q=<xsl:value-of select="java:java.net.URLEncoder.encode(string(//partsQ))"/>&amp;docid=<xsl:value-of select="./parts/response/result/doc//str[@name='docid']"/>&amp;number=<xsl:value-of select="$numPosition"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$url"/>results.asp?q=<xsl:value-of select="java:java.net.URLEncoder.encode(string(//partsQ))"/>&amp;docid=<xsl:value-of select="./parts/response/result/doc//str[@name='docid']"/></xsl:otherwise>
				</xsl:choose>
				</xsl:attribute>
			<xsl:attribute name="title">
				More pages/parts
			</xsl:attribute>
			[See the entire <xsl:value-of select="./parts/response/result/@numFound"/> pages/parts]
		</xsl:element>
		</div>
	</xsl:if>
	</xsl:template>
 
  <xsl:template name="accessionNo">
	<xsl:if test="string-length(./str[@name='accessionNo']) &gt; 0">
		<div class="accessionNo">
			<xsl:for-each select="./str[@name='accessionNo']">
				<b>Local Identifier</b>:
				<xsl:value-of select="."/><br/>
			</xsl:for-each>
		</div>
	</xsl:if>
	<xsl:if test="./bool[@name='publicDisplay'] = 'false'">
		<div class="publicDisplay">
			<b>Non-Public</b>
		</div>
	</xsl:if>
 </xsl:template>
 
 <xsl:template name="description">
	<div class="description">
	<xsl:call-template name="icons"/>
	<xsl:value-of select="./arr[@name='bibliographicCitation']"/>
	<xsl:text>  </xsl:text>
	<xsl:variable name="id" select="./str[@name='id']"/>
    <xsl:choose>
    	<xsl:when test="string-length(//lst[@name=$id]/arr[@name='title']/str)  &lt; 1 and string-length(//lst[@name=$id]/arr[@name='description']/str) &gt; 0">
			...<xsl:value-of select="//lst[@name=$id]/arr[@name='description']/str" disable-output-escaping="yes"/>...
		</xsl:when>
    	<xsl:when test="string-length(//lst[@name=$id]/arr[@name='title']/str)  &lt; 1 and string-length(//lst[@name=$id]/arr[@name='fulltext']/str) &gt; 0">
			...<xsl:value-of select="//lst[@name=$id]/arr[@name='fulltext']/str" disable-output-escaping="yes"/>...
		</xsl:when>
        <xsl:otherwise> 
            <xsl:variable name="myfulldescription">
                <xsl:if test="string-length(./arr[@name='description']) &gt;= 0">
                	<xsl:for-each select="./arr[@name='description']/str">
                    	<xsl:value-of select="."/><xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
			<xsl:variable name="mydescription">
				<xsl:variable name="maxlen">300</xsl:variable>
				<xsl:choose>
						<xsl:when test="string-length($myfulldescription) &lt;= $maxlen">
	                	<xsl:for-each select="./arr[@name='description']/str">
	                    	<xsl:value-of select="."/><xsl:text> </xsl:text>
	                    </xsl:for-each>
					</xsl:when>
					<xsl:when test="not(contains(./arr[@name='description'],' '))">
								<xsl:value-of select="substring($myfulldescription,0,$maxlen)"/>
						<xsl:text>...</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="substring-before-last">
						<xsl:with-param name="input" select="substring(
									$myfulldescription,0,$maxlen)"/>
						<xsl:with-param name="substr" select="' '"/>
						</xsl:call-template>
						<xsl:text>...</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
        	<!--attempt, perhaps flawed, to remove escaped unicode hard spaces showing up in results-->
        	<xsl:variable name="myModifiedDescription">
	        	<xsl:call-template name="replace-string">
	        		<xsl:with-param name="text" select="$mydescription"/>
	        		<xsl:with-param name="from">&amp;#160;</xsl:with-param>
	        		<xsl:with-param name="to">&#160;</xsl:with-param>
	        	</xsl:call-template>
        	</xsl:variable>
        	<xsl:value-of select="$myModifiedDescription"/>
    	</xsl:otherwise>
    </xsl:choose>
	<xsl:if test="string-length(./arr[@name='mystery']) &gt; 0" >
		<div class="mystery">
			<xsl:value-of select="./arr[@name='mystery']"/>
		</div>
	</xsl:if>
	</div>
 </xsl:template>
 <xsl:template match="count"> </xsl:template>
 <xsl:template match="query"> </xsl:template>

<xsl:template name="icons">
	<!-- Set of icons to reflect media type, and the presence of comments or mystery questions in the record-->
	<xsl:for-each select= "./arr[@name='type']/str">
	<xsl:choose>
		<xsl:when test=".='audio'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_audio"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>audio</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:when test=".='collection'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_collection"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>collection</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:when test=".='video'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_video"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>video</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:when test=".='Website' or .='website'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_website"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>web site/page</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:when test=".='PhysicalObject' or .='object'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_object"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>Object</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:when test=".='text'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_text"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>text</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_image"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>image</xsl:text></xsl:attribute>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:for-each>
	<!-- On to the mysteries and comments-->
	<xsl:if test="./bool[@name='featureComment'] = 'true'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_comment"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>comment</xsl:text></xsl:attribute>
			</xsl:element>
	</xsl:if>
	<xsl:if test="./bool[@name='featureMystery'] = 'true'">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_mystery"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:text>mystery</xsl:text></xsl:attribute>
			</xsl:element>
	</xsl:if>
 </xsl:template>

<!--  Facet Panel ******************* -->
<xsl:template name="facetPanel">
	<h4>Search within these results:</h4>
	<form action="results.asp" method="get" class="SearchForm" name="Search">
		<div class="FacetPanelSearchBox">
			<input type="text" name="q" size="30"/>
			<input type="hidden" name="w" value="c" />
			<input type="submit" value="Go" class="SearchGo" />
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">q2</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//query"/><xsl:text> </xsl:text><xsl:value-of select="//query2"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">bl</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//boolean"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">st</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//searchType"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">fz</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//fuzzyQuery"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">site</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//searchSite"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">lc</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//searchLocation"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">gid</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//searchLocationID"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">sp</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//searchLocationText"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">itype</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//itemType"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">mt</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//mediaType"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">fc</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//featureComment"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">grd</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//groupID"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="name">grn</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="//GroupName"/></xsl:attribute>
			</xsl:element>
            <xsl:if test="string-length(//facetCreativeCommons) &lt; 1">
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="name">cc</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="translate(//rightsCreativeCommons, '; ', ',')"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="((string-length(//document/facetCreativeCommons) &gt; 0) and (//document/facetCreativeCommons != 'null'))" >
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="name">fcc</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="//document/facetCreativeCommons"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="((string-length(//document/publicDisplay) &gt; 0) and (//document/publicDisplay != 'null'))" >
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="name">pd</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="//document/publicDisplay"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="((string-length(//document/sort) &gt; 0) and (//document/sort != 'null'))" >
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="name">sort</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="//document/sort"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</div>
	</form>
	<xsl:call-template name="Sort"/>
	<xsl:call-template name="mediaType"/>
	<xsl:call-template name="Site"/>
	<xsl:call-template name="Location"/>
	<xsl:call-template name="Subjects"/>
	<xsl:call-template name="ItemType"/>
	<xsl:call-template name="Feature"/>
	<xsl:call-template name="GroupName"/>
	<xsl:call-template name="CreativeCommons"/>
</xsl:template>

<xsl:variable name="headerTitle">
		<xsl:if test="string-length(//query) &gt; 0" >
			<xsl:value-of select="//query" /> / 
		</xsl:if>
	<xsl:choose> 
		<xsl:when test="string-length(//document/mediaType) &gt; 0" >
		<xsl:value-of select="concat(translate(substring(//document/mediaType,1,1),'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(//document/mediaType, 2))" /> / 
		</xsl:when>
	</xsl:choose> 
	<xsl:choose>
		<xsl:when test="string-length(//fSubject) &gt; 0" >
		<xsl:value-of select="//fSubject" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchSite) &gt; 0) and (//searchSite != 'null')" >
		<xsl:value-of select="//searchSite" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchLocation) &gt; 0) and (//searchLocation != 'null')" >
		<xsl:value-of select="//searchLocation" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchLocationText) &gt; 0) and (//searchLocationText != 'null')" >
		;<xsl:value-of select="//searchLocationText" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="(string-length(//document/itemType) &gt; 0) and (//document/itemType != 'null')" >
		 <xsl:value-of select="//document/itemType" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="(string-length(//document/groupName) &gt; 0) and (//document/groupName != 'null')" >
		 <xsl:value-of select="//document/groupName" /> / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//document/featureComment) &gt; 0" >
		Comments / 
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//document/featureMystery) &gt; 0" >
		Mysteries /
		</xsl:when>
	</xsl:choose>
	
	<xsl:choose> 
		<xsl:when test="((string-length(//document/publicDisplay) &gt; 0) and (//document/publicDisplay != 'null'))" >
		<b>Public Display:</b> <xsl:value-of select="//document/publicDisplay" /><br />
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="((string-length(//document/sort) &gt; 0) and (//document/sort != 'null'))" >
			<b>Sort:</b>
			<xsl:choose> 
				<xsl:when test="(//document/sort = 'score desc') or (//document/sort = 'score+desc')">
					Relevance
				</xsl:when> 
				<xsl:when test="//document/sort = 'titleSort asc' or //document/sort = 'titleSort+asc'">
					Title (0-9, A-Z)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateOldest asc' or //document/sort = 'dateOldest+asc'">
					Oldest date (to newest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateNewest desc' or //document/sort = 'dateNewest+asc'">
					Newest date (to oldest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateSort asc' or (//document/sort = 'dateSort+asc')">
					Oldest date (to newest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateSort desc' or (//document/sort = 'dateSort+desc')">
					Newest date (to oldest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'created desc' or //document/sort = 'created+asc'">
					Date added (newest first)
				</xsl:when> 
				<xsl:when test="//document/sort = 'modified desc' or //document/sort = 'modified+asc'">
					Date modified (newest first)
				</xsl:when> 
				<xsl:when test="//document/sort = 'madePublic desc' or //document/sort = 'madePublic+asc'">
					Date made public (newest first)
				</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
 </xsl:variable>

<xsl:template name="searchLogic">
	<div class="searchLogic">
	<xsl:if test="//altTermFromCollation">
		Your search for <b><xsl:value-of select="//query" /></b> returned no results. We substituted <b><xsl:value-of select="//altTermFromCollation" /></b>.<br/>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="$resultCount = 1">
			We found <b class="count">1</b> matching item.<br />
		</xsl:when>
		<xsl:otherwise>
			We found <b class="count"><xsl:value-of select="//result/@numFound"/></b>  matching items.<br />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//query) &gt; 0" >
			<xsl:choose> 
				<xsl:when test="//searchType='kw'" >
				<b>Keywords:</b>&#160;
					<xsl:choose>
					<xsl:when test="//altTermFromCollation">
						<xsl:value-of select="//altTermFromCollation" /> &#160;
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//query" /> &#160;
					</xsl:otherwise>
					</xsl:choose>
                 &#160;
				</xsl:when>
				<xsl:when test="//searchType='ti'" >
				<b>Title:</b>&#160;
				<xsl:variable name="query" select="//query"/>
				<xsl:choose>
					<xsl:when test="contains($query, '*:*')">
						Browsing All.
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//query" /> &#160;
					</xsl:otherwise>
				</xsl:choose>
				</xsl:when>
				<xsl:when test="//searchType='su'" >
				<b>Subjects:</b>&#160; <xsl:value-of select="//query" /> &#160;
				</xsl:when>
				<xsl:when test="//searchType='au'" >
				<b>Creators:</b>&#160; <xsl:value-of select="//query" /> &#160;
				</xsl:when>
				<xsl:when test="//searchType='creator'" >
				<b>Author:</b>&#160; <xsl:value-of select="//query" /> &#160;
				</xsl:when>
				<xsl:when test="//searchType='source'" >
				<b>Ministry/Agency:</b>&#160; <xsl:value-of select="//query" /> &#160;
				</xsl:when>
				<xsl:when test="//searchType='year'" >
				<b>Year:</b>&#160; <xsl:value-of select="//query" /> &#160;
				</xsl:when>
				<xsl:otherwise>
				<b>Keywords:</b>&#160; 
					<xsl:choose>
					<xsl:when test="//altTermFromCollation"><xsl:value-of select="//altTermFromCollation" /> &#160; 
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//query" /> &#160;
					</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//query2) &gt; 0" >
			<xsl:value-of select="//query2" /> &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="//fuzzyQuery='1'" >
		<b>Fuzziness:</b>&#160;Fuzzy &#160;
		</xsl:when>
		<xsl:when test="//fuzzyQuery='2'" >
		<b>Fuzziness:</b>&#160;Fuzzier &#160;
		</xsl:when>
		<xsl:when test="//fuzzyQuery='3'" >
		<b>Fuzziness:</b>&#160; Fuzziest &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//document/mediaType) &gt; 0" >
		<b>Media type(s):</b>&#160;
				<xsl:for-each select= "//document/mediaType">
				<xsl:choose>
					<xsl:when test=".='audio'">
						<xsl:text>Audio</xsl:text>
					</xsl:when>
					<xsl:when test=".='text'">
						<xsl:text>Text</xsl:text>
					</xsl:when>
					<xsl:when test=".='video'">
						<xsl:text>Video</xsl:text>
					</xsl:when>
					<xsl:when test=".='website' or .='Website'">
						<xsl:text>Web site/page</xsl:text>
					</xsl:when>
					<xsl:when test=".='collection'">
						<xsl:text>Collection</xsl:text>
					</xsl:when>
					<xsl:when test=".='PhysicalObject' or .='object'">
						<xsl:text>Object</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Image</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:for-each>
				&#160;
		</xsl:when>
	</xsl:choose> 
	<xsl:choose>
		<xsl:when test="string-length(//fSubject) &gt; 0" >
		<b>Subject(s):</b>&#160; <xsl:value-of select="//fSubject" />&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="string-length(//creator) &gt; 0" >
		<b>Author(s):</b>&#160; <xsl:value-of select="//creator" />&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="string-length(//source) &gt; 0" >
		<b>Ministry/Agency(s):</b>&#160; <xsl:value-of select="//source" />&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="string-length(//year) &gt; 0" >
		<b>Years(s):</b>&#160; <xsl:value-of select="//year" />&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchSite) &gt; 0) and (//searchSite != 'null')" >
		<b>Contributor(s):</b>&#160;<xsl:value-of select="//searchSite" /> &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchLocation) &gt; 0) and (//searchLocation != 'null')" >
		<b>Location(s):</b>&#160;<xsl:value-of select="//searchLocation" /> &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="(string-length(//searchLocationText) &gt; 0) and (//searchLocationText != 'null')" >
		<b>Location(s):</b>&#160;<xsl:value-of select="//searchLocationText" /> &#160;
		</xsl:when>
	</xsl:choose>
	<!-- if searchLocationID is chosen then every record should have the same fSpatial: Note revisit if it is possible to select multiples  -->
	<xsl:choose>
		<xsl:when test="(string-length(//searchLocationID) &gt; 0) and (//searchLocationID != 'null')" >
			<b>Location(s):</b>&#160; XXXXX<xsl:value-of select="//searchLocationID"/>YYYYY &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="(string-length(//document/itemType) &gt; 0) and (//document/itemType != 'null')" >
		<b>Item type(s):</b>&#160; <xsl:value-of select="//document/itemType" /> &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="(string-length(//document/groupName) &gt; 0) and (//document/groupName != 'null')" >
		<b>Group:</b>&#160; <xsl:value-of select="//document/groupName" /> &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//document/featureComment) &gt; 0" >
		<b>Comments:</b>&#160; true &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="string-length(//document/featureMystery) &gt; 0" >
		<b>Mysteries:</b>&#160; true &#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="string-length(//document/facetCreativeCommons) &gt; 0" >
			<b>Rights:</b>&#160;
			<xsl:call-template name="processRights">
				<xsl:with-param name="list"><xsl:value-of select="//document/facetCreativeCommons"/></xsl:with-param>
				<xsl:with-param name="delimiter">; </xsl:with-param>
			</xsl:call-template>
		</xsl:when> 
		<xsl:when test="string-length(//document/rightsCreativeCommons) &gt; 0" >
			<b>Rights:</b>&#160;
			<xsl:call-template name="processRights">
				<xsl:with-param name="list"><xsl:value-of select="//document/rightsCreativeCommons"/></xsl:with-param>
				<xsl:with-param name="delimiter">; </xsl:with-param>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="((string-length(//document/publicDisplay) &gt; 0) and (//document/publicDisplay != 'null'))" >
		<b>Public Display:</b> <xsl:value-of select="//document/publicDisplay" /><br />
		</xsl:when>
	</xsl:choose>
	<xsl:choose> 
		<xsl:when test="((string-length(//document/sort) &gt; 0) and (//document/sort != 'null'))" >
			<b>Sort:</b>
			<xsl:choose> 
				<xsl:when test="(//document/sort = 'score desc') or (//document/sort = 'score+desc')">
					Relevance
				</xsl:when> 
				<xsl:when test="//document/sort = 'titleSort asc' or (//document/sort = 'titleSort+asc')">
					Title (0-9, A-Z)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateOldest asc' or (//document/sort = 'dateOldest+asc')">
					Oldest date (to newest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateNewest desc' or (//document/sort = 'dateNewest+desc')">
					Newest date (to oldest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateSort asc' or (//document/sort = 'dateSort+asc')">
					Oldest date (to newest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'dateSort desc' or (//document/sort = 'dateSort+desc')">
					Newest date (to oldest)
				</xsl:when> 
				<xsl:when test="//document/sort = 'created desc' or (//document/sort = 'created+desc')">
					Date added (newest first)
				</xsl:when> 
				<xsl:when test="//document/sort = 'modified desc' or (//document/sort = 'modified+desc')">
					Date modified (newest first)
				</xsl:when> 
				<xsl:when test="//document/sort = 'madePublic desc' or (//document/sort = 'madePublic+desc')">
					Date made public (newest first)
				</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
	</div>
	<xsl:call-template name="spellCheck" />
 </xsl:template>

<xsl:template name="spellCheck">
	<xsl:if test="//response/lst[@name='spellcheck']/lst[@name='suggestions']/str[@name='collation']">
		<xsl:variable name="collation" select="//response/lst[@name='spellcheck']/lst[@name='suggestions']/str[@name='collation']"/>
		<xsl:variable name="spellcheckq" select="//response/lst[@name='responseHeader']/lst[@name='params']/str[@name='spellcheck.q']"/>

		<xsl:if test="((java:toUpperCase(string($collation)) != java:toUpperCase(string($spellcheckq))) and (concat(java:toUpperCase(string($collation)),'S') != java:toUpperCase(string($spellcheckq))) and (concat(java:toUpperCase(string($spellcheckq)),'S') != java:toUpperCase(string($collation))))">
			<!----><div class="spellCheck">
			Did you mean:
			<!--[<xsl:value-of select="$collation" />][<xsl:value-of select="$spellcheckq" />][<xsl:value-of select="concat($collation,'s')" />][<xsl:value-of select="concat($spellcheckq,'s')" />]-->
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:text>results.asp?</xsl:text><xsl:call-template name="buildQuery"><xsl:with-param name="name">q</xsl:with-param><xsl:with-param name="value"><xsl:value-of select="//response/lst[@name='spellcheck']/lst[@name='suggestions']/str[@name='collation']" /></xsl:with-param></xsl:call-template>
				</xsl:attribute>
				<xsl:value-of select="//response/lst[@name='spellcheck']/lst[@name='suggestions']/str[@name='collation']" />
			</xsl:element>
			<xsl:text>?</xsl:text>
			</div>
		</xsl:if><!---->
	</xsl:if>
</xsl:template>

<xsl:template name="paging">
	<!-- page variables and constants-->
	<xsl:variable name="r" select="//rows"/>
	<xsl:variable name="p" select="//page"/>
	<xsl:variable name="t" select="//result/@numFound"/>
	<xsl:variable name="tp" select="ceiling($t div $r)" />
	
	<div class="pagination">
	<!-- current page -->
	
	<span>Page <xsl:value-of select="$p" /> of <xsl:value-of select="$tp" /> </span>

	<!-- prev page  -->
	<xsl:choose>
		<xsl:when test="($p - 1) &gt; 0" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p - 1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				&#8592; Prev
			</xsl:element>
		</xsl:when>
	</xsl:choose>

	<!-- page 1 if not in current display -->
	<xsl:choose>
		<xsl:when test="($p - 3) &gt; 0" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="1" /></xsl:element>
		</xsl:when>
	</xsl:choose>
	
	<!-- page 2 if not in current display -->
	<xsl:choose>
		<xsl:when test="($p - 3) &gt; 1" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="2" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="2" /></xsl:element>
		</xsl:when>
	</xsl:choose>
		
	<!-- skip a few if page 3 not in current display -->
	<xsl:choose>
		<xsl:when test="($p - 3) &gt; 2" >
			...
		</xsl:when>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="($p - 2) &gt; 0" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p - 2" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$p - 2" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="($p - 1) &gt; 0" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p - 1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$p - 1" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>
	<!-- current page 
			suppress when only one-->
	
	<xsl:choose>
		<xsl:when test="ceiling($t div $r) != 1" >
			&#160;<big><xsl:value-of select="$p"/></big>&#160;
		</xsl:when>
	</xsl:choose>

	<!-- next page  -->
	<xsl:choose>
		<xsl:when test="($p) &lt; $tp" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p + 1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$p + 1" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>
	<!-- page after next  -->
	<xsl:choose>
		<xsl:when test="($p + 1) &lt; $tp" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p + 2" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$p + 2" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>

	<!-- skip a few if not two pages or less from the end  -->
	<xsl:choose>
		<xsl:when test="($p + 2) &lt; ($tp - 2)" >
			...
		</xsl:when>
	</xsl:choose>

	<!-- penultimate page if more than 2 from the end-->
	<xsl:choose>
		<xsl:when test="($p + 2) &lt; ($tp - 1)" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$tp - 1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$tp - 1" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>
	<!-- last page if more than 3 from the end-->
	<xsl:choose>
		<xsl:when test="($p + 3) &lt; ($tp + 1)" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$tp" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$tp" />
			</xsl:element>
		</xsl:when>
	</xsl:choose>

	<!-- next page-->
	<xsl:choose>
		<xsl:when test="($p + 1) &lt; $tp + 1" >
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:value-of select="//unparsedQuery"/>&amp;p=<xsl:value-of select="$p + 1" /><xsl:if test="$r != $defaultRows">&amp;rows=<xsl:value-of select="$r" /></xsl:if>
				</xsl:attribute>
				Next &#8594;</xsl:element>
		</xsl:when>
	</xsl:choose>
	</div>
</xsl:template>
 
 
 <xsl:template name="substring-before-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>
		<xsl:if test="$substr and contains($input, $substr)">
				<xsl:variable name="temp" select="substring-after($input, $substr)"/>
				<xsl:value-of select="substring-before($input, $substr)"/>
				<xsl:if test="contains($temp, $substr)">
						<xsl:value-of select="$substr"/>
						<xsl:call-template name="substring-before-last">
								<xsl:with-param name="input" select="$temp"/>
								<xsl:with-param name="substr" select="$substr"/>
						</xsl:call-template>
				</xsl:if>
		</xsl:if>
 </xsl:template>


<xsl:template name="Sort">
	<h4>Sort</h4>
	<div class="sortOptions">
		<b>Ordered by</b>:&#160; 
			<xsl:choose>
				<xsl:when test="//sort = 'score desc'">Relevance</xsl:when>
				<xsl:when test="//sort = 'dateSort desc'">Start with newest</xsl:when>
				<xsl:when test="//sort = 'dateSort asc'">Start with oldest</xsl:when>
			</xsl:choose>
		
		<ul>
			<xsl:if test="//sort!='dateSort asc'">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>results.asp?</xsl:text><xsl:value-of select="$dateSortAsc"/>
					</xsl:attribute>
					Start with oldest
				</xsl:element>
			</li>
			</xsl:if>
			<xsl:if test="//sort!='dateSort desc'">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>results.asp?</xsl:text><xsl:value-of select="$dateSortDesc"/>
					</xsl:attribute>
					Start with newest
				</xsl:element>
			</li>
			</xsl:if>
			<xsl:if test="//sort!='score desc'">
			<li>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:text>results.asp?</xsl:text><xsl:value-of select="$sortScore"/>
					</xsl:attribute>
					By relevance
				</xsl:element>
			</li>
			</xsl:if>
		</ul>
	</div> 
</xsl:template> 

<xsl:template name="mediaType">
	<h4>Media Types</h4>
	<ul class="options">
		<li class="option-type-audio">
			<xsl:call-template name="mediaTypeLookup">
				<xsl:with-param name="mt">audio</xsl:with-param>
				<xsl:with-param name="mtLabel">Audio</xsl:with-param>
			</xsl:call-template>
		</li>
		 <li class="option-type-collection">
			 <xsl:call-template name="mediaTypeLookup">
				 <xsl:with-param name="mt">collection</xsl:with-param>
				 <xsl:with-param name="mtLabel">Collection</xsl:with-param>
			 </xsl:call-template>
		</li>
		<li class="option-type-images">
			<xsl:call-template name="mediaTypeLookup">
				<xsl:with-param name="mt">image</xsl:with-param>
				<xsl:with-param name="mtLabel">Image</xsl:with-param>
			</xsl:call-template>
		</li>
		 <li class="option-type-object">
			 <xsl:call-template name="mediaTypeLookup">
				 <xsl:with-param name="mt">object</xsl:with-param>
				 <xsl:with-param name="mtLabel">Object</xsl:with-param>
			 </xsl:call-template>
		</li>
		<li class="option-type-text">
			<xsl:call-template name="mediaTypeLookup">
				<xsl:with-param name="mt">text</xsl:with-param>
				<xsl:with-param name="mtLabel">Text</xsl:with-param>
			</xsl:call-template>
		</li>
		<li class="option-type-video">
			<xsl:call-template name="mediaTypeLookup">
				<xsl:with-param name="mt">video</xsl:with-param>
				<xsl:with-param name="mtLabel">Video</xsl:with-param>
			</xsl:call-template>
		
		</li>
		<li class="option-type-website">
			<xsl:call-template name="mediaTypeLookup">
				<xsl:with-param name="mt">website</xsl:with-param>
				<xsl:with-param name="mtLabel">Web site/page</xsl:with-param>
			</xsl:call-template>
			
		</li>
	</ul>
 </xsl:template>
 
<xsl:template name="mediaTypeLookup">
	<xsl:param name="mt" />
	<xsl:param name="mtLabel" />
	<xsl:choose>
		<xsl:when test="//lst[@name='type']/int[@name=$mt]">
			<xsl:element name="a">
				<xsl:attribute name="href"><xsl:text>results.asp?mt=</xsl:text><xsl:value-of select="$mt" /><xsl:call-template name="buildQuery"/>
				</xsl:attribute>
				<xsl:value-of select="$mtLabel" />
				(<xsl:value-of select="//lst[@name='type']/int[@name=$mt]"/>)
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$mtLabel" /> (0)
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

 <xsl:template name="Site">
	<xsl:for-each select="//lst[@name='site']">
		<xsl:choose>
			<xsl:when test="node()">
				<h4>Contributors</h4>
				<div class="facetpanelcontent">
					<!-- start at first of branch -->
					<xsl:for-each select="./int">
						<xsl:sort select="@name"/>
						<xsl:if test="normalize-space(./@name)">
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:text>results.asp?site=</xsl:text><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /><xsl:call-template name="buildQuery"/>
								</xsl:attribute>
								<xsl:value-of select="./@name"/>
								(<xsl:value-of select="."/>)
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</div> 
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
 </xsl:template>

 <xsl:template name="GroupName">
	<xsl:for-each select="//lst[@name='fGroupName']">
		<xsl:choose>
			<xsl:when test="node()">
				<h4>Groups</h4>
				<div class="facetpanelcontent">
					<!-- start at first of branch -->
					<xsl:for-each select="./int">
						<xsl:sort select="@name"/>
						<xsl:if test="normalize-space(./@name)">
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:text>results.asp?grn=</xsl:text><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /><xsl:call-template name="buildQuery"/>
								</xsl:attribute>
								<xsl:value-of select="./@name"/>
								(<xsl:value-of select="."/>)
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</div> 
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
 </xsl:template>

<xsl:template name="CreativeCommons">
 	<xsl:for-each select="//lst[@name='rightsCreativeCommons']">
 		<xsl:choose>
 			<xsl:when test="node()">
 				<h4>Rights: Creative Commons</h4>
 				<div class="FacetPanelContent">
 					<!-- start at first of branch -->
 					<xsl:for-each select="./int">
 						<xsl:sort select="@name"/>
 						<xsl:if test="normalize-space(./@name)">
 							<xsl:element name="a">
 								<xsl:attribute name="href"><xsl:text>results.asp?</xsl:text><xsl:call-template name="buildQuery"><xsl:with-param name="name">fcc</xsl:with-param><xsl:with-param name="value"><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /></xsl:with-param></xsl:call-template>
 								</xsl:attribute>
 								<xsl:choose>
 									<xsl:when test="./@name = 'pd'">Public Domain<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by'">Attribution<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by-nd'">Attribution-NoDerivatives<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by-nc-nd'">Attribution-NonCommercial-NoDerivatives<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by-nc'">Attribution-NonCommercial<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by-nc-sa'">Attribution-NonCommercial-ShareAlike<xsl:text>&#160;</xsl:text></xsl:when>
 									<xsl:when test="./@name = 'by-sa'">Attribution-ShareAlike<xsl:text>&#160;</xsl:text></xsl:when>
 								</xsl:choose>
 								(<xsl:value-of select="."/>)
 							</xsl:element>
 						</xsl:if>
 					</xsl:for-each>
 				</div> 
 			</xsl:when>
 			<xsl:otherwise>
 			</xsl:otherwise>
 		</xsl:choose>
 	</xsl:for-each>

</xsl:template>

<xsl:template name="Location">
	MAPREPLACESTRING
</xsl:template>

 <xsl:template name="ItemType">
	<xsl:for-each select="//lst[@name='itemType']">
		<xsl:choose>
			<xsl:when test="node()">
					<h4>Item Types</h4>
					<div class="tagcloud">
						<!-- start at first of branch -->
						<xsl:for-each select="./int">
							<xsl:sort select="@name"/>
							<xsl:if test="normalize-space(./@name)">
								<xsl:element name="a">
									<xsl:attribute name="href"><xsl:text>results.asp?itype=</xsl:text><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /><xsl:call-template name="buildQuery"/>
									</xsl:attribute>
										<xsl:attribute name="style"><xsl:text>font-size:</xsl:text> 
											<xsl:choose>
												<xsl:when test=". &lt; 5">
													<xsl:value-of select="$tag1"/>
												</xsl:when>
												<xsl:when test=". &gt; 4 and . &lt; 10">
													<xsl:value-of select="$tag2"/>
												</xsl:when>
												<xsl:when test=". &gt; 9 and . &lt; 20">
													<xsl:value-of select="$tag3"/>
												</xsl:when>
												<xsl:when test=". &gt; 19 and . &lt; 40">
													<xsl:value-of select="$tag4"/>
												</xsl:when>
												<xsl:when test=". &gt; 39 and . &lt; 100">
													<xsl:value-of select="$tag5"/>
												</xsl:when>
												<xsl:when test=". &gt; 99 and . &lt; 500">
													<xsl:value-of select="$tag5"/>
												</xsl:when>
												<xsl:when test=". &gt; 499">
													<xsl:value-of select="$tag6"/>
												</xsl:when>
											</xsl:choose><xsl:text>%</xsl:text>
										</xsl:attribute>
									<xsl:value-of select="./@name"/><xsl:text>&#160;(</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text>
								</xsl:element>
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</div>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
 </xsl:template>

  <xsl:template name="Feature">
	<h4>Features</h4>
	<ul class="options">
	<xsl:for-each select="//lst">
		<xsl:if test="count(self::node()[@name='featureComment']/*) &gt; 0">
			<xsl:for-each select="./int">
				<xsl:if test="./@name = 'true'">
					<xsl:element name="li">
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>results?fc=true</xsl:text><xsl:call-template name="buildQuery"/>
						</xsl:attribute>
						<xsl:element name="img"><xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_comment"/></xsl:attribute><xsl:attribute name="alt"><xsl:text>comment</xsl:text></xsl:attribute></xsl:element>&#160;<xsl:text>Comments</xsl:text>&#160;(<xsl:value-of select="."/>)
					</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="count(self::node()[@name='featureMystery']/*) &gt; 0">
			<xsl:for-each select="./int">
				<xsl:if test="./@name = 'true'">
					<xsl:element name="li">
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>results?fm=true</xsl:text><xsl:call-template name="buildQuery"/>
						</xsl:attribute><xsl:element name="img"><xsl:attribute name="src"><xsl:value-of select="$graphicsServerURL"/><xsl:value-of select="$icon_mystery"/></xsl:attribute><xsl:attribute name="alt"><xsl:text>mystery</xsl:text></xsl:attribute></xsl:element>&#160;<xsl:text>Mysteries</xsl:text>&#160;(<xsl:value-of select="."/>)
					</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
			<xsl:if test="count(self::node()[@name='publicDisplay']/*) &gt; 0">
				<xsl:for-each select="./int">
					<xsl:if test="./@name = 'true'">
						<li>
						<xsl:element name="a">
							<xsl:attribute name="href"><xsl:text>results.asp?pd=true</xsl:text><xsl:call-template name="buildQuery"/>
							</xsl:attribute>
							<xsl:text>Public</xsl:text>
							(<xsl:value-of select="."/>)
						</xsl:element>
						</li>
					</xsl:if>
					<xsl:if test="./@name = 'false'">
						<li>
						<xsl:element name="a">
							<xsl:attribute name="href"><xsl:text>results.asp?pd=false</xsl:text><xsl:call-template name="buildQuery"/>
							</xsl:attribute>
							<xsl:text>Non Public</xsl:text>
							(<xsl:value-of select="."/>)
						</xsl:element>
						</li>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</ul>
 </xsl:template>

<xsl:template name="Subjects">
	<xsl:for-each select="//lst[@name='fSubject']">
		<xsl:choose>
			<xsl:when test="count(descendant::*) &gt; 50">
				<xsl:call-template name="SubjectComplex" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SubjectSimple" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template name="SubjectSimple">
	<h4>Subjects </h4>
	<div class="tagcloud" id="subjects">
		<xsl:for-each select="./int">
			<xsl:sort select="@name"/>
			<xsl:if test="normalize-space(./@name)">
				<xsl:element name="a">
					<xsl:attribute name="href"><xsl:text>results.asp?fsu=</xsl:text><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /><xsl:call-template name="buildQuery"/>
					</xsl:attribute>
					<xsl:attribute name="style"><xsl:text>font-size:</xsl:text> 
						<xsl:choose>
							<xsl:when test=". &lt; 5">
								<xsl:value-of select="$tag1"/>
							</xsl:when>
							<xsl:when test=". &gt; 4 and . &lt; 10">
								<xsl:value-of select="$tag2"/>
							</xsl:when>
							<xsl:when test=". &gt; 9 and . &lt; 20">
								<xsl:value-of select="$tag3"/>
							</xsl:when>
							<xsl:when test=". &gt; 19 and . &lt; 40">
								<xsl:value-of select="$tag4"/>
							</xsl:when>
							<xsl:when test=". &gt; 39 and . &lt; 100">
								<xsl:value-of select="$tag5"/>
							</xsl:when>
							<xsl:when test=". &gt; 99 and . &lt; 500">
								<xsl:value-of select="$tag5"/>
							</xsl:when>
							<xsl:when test=". &gt; 499">
								<xsl:value-of select="$tag6"/>
							</xsl:when>
						</xsl:choose><xsl:text>%</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="./@name"/><xsl:text>&#160;(</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text>
					</xsl:element>
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="SubjectComplex">
	<h4>Subjects </h4>
	<div class="tagcloud" id="subjects">
		<div id="subject-controls">
			<ul id="subject-controls-tabs">
				<li>
					<a href="javascript:changecss('.subthreshold', 'display', 'inline')">Show all</a>
				</li>
				<li id="active">
					<a href="javascript:changecss('.subthreshold', 'display', 'none')">Show common</a>
				</li>
			</ul>
		</div>
		<!-- start at first of branch -->
		<xsl:for-each select="./int">
			<xsl:sort select="@name"/>
			<xsl:if test="normalize-space(./@name)">
				<xsl:element name="a">
					<xsl:attribute name="href"><xsl:text>results.asp?fsu=</xsl:text><xsl:value-of select="java:java.net.URLEncoder.encode(string(./@name))" /><xsl:call-template name="buildQuery"/>
					</xsl:attribute>
					<xsl:attribute name="style"><xsl:text>font-size:</xsl:text> 
						<xsl:choose>
							<xsl:when test=". &lt; 5">
								<xsl:value-of select="$tag1"/>
							</xsl:when>
							<xsl:when test=". &gt; 4 and . &lt; 10">
								<xsl:value-of select="$tag2"/>
							</xsl:when>
							<xsl:when test=". &gt; 9 and . &lt; 20">
								<xsl:value-of select="$tag3"/>
							</xsl:when>
							<xsl:when test=". &gt; 19 and . &lt; 40">
								<xsl:value-of select="$tag4"/>
							</xsl:when>
							<xsl:when test=". &gt; 39 and . &lt; 100">
								<xsl:value-of select="$tag5"/>
							</xsl:when>
							<xsl:when test=". &gt; 99 and . &lt; 500">
								<xsl:value-of select="$tag5"/>
							</xsl:when>
							<xsl:when test=". &gt; 499">
								<xsl:value-of select="$tag6"/>
							</xsl:when>
						</xsl:choose><xsl:text>%</xsl:text>
					</xsl:attribute>
					<xsl:if test=". &lt; 8">
						<xsl:attribute name="class">subthreshold</xsl:attribute>
					</xsl:if>
					<!--translate(.,'&#201C;&#201D;','&quot;&quot;')-->
					<xsl:value-of select="./@name"/><xsl:text>&#160;(</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text>
				</xsl:element>
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="processRights">
	<!-- for handling the searchLogic presentation of Creative Commons Rights values--> 
	<xsl:param name="list" />
	<xsl:param name="delimiter" />
	<xsl:variable name="newlist">
		<xsl:choose>
			<xsl:when test="contains($list, $delimiter)"><xsl:value-of select="normalize-space($list)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(normalize-space($list), $delimiter)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="first" select="substring-before($newlist, $delimiter)" />
	<xsl:variable name="remaining" select="substring-after($newlist, $delimiter)" />
	<xsl:choose>
		<xsl:when test="$first = 'pd'">Public Domain<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by'">Attribution<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by-nd'">Attribution-NoDerivatives<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by-nc-nd'">Attribution-NonCommercial-NoDerivatives<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by-nc'">Attribution-NonCommercial<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by-nc-sa'">Attribution-NonCommercial-ShareAlike<xsl:text>&#160;</xsl:text></xsl:when>
		<xsl:when test="$first = 'by-sa'">Attribution-ShareAlike<xsl:text>&#160;</xsl:text></xsl:when>
	</xsl:choose>
	<xsl:if test="$remaining">
		<xsl:text>|&#160;</xsl:text>
		<xsl:call-template name="processRights">
			<xsl:with-param name="list" select="$remaining" />
			<xsl:with-param name="delimiter"><xsl:value-of select="$delimiter"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
	
<xsl:template name="geoid">
	<div id="geoidCode">
		<xsl:for-each select="//lst/lst/lst[@name='geoid']/int">
			<xsl:value-of select="./@name"/>
			=
			<xsl:value-of select="."/>;
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="resultCount">
	<div id="resultCount"><xsl:value-of select="//result/@numFound"/></div>
</xsl:template>

<xsl:template name="buildQuery">
	<xsl:param name="name" />
	<xsl:param name="value" />
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">q</xsl:with-param>
		<xsl:with-param name="value" ><xsl:value-of select="//query"/></xsl:with-param>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">q2</xsl:with-param>
		<xsl:with-param name="value" ><xsl:value-of select="//query2"/></xsl:with-param>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">bl</xsl:with-param>
		<xsl:with-param name="value" select="//boolean"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">st</xsl:with-param>
		<xsl:with-param name="value" select="//searchType"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">fz</xsl:with-param>
		<xsl:with-param name="value" select="//fuzzyQuery"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">site</xsl:with-param>
		<xsl:with-param name="value" select="//searchSite"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">lc</xsl:with-param>
		<xsl:with-param name="value" select="//searchLocation"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">sp</xsl:with-param>
		<xsl:with-param name="value" select="//searchLocationText"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">itype</xsl:with-param>
		<xsl:with-param name="value" select="//itemType"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">mt</xsl:with-param>
		<xsl:with-param name="value" select="//mediaType"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">fc</xsl:with-param>
		<xsl:with-param name="value" select="//featureComment"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">source</xsl:with-param>
		<xsl:with-param name="value" select="//source"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">creator</xsl:with-param>
		<xsl:with-param name="value" select="//creator"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">year</xsl:with-param>
		<xsl:with-param name="value" select="//year"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">grn</xsl:with-param>
		<xsl:with-param name="value" select="//groupName"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
	<xsl:if test="string-length(//facetCreativeCommons) &lt; 1">
		<xsl:call-template name="checkParameter">
			<xsl:with-param name="name">cc</xsl:with-param>
			<xsl:with-param name="value" select="//rightsCreativeCommons"/>
			<xsl:with-param name="checkName" select="$name"/>
			<xsl:with-param name="checkValue" select="$value"/>
		</xsl:call-template>		
	</xsl:if>
	<xsl:call-template name="checkParameter">
		<xsl:with-param name="name">fcc</xsl:with-param>
		<xsl:with-param name="value" select="//facetCreativeCommons"/>
		<xsl:with-param name="checkName" select="$name"/>
		<xsl:with-param name="checkValue" select="$value"/>
	</xsl:call-template>
</xsl:template>


<xsl:template name="checkParameter">
	<xsl:param name="name" />
	<xsl:param name="value" />
	<xsl:param name="checkName" />
	<xsl:param name="checkValue" />
	<xsl:choose>
		<xsl:when test="$checkName = $name">
			<xsl:text>&amp;</xsl:text><xsl:value-of select="$name"/><xsl:text>=</xsl:text><xsl:value-of select="$checkValue"/>
		</xsl:when>
		<xsl:when test="string-length($value) &gt; 0">
			<xsl:text>&amp;</xsl:text><xsl:value-of select="$name"/><xsl:text>=</xsl:text><xsl:value-of select="$value"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
<xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    
    <xsl:choose>
        <xsl:when test="contains($text, $from)">
            <xsl:variable name="before" select="substring-before($text, $from)"/>
            <xsl:variable name="after" select="substring-after($text, $from)"/>
            <xsl:variable name="prefix" select="concat($before, $to)"/>
            <xsl:value-of select="$before"/>
            <xsl:value-of select="$to"/>
            <xsl:value-of select="$after"/>
        </xsl:when> 
        <xsl:otherwise>
            <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>

