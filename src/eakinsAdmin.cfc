<cfcomponent output="false">
 
 <cfheader name="Access-Control-Allow-Origin" value="*">
 
 <cffunction name="init" access="remote" returntype="any">
 		 <cfreturn this />
</cffunction>

<cffunction name="addNewCustomer" access="remote" returntype="any" returnformat="JSON" >
	<cfargument name="customerObject" type="any" >
	<cfset customerObject = DeserializeJSON(customerObject)>
	<cfquery name="newCustomer" datasource="eakinsMySQL">
		insert into tbl_customers
		(snipcart_id,
		 email,
		  orderCount,
		   lastDate, 
		   Name, 
		   Address_1, 
		   address_2, 
		   City, 
		   Country, 
		   State, 
		   zip,
		   notes)
		values
		(
		'#customerObject.snipcart_ID#',
		'#customerObject.email#',
		0,
		CURRENT_DATE(),
		'#customerObject.name#',
		'#customerObject.address_1#',
		'#customerObject.address_2#',
		'#customerObject.city#',
		'#customerObject.country#',
		'#customerObject.state#',
		'#customerObject.zip#',
		'#customerObject.notes#'
		)
		</cfquery>	
	<cfreturn 1>
</cffunction>


<cffunction name="saveNewOrder" access="remote" returntype="any" returnformat="JSON" >
	<cfargument name="orderArray"  type="any">
	<cfargument name="snipcart_ID" type="any" >
	<cfargument name="trans_ID" type="any" >
	<cfargument name="totalPrice" type="any" >
	
	<cfscript>
		orderArray = deserializeJSON(ToString(orderArray));
	</cfscript>
	<cfset numberOfItemsInOrder = arrayLen(orderArray)>
	<cfloop from="1" to="#arrayLen(orderArray)#" index="i">
		<cfif i EQ 1>
			<!--- Update customer record --->
			<cfquery datasource="eakinsMySql">
				update tbl_customers
				set orderCount = orderCount + 1, lastDate =  CURRENT_DATE()
				where snipcart_id = '#snipcart_ID#'
			</cfquery>
			<!--- write master trans record	 --->
			<cfquery datasource="eakinsMySQL">
		
				insert into tbl_orders
					(Trans_ID,
					items__items__id,
					itemName,
					snipcart_ID,
					items__completionDate,
					items__numberOfItemsInOrder,
					items__finalGrandTotal,
					Price,
					masterTrans,
					item_Quantity,
					items__invoiceNumber
				
					)
					values(
					'#trans_ID#',
					'#orderArray[i].ITEMS__ITEMS__ID#',
					'#orderArray[i].NAME#',
					'#snipcart_ID#',
					CURRENT_DATE(),
					#numberOfItemsInOrder#,
					#totalPrice#,
					'#orderArray[i].PRICE#',
					1,
					1,
					'POS Sale'
					
					
		  )		
			</cfquery>
		<cfelse>
			<cfquery datasource="eakinsMySQL">
		
				insert into tbl_orders
					(Trans_ID,
					items__items__id,
					itemName,
					snipcart_ID,
					items__completionDate,
					items__numberOfItemsInOrder,
					items__finalGrandTotal,
					Price,
					masterTrans,
					item_Quantity,
					items__invoiceNumber
					
					)
					values(
					'#trans_ID#',
					'#orderArray[i].ITEMS__ITEMS__ID#',
					'#orderArray[i].NAME#',
					'#snipcart_ID#',
					CURRENT_DATE(),
					#numberOfItemsInOrder#,
					#totalPrice#,
					'#orderArray[i].PRICE#',
					0,
					1,
					'POS Sale'
					
		  )		
			</cfquery>	
		</cfif>
	</cfloop>
	<cfreturn 1>	
</cffunction>

<cffunction name="updateCustomerAdmin" access="remote" returntype="any" returnformat="JSON" >
	<cfargument name="customerObject" type="any" >
	<cfset customerObject = DeserializeJSON(customerObject)>
		<cfquery datasource="eakinsMySQL">
		update tbl_customers
		set email = '#customerObject.EMAIL#',
		Name = '#customerObject.NAME#',
		Address_1 = '#customerObject.ADDRESS_1#',
		address_2 = '#customerObject.ADDRESS_2#',
		City = '#customerObject.CITY#',
		zip = '#customerObject.ZIP#',
		Country = '#customerObject.COUNTRY#',
		comments = '#customerObject.COMMENTS#'
		where snipcart_id = '#customerObject.SNIPCART_ID#'		
		</cfquery>
		<cfreturn 1>
</cffunction>


<cffunction name="getProductHistory" access="remote" returntype="any" returnformat="JSON" >
	<cfargument name="product_ID" type="any">
	<cfquery name="history" datasource="eakinsMySQL" >
		select o.itemName,o.items__items__totalPrice,tc.Name,tc.snipcart_id,o.items__items__id,DATE_FORMAT(o.items__completionDate,'%Y-%m-%d') as date,o.Trans_ID
		from tbl_orders o
		inner join tbl_customers tc on o.snipcart_ID = tc.snipcart_id
		where items__items__id = '#product_ID#'
		order by date desc
	</cfquery> 
	<cfset arrGirls = QueryToStruct(history)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper>  
</cffunction>

<cffunction name="getProducts" access="remote" returntype="any" returnformat="JSON" >
	<cfquery name="products" datasource="eakinsMySQL" >
	select items__items__id,count(*) as count,p.name,format(p.price,2) as price from tbl_orders o
		inner join tbl_products p on o.items__items__id = p.userDefinedId
		group by items__items__id,p.name
		order by p.name
	</cfquery> 
	<cfset arrGirls = QueryToStruct(products)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper>  
</cffunction>

<cffunction name="getOrderDetails" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="Trans_ID" type="any" required="true">
	<cfquery  name="details" datasource="eakinsMySQL" >
		select tbl_customers.Name,tbl_customers.snipcart_id,t.itemName,DATE_FORMAT(t.items__completionDate,'%Y-%m-%d') as date,t.item_Quantity,
      	 t.items__numberOfItemsInOrder,t.Trans_ID,format(t.items__items__totalPrice,2) as amount,format(t.items__finalGrandTotal,2) as totalAmount,
		   t.items__invoiceNumber as invoiceNumber,t.price
		from tbl_customers
		inner join tbl_orders t on tbl_customers.snipcart_id = t.snipcart_ID
		where t.Trans_ID = '#Trans_ID#'
		order by date desc
	</cfquery> 
	    <cfset arrGirls = QueryToStruct(details)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper>     
</cffunction>

<cffunction name="getOrdersForCustomer" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="snipcart_ID" type="any" required="true">
	<cfquery  name="orders" datasource="eakinsMySQL" >
		select tbl_customers.Name,t.itemName,DATE_FORMAT(t.items__completionDate,'%Y-%m-%d') as date, t.items__numberOfItemsInOrder as numberOfItems,t.Trans_ID,format(t.items__finalGrandTotal	,2) as amount, 
		tbl_customers.Address_1,tbl_customers.address_2,tbl_customers.City,tbl_customers.State,tbl_customers.Country,tbl_customers.email,tbl_customers.zip,tbl_customers.comments
		from tbl_customers
		inner join tbl_orders t on tbl_customers.snipcart_id = t.snipcart_ID
		where t.snipcart_ID = '#snipcart_ID#' and masterTrans = 1
		order by date desc
	</cfquery> 
	    <cfset arrGirls = QueryToStruct(orders)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper>     
</cffunction>

<cffunction name="getBasicCustomerData" Access="remote" returntype="any" returnformat="JSON">
	<cfargument name="snipcart_ID" type="any" >
	<cfquery name="customers" datasource="eakinsMySQL">
	select email,Name,
	       Address_1,address_2,City,State,zip,Country
		from tbl_customers
		where snipcart_ID = '#snipcart_ID#'
		</cfquery>
		<cfset arrGirls = QueryToStruct(customers)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper>	
</cffunction>


<cffunction name="getGeneralCustomers" Access="remote" returntype="any" returnformat="JSON">
	<cfquery name="customers" datasource="eakinsMySQL">
	select lastDate as Transdate,snipcart_ID,format(ordersAmount,2) as ordersAmount,orderCount,email,Name,DATE_FORMAT(lastDate,'%Y-%m-%d') as lastDate,
	       Address_1,address_2,City,State,zip,Country

		from tbl_customers
		order by Transdate desc
		</cfquery>
		<cfset arrGirls = QueryToStruct(customers)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper>	
</cffunction>


<cffunction name="getDIPurchaseDetails" access="remote" returntype="any" returnformat="JSON">>
	<cfargument name=id type="numeric" required="true">
	<cfquery name="transaction" datasource="eakinsMySQL">
		select id, numberOfIssues,numberOfIssuesSent,DATE_FORMAT(referenceSaleDate,'%b %D, %Y') as transDate,shippingAddressName, customerEmail, 
		shippingAddressAddress1, shippingAddressAddress2, shippingAddressCity, shippingAddressState, shippingAddressPostalCode, shippingAddressCountry,
		shippingAddressCompanyName,numberOfIssuesSent,numberOfIssues,shippingAddressName 
		from tbl_subscriptionsale
		where id = #id#
	</cfquery>
<cfset arrGirls = QueryToStruct(transaction)>
<cfset objectWrapper = structNew()>
<cfset objectWrapper.results = #arrGirls#>
<cfreturn objectWrapper>	
</cffunction>


<cffunction name="getDIPurchases" access="remote" returntype="any" returnformat="JSON">
	<cfquery name="transactions" datasource="eakinsMySQL">
		select id, numberOfIssues,numberOfIssuesSent,DATE_FORMAT(referenceSaleDate,'%b %D, %Y') as transDate, referenceSaleDate, shippingAddressName, customerEmail,shippingAddressCompanyName,
		shippingAddressAddress1, shippingAddressAddress2, shippingAddressCity, shippingAddressState, shippingAddressPostalCode, shippingAddressCountry
		from tbl_subscriptionsale
		order by referenceSaleDate DESC
	</cfquery>
<cfset arrGirls = QueryToStruct(transactions)>
<cfset objectWrapper = structNew()>
<cfset objectWrapper.results = #arrGirls#>
<cfreturn objectWrapper>
</cffunction>


<cffunction name="getHeroImages" access="remote" returntype="Any" returnformat="JSON">
	<cfquery name="getHeroes" datasource="eakinsMySQL" >
		SELECT heroimages.id, 
	heroimages.photoID, 
	heroimages.position, 
	books.title
	FROM books INNER JOIN newphotoassets ON books.id = newphotoassets.bookID
		 INNER JOIN heroimages ON newphotoassets.id = heroimages.photoID
	ORDER BY heroimages.position ASC
	</cfquery>
	<cfset arrGirls = QueryToStruct(getHeroes)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper>
</cffunction>

<cffunction name="deleteFromHeroes" access="remote" returntype="Any" returnformat="JSON">
	<cfargument name="photoID" type="any" >
		<cfquery name="delete" datasource="eakinsMySQL" >
			delete from heroimages
			where id = #photoID#
		</cfquery>
		<cfreturn 1>
</cffunction>

<cffunction name="insertHeroImage" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="heroObject" type="any" required="true" >
	<cfset heroObject = DeserializeJSON(heroObject)>
		<cfquery name="hero"  datasource="eakinsMySQL" >
			insert into heroimages(
				photoID,
				position
			)values(
				#heroObject.id#,
				#heroObject.position#
			)
		</cfquery>
		<cfreturn 1>
</cffunction>	


<cffunction name="getAvailableHomePageFeatures" access="remote" returntype="Any" returnformat="JSON">
	<cfquery name="features" datasource="eakinsMySQL" >
select books.title,fileName,np.id  from newphotoassets np
left join books on np.bookID = books.id
where assetPhotoType = 3 AND np.id NOT IN (select photoID from heroimages)
	</cfquery>
	<cfset arrGirls = QueryToStruct(features)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper>
</cffunction>	


<cffunction name="insertNewIssue" access="remote" returntype="any" returnformat="JSON">>
	<cfargument name="newIssue" required="true" type="any">
	<cfset newIssue = DeserializeJSON(newIssue)>
	<cfif newIssue.FORSALE EQ 'True' OR newIssue.FORSALE EQ 1>
		<cfset newIssue.FORSALE = 1>
	<cfelse>
		<cfset newIssue.FORSALE = 0>
	</cfif> 
	<cfif newIssue.FEATUREDISSUE EQ 'True' OR newIssue.FEATUREDISSUE EQ 1>
		<cfset newIssue.FEATUREDISSUE = 1>
	<cfelse>
		<cfset newIssue.FEATUREDISSUE = 0>
	</cfif> 
	<cfif newIssue.DISPLAY EQ 'True' OR newIssue.DISPLAY EQ 1>
		<cfset newIssue.DISPLAY = 1>
	<cfelse>
		<cfset newIssue.DISPLAY = 0>
	</cfif> 
		<cfquery name="newIssueResult" datasource="eakinsMySql">
			insert into tbl_danceindexissues
			(
			issueTitle,
			YEAR,
			NUMBER,
			VOLUME,
			forSale,
			price,
			authorString,
			coverImage,
			featuredIssue,
			featuredIssueImage,
			featuredIssueImage2,
			pdfForSale,
			issueTechDescription,
			display,
			shortDescription,
			longDescription
			)
    VALUES (
        	'#newIssue.issueTitle#',
			  '#newIssue.YEAR#',
			   '#newIssue.NUMBER#',
			  '#newIssue.VOLUME#',
			  '#newIssue.FORSALE#',
			  '#newIssue.PRICE#',
			  '#newIssue.AUTHORSTRING#',
			  '#newIssue.COVERIMAGE#',
			  #newIssue.FEATUREDISSUE#,
			  '#newIssue.FEATUREDISSUEIMAGE#',
			  '#newIssue.FEATUREDISSUEIMAGE2#',
			  '#newIssue.PDFFORSALE#',
			  '#newIssue.ISSUETECHDESCRIPTION#',
			  #newIssue.DISPLAY#,
			  '#newIssue.SHORTDESCRIPTION#',
			  '#newIssue.LONGDESCRIPTION#'
			  )
		</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="createArticle" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="article" required="true" type="any">
	<cfset article = DeserializeJSON(article)>
	<cfquery name="inserted" datasource="eakinsMySql">
		insert into tbl_danceindexarticles(
		ARTICLE,
		  AUTHOR,
		  EDITOR,
		  issueID
		)VALUES (
		'#article.ARTICLE#',
		  '#article.AUTHOR#',
		'#article.EDITOR#',
			#article.ISSUEID#
)
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="updateArticle" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="article" required="true" type="any">
	<cfset article = DeserializeJSON(article)>
		<cfquery name="updated" datasource="eakinsMySql">
			UPDATE tbl_danceindexarticles
			set ARTICLE = '#article.ARTICLE#',
			  AUTHOR = '#article.AUTHOR#',
			  EDITOR ='#article.EDITOR#'
			  where id = #article.ID#
		</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="getArticleDetails" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="id" required="true" type="numeric">
	<cfquery name="articleDetails" datasource="eakinsMySql">
		select * FROM tbl_danceindexarticles
		where id = #id#
	</cfquery>
	 <cfset arrGirls = QueryToStruct(articleDetails)>
	 <cfset objectWrapper = structNew()>
	 <cfset objectWrapper.results = #arrGirls#>
	 <cfreturn objectWrapper> 
</cffunction>


<cffunction name="updateIssue" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="newIssue" required="true" type="any">
	<cfset newIssue = DeserializeJSON(newIssue)>
	<cfif newIssue.FORSALE EQ 'True' OR newIssue.FORSALE EQ 1>
		<cfset newIssue.FORSALE = 1>
	<cfelse>
		<cfset newIssue.FORSALE = 0>
	</cfif> 
	<cfif newIssue.FEATUREDISSUE EQ 'True' OR newIssue.FEATUREDISSUE EQ 1>
		<cfset newIssue.FEATUREDISSUE = 1>
	<cfelse>
		<cfset newIssue.FEATUREDISSUE = 0>
	</cfif> 
	<cfif newIssue.DISPLAY EQ 'True' OR newIssue.DISPLAY EQ 1>
		<cfset newIssue.DISPLAY = 1>
	<cfelse>
		<cfset newIssue.DISPLAY = 0>
	</cfif> 
		<cfquery name="issue" datasource="eakinsMySql">
			UPDATE tbl_danceindexissues
			set issueTitle = '#newIssue.ISSUETITLE#',
			  YEAR ='#newIssue.YEAR#',
			  VOLUME='#newIssue.VOLUME#',
			  NUMBER ='#newIssue.NUMBER#',
			  Price = '#newIssue.PRICE#',
			  coverImage = '#newIssue.COVERIMAGE#',
			  forSale = '#newIssue.FORSALE#',
			  archiveID = '#newIssue.ARCHIVEID#',
			  authorString = '#newIssue.AUTHORSTRING#',
			  featuredIssue = #newIssue.FEATUREDISSUE#,
			  featuredIssueImage = '#newIssue.FEATUREDISSUEIMAGE#',
			  featuredIssueImage2 = '#newIssue.FEATUREDISSUEIMAGE2#',
			pdfForSale = '#newIssue.PDFFORSALE#',
			issueTechDescription = '#newIssue.ISSUETECHDESCRIPTION#',
			display=#newIssue.DISPLAY#,
			grams=#newIssue.GRAMS#,
			shortDescription = '#newIssue.SHORTDESCRIPTION#',
			 longDescription = '#newIssue.LONGDESCRIPTION#'	
			where id = #newIssue.ID#
		</cfquery>
	<CFRETURN 1>
</cffunction>

<cffunction name="getArticlesForIssue" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="issueID" required="true" type="numeric">
        <cfquery name="articles" datasource="eakinsMySql">
            SELECT issueID,tbl_danceindexarticles.id,MONTH,YEAR,issueTitle,AUTHOR,ARTICLE,dances,EDITOR, tbl_danceindexissues.archiveID
            FROM tbl_danceindexarticles INNER JOIN tbl_danceindexissues on tbl_danceindexissues.id = issueID
            where issueID =#issueID#;
        </cfquery>
    <cfset arrGirls = QueryToStruct(articles)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>

<cffunction name="getSpecificIssue" access="remote" returntype="any" returnformat="JSON" >
    <cfargument name="issueID" required="true" type="numeric">
    <cfquery name="specIssue" datasource="eakinsMySql">
       select * from tbl_danceindexissues
        where id = #issueID#
    </cfquery>
   <cfset arrGirls = QueryToStruct(specIssue)>
   <cfset objectWrapper = structNew()>
   <cfset objectWrapper.results = #arrGirls#>
   <cfreturn objectWrapper> 
</cffunction>


<cffunction  name="getAllDanceIndexIssues" access="remote" returntype="Any" returnformat="JSON" >
    <cfquery datasource="eakinsMySql" name="danceIndexIssues">
        Select * from tbl_danceindexissues
        ORDER BY  id desc
    </cfquery>
    <cfset arrGirls = QueryToStruct(danceIndexIssues)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>


<cffunction name="insertNewRelatedItem" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="relatedItemObject" type="any" required="true" >
	<cfset relatedItemObject = DeserializeJSON(relatedItemObject)> 
	<cfif relatedItemObject.PUBLISH EQ 'true' OR relatedItemObject.PUBLISH EQ 1>
		<cfset relatedItemObject.PUBLISH = 1>
	<cfelse>
			<cfset relatedItemObject.PUBLISH = 0>
	</cfif>
	<cfquery name="newItem" datasource="eakinsMySQL" >
		insert into relatedItems
			(
			content,
			book_id,
			relatedItemClass,
			title,
			link,
			publish
			)values(
			'#relatedItemObject.CONTENT#',
			#relatedItemObject.BOOK_ID#,
			#relatedItemObject.RELATEDITEMCLASS#,
			'#relatedItemObject.TITLE#',
			'#relatedItemObject.LINK#',
			#relatedItemObject.PUBLISH#
			)
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="updateRelatedItem" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="relatedItemObject" type="any" required="true" >
	<cfset relatedItemObject = DeserializeJSON(relatedItemObject)> 
	<cfif relatedItemObject.PUBLISH EQ 'true' OR relatedItemObject.PUBLISH EQ 1>
		<cfset relatedItemObject.PUBLISH = 1>
	<cfelse>
			<cfset relatedItemObject.PUBLISH = 0>
	</cfif>
	<cfquery  name="update" datasource="eakinsMySQL" >
		update RELATEDITEMS
		set relateditems.content = '#relatedItemObject.CONTENT#', 
			relateditems.title = '#relatedItemObject.TITLE#',
			relateditems.relatedItemClass = #relatedItemObject.RELATEDITEMCLASS#,
			relateditems.link = '#relatedItemObject.LINK#' ,
			relateditems.publish = #relatedItemObject.PUBLISH#
			where  relateditems.id = #relatedItemObject.ID#
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="getRelatedDetails" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" >
		<cfquery name="relatedDetails" datasource="eakinsMySQL" >
			SELECT relateditems.id, 
			relateditems.content, 
			relateditems.book_id, 
			relateditems.relatedItemClass, 
			relateditems.title,
			relateditems.link,
			relatedItems.publish
			FROM relateditems
			where relateditems.id = #id#
		</cfquery>
	<cfset arrGirls = QueryToStruct(relatedDetails)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 	
</cffunction>

<cffunction name="getRelatedClassnames" access="remote" returntype="Any" returnformat="JSON" >
	<cfquery name="classNames" datasource="eakinsMySQL">
		select * from relateditemclasses
	</cfquery>
	<cfset arrGirls = QueryToStruct(classNames)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>

<cffunction name="getRelatedItemsForBook" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="book_ID" type="numeric" required="true" >
	<cfquery name="relatedBooks" datasource="eakinsMySQL">
SELECT relateditems.id, 
	relateditems.content, 
	relateditems.book_id, 
	relateditems.title, 
	relateditemclasses.className, 
	relateditemclasses.id as itemClass,
	relateditems.link,
	relateditems.publish
	FROM relateditems INNER JOIN relateditemclasses ON relateditems.relatedItemClass = relateditemclasses.id
	WHERE relateditems.book_id = #book_ID#
	</cfquery>
	<cfset arrGirls = QueryToStruct(relatedBooks)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>

<cffunction name="updateAsset" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="assetObject" type="any" required="true" >
	<cfset assetObject = DeserializeJSON(assetObject)> 
	<cfquery name="asset" datasource="eakinsMySQL" >
		update newphotoassets
		set fileName = '#assetObject.FILENAME#',
		position = #assetObject.POSITION#,
		assetPhotoType=#assetObject.ASSETPHOTOTYPE# 

		where id=#assetObject.ID#
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="createNewAsset" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="assetObject" type="any" required="true" >
	<cfset assetObject = DeserializeJSON(assetObject)> 
	
	<cfquery name="asset" datasource="eakinsMySQL" >
		insert into newphotoassets
		(
			filename,
			position,
			assetPhotoType,
			bookID
		) values
		(
			'#assetObject.NEWFILENAME#',
			#assetObject.POSITION#,
			#assetObject.ASSETPHOTOTYPE#,
			#assetObject.BOOKID#
		)
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="getAssetsForBook" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="book_id" type="numeric" required="true" >
		<cfquery name="assets" datasource="eakinsMySQL" >
			SELECT newphotoassets.id,
			newphotoassets.fileName,
			newphotoassets.assetPhotoType,
			newphotoassets.position,
			newphotoassets.bookID,
       		a.assetPhotoType as TypeLable
			FROM newphotoassets
inner join assetphototypes a on newphotoassets.assetPhotoType = a.id
			where newphotoassets.bookID = #book_id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(assets)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>

<cffunction name="getIndividualAsset" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" >
		<cfquery name="asset" datasource="eakinsMySQL" >
			SELECT newphotoassets.id,
			newphotoassets.fileName,
			newphotoassets.assetPhotoType,
			newphotoassets.position,
       		a.assetPhotoType as TypeLable,
			   newphotoassets.bookID
			FROM newphotoassets
inner join assetphototypes a on newphotoassets.assetPhotoType = a.id
			where newphotoassets.id = #id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(asset)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>

<cffunction name="removeAsset" access="remote" returntype="any" returnformat="JSON">
	<cfargument name="ID" type="any" required="true">
	<cfquery name="remove" datasource="eakinsMySQL">
		delete from newphotoassets
		where newphotoassets.id = #ID#
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="getAssetTypes"access="remote" returntype="Any" returnformat="JSON" >
	<cfquery name="assetTypes" datasource="eakinsMySQL">
		select id, assetPhotoType as assetLable from assetphototypes
	</cfquery>
		<cfset arrGirls = QueryToStruct(assetTypes)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>

<cffunction name="getNewID" access="remote" returntype="Any" returnformat="JSON">
	<cfquery name="lastID" datasource="eakinsMySQL">
		select LAST_INSERT_ID()
	</cfquery>
	<cfreturn lastID>
  </cffunction>  

<cffunction name="createNewBook" access="remote" returntype="Any" returnformat="JSON" > >
	<cfargument name="bookObject" required="true" type="any" >
	<cfset bookObject = DeserializeJSON(bookObject)> 
	<cfquery name="book" datasource="eakinsMySQL" >
		insert into books
		(
		 colophon,
		 credits,
		 long_description,
		  slug,
		  specs,
		   subtitle,
		   title,
		   year
		)values(	
		 '#bookObject.COLOPHON#',
		 '#bookObject.CREDITS#',
		 '#bookObject.LONG_DESCRIPTION#',
		 '#bookObject.SLUG#',
		  '#bookObject.SPECS#',
		  '#bookObject.SUBTITLE#',
		   '#bookObject.TITLE#',
		   #bookObject.YEAR#	
		)
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="createNewEdition" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="editionObject" type="any" required="true" >
	<cfset editionObject = DeserializeJSON(editionObject)> 
	<cfif editionObject.NOT_FOR_SALE EQ 'YES'>
		<cfset editionObject.NOT_FOR_SALE = 1>
	<cfelse>
		<cfset editionObject.NOT_FOR_SALE = 0>
	</cfif>
	<cfif editionObject.OUT_OF_PRINT EQ 'YES'>
		<cfset editionObject.OUT_OF_PRINT = 1>
	<cfelse>
		<cfset editionObject.OUT_OF_PRINT = 0>
	</cfif>
		<cfquery name="updateEdition" datasource="eakinsMySQL" >
			insert into editions
				(
				editions.book_id, 
					editions.isbn, 
					editions.format, 
					editions.price, 
					editions.out_of_print, 
					editions.grams, 
					editions.not_for_sale
				)VALUES(
					'#editionObject.BOOK_ID#', 
					'#editionObject.ISBN#', 
					'#editionObject.FORMAT#', 
					'#editionObject.PRICE#', 
					'#editionObject.OUT_OF_PRINT#', 
					'#editionObject.GRAMS#', 
					'#editionObject.NOT_FOR_SALE#'
				);

		</cfquery>
	<cfreturn 1>			
</cffunction>

<cffunction name="updateEdition" access="remote" returntype="Any" returnformat="JSON"  >
	<cfargument name="editionObject" type="any" required="true" >
	<cfset editionObject = DeserializeJSON(editionObject)> 
	<cfif editionObject.NOT_FOR_SALE EQ 'YES'>
		<cfset editionObject.NOT_FOR_SALE = 1>
	<cfelse>
		<cfset editionObject.NOT_FOR_SALE = 0>
	</cfif>
	<cfif editionObject.OUT_OF_PRINT EQ 'YES'>
		<cfset editionObject.OUT_OF_PRINT = 1>
	<cfelse>
		<cfset editionObject.OUT_OF_PRINT = 0>
	</cfif>
	<cfquery name="updateEdition" datasource="eakinsMySQL" >
		update editions
		set format = '#editionObject.FORMAT#',
		isbn = '#editionObject.ISBN#',
		price = '#editionObject.PRICE#',
		out_of_print = '#editionObject.OUT_OF_PRINT#',
		grams = #editionObject.GRAMS#,
		not_for_sale = '#editionObject.NOT_FOR_SALE#'
		where id = #editionObject.ID#	
	</cfquery>
	<cfreturn 1>	 
</cffunction>	


<cffunction name="getEditionDetails" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" >
		<cfquery datasource="eakinsMySQL" name="editions">
			SELECT editions.id, 
			editions.book_id, 
			editions.isbn, 
			editions.format, 
			editions.price, 
			editions.out_of_print, 
			editions.weight,
			editions.grams, 
			editions.not_for_sale
			FROM editions
			where editions.id = #id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(editions)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>


<cffunction name="getEditionsForBook" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" >
		<cfquery datasource="eakinsMySQL" name="editions">
			SELECT editions.id, 
			editions.book_id, 
			editions.isbn, 
			editions.format, 
			editions.price, 
			editions.out_of_print, 
			editions.weight,
			editions.grams, 
			editions.not_for_sale
			FROM editions
			where editions.book_id = #id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(editions)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>

<cffunction name="updateBook" access="remote" returntype="Any" returnformat="JSON"  >
	<cfargument name="bookDetails" type="any" required="true" >
	<cfset bookDetails = DeserializeJSON(bookDetails)> 
	<cfquery datasource="eakinsMySQL" name="updateBook">
		update books
		set 
			books.title = '#bookDetails.TITLE#', 
			books.credits = '#bookDetails.CREDITS#', 
			books.colophon = '#bookDetails.COLOPHON#', 
			books.year = #bookDetails.YEAR#, 
			books.specs = '#bookDetails.SPECS#', 
			books.long_description = '#bookDetails.LONG_DESCRIPTION#', 
			books.thumbnail_file_name = '#bookDetails.THUMBNAIL_FILE_NAME#', 
			books.subtitle = '#bookDetails.SUBTITLE#',
			books.slug='#bookdetails.SLUG#'
		where id = #bookDetails.ID#
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="deleteCatFromBook" access="remote" returntype="Any" returnformat="JSON"  >	
	<cfargument name="catRecordID" type="any" required="true"/>
	<cfquery datasource="eakinsMySQL" name="newCat">
		delete from categorizations
		where id = #catRecordID#
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="newCatForBook" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="book_id" type="numeric" required="true">
	<cfargument name="category_id" type="numeric" required="true">
	<cfquery datasource="eakinsMySQL" name="newCat">
		insert into categorizations
			(book_id,
			category_id)
			VALUES
			(
			#book_id#,
			#category_id#	
			)
			
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="getAvailableCategories" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" default="11">
	<cfquery datasource="eakinsMySQL" name="categories">
		SELECT categories.id,
	categories.name,
	categories.slug
	FROM categories
where categories.id not in(SELECT categorizations.category_id
			FROM books INNER JOIN categorizations ON books.id = categorizations.book_id
			 INNER JOIN categories ON categorizations.category_id = categories.id
			where books.id = #id#)
	</cfquery>
	<cfset arrGirls = QueryToStruct(categories)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>


<cffunction name="getCategoriesForBook" access="remote" returntype="Any" returnformat="JSON" >
	<cfargument name="id" type="numeric" required="true" default="11">
		<cfquery datasource="eakinsMySQL" name="categoriesForBook">
			SELECT categories.name, 
			categorizations.book_id, 
			categorizations.category_id,
			categorizations.id as catRecordID
			FROM books INNER JOIN categorizations ON books.id = categorizations.book_id
			 INNER JOIN categories ON categorizations.category_id = categories.id
			where books.id = #id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(categoriesForBook)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>



<cffunction name="getBookDetails" access="remote" returntype="Any" returnformat="JSON"> 
	<cfargument name="id" type="numeric" required="true" default="11">
		<cfquery datasource="eakinsMySQL" name="bookDetails">
			SELECT books.id, 
			books.title, 
			books.credits, 
			books.colophon, 
			books.year, 
			books.specs, 
			books.short_description, 
			books.long_description, 
			books.subtitle, 
			books.thumbnail_file_name, 
			books.thumbnail_content_type, 
			books.thumbnail_file_size,
			books.slug
		FROM books
		where books.id = #id#
		</cfquery>
		<cfset arrGirls = QueryToStruct(bookDetails)>
		<cfset objectWrapper = structNew()>
		<cfset objectWrapper.results = #arrGirls#>
		<cfreturn objectWrapper> 
</cffunction>

<cffunction name="getAllBooks" access="remote" returntype="Any" returnformat="JSON">
	<cfquery datasource="eakinsMySQL" name="allBooks">
		SELECT books.id, 
		books.title,books.year
		FROM books
		ORDER BY books.title ASC
	</cfquery>
	<cfset arrGirls = QueryToStruct(allBooks)>
	<cfset objectWrapper = structNew()>
	<cfset objectWrapper.results = #arrGirls#>
	<cfreturn objectWrapper> 
</cffunction>


<cffunction name="checkSecure" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="email" type="any" >
    <cfargument name="pword"  type="string">
    <cfquery name="queryName" datasource="eakinsMySQL">
        select * from tbl_secure
        where email = '#email#' AND pword='#pword#'
  </cfquery>
<cfset arrGirls = QueryToStruct(queryName) />
<cfset objectWrapper = structNew()>
<cfset objectWrapper.results = #arrGirls#>
<cfreturn objectWrapper> 
</cffunction>

<cffunction name="logInUser" access="remote" returntype="Any" returnformat="JSON">
	<cfargument name="user" type="any">
	<cfquery name="queryName" datasource="eakinsMySQL">
		insert into tbl_userLogs
		(user)
		values(
		'#user#')
	</cfquery>
	<cfreturn 1>
</cffunction>


 


<cffunction name="updateCustomer" access="remote" returntype="any">
	<cfargument name="detail" type="any" required="true">
		<cfquery name="details" datasource="eakinsMySQL">
		
			update tbl_subscriptionsale
			set
			shippingAddressCompanyName = '#detail.shippingAddressCompanyName#',
			shippingAddressCountry = '#detail.shippingAddressCountry#',
			shippingAddressName = '#detail.shippingAddressName#',
			shippingAddressPostalCode = '#detail.shippingAddressPostalCode#',
			shippingAddressAddress1 = '#detail.shippingAddressAddress1#',
			shippingAddressCity = '#detail.shippingAddressCity#',
			shippingAddressState = '#detail.shippingAddressState#',
			customerEmail = '#detail.customerEmail#',
			numberOfIssuesSent = #detail.numberOfIssuesSent#,
			numberOfIssues = #detail.numberOfIssues#
			where id = #detail.id#
		</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="createSubCustomer" access="remote" returntype="Any">
    <cfargument name="detail" type="any" required="true">
       <cfquery name="insert" datasource="eakinsMySql">
           insert into tbl_subscriptionsale (
        shippingAddressCompanyName ,
			shippingAddressCountry ,
			shippingAddressName,
			shippingAddressPostalCode ,
			shippingAddressAddress1 ,
	shippingAddressAddress2,
			shippingAddressCity  ,
			shippingAddressState,
			customerEmail ,
			numberOfIssuesSent,
			numberOfIssues )
		values (
				'#detail.shippingAddressCompanyName#',
			'#detail.shippingAddressCountry#',
			'#detail.shippingAddressName#',
		'#detail.shippingAddressPostalCode#',
			'#detail.shippingAddressAddress1#',
			'#detail.shippingAddressAddress2#',
		'#detail.shippingAddressCity#',
			'#detail.shippingAddressState#',
		'#detail.customerEmail#',
		#detail.numberOfIssuesSent#,
		#detail.numberOfIssues#
		)
           
       </cfquery> 
   <cfreturn 1> 
</cffunction>

<cffunction name='getSubDetails' access="remote" returntype="any">
	<cfargument name="subID" type="numeric" required="true">
		<cfquery name='subDetails' datasource="eakinsMySQL">
			select id, issueHasBeenSent, subscriptionSaleID ,DATE_FORMAT(dateIssueSent,'%b %D, %Y') as Date_Sent,issueSent from tbl_subscriptionsaledetail
			where subscriptionSaleID = #subID#
		</cfquery>
	<cfreturn subDetails>
</cffunction>

<cffunction name='getSubIssueDetails' access="remote" returntype="any">
	<cfargument name="ID" type="numeric" required="true">
		<cfquery name='subDetails' datasource="eakinsMySQL">
			select id, issueHasBeenSent, issueSent, subscriptionSaleID, DATE_FORMAT(dateIssueSent,'%b %D, %Y') as Date_Sent from tbl_subscriptionsaledetail
			where id = #ID#
		</cfquery>
	<cfreturn subDetails>
</cffunction>

<cffunction name='createNewIssueForSub' access='remote' returntype='any'>
	<cfargument name='newIssueDetails' type='any' required='true'>
		<cfquery name='newIssue' datasource='eakinsMySQL'>
			insert into tbl_subscriptionsaledetail
			( subscriptionSaleID,  
			dateIssueSent, 
			issueHasBeenSent,
			issueSent)
		values(
			#newIssueDetails.subscriptionSaleID#,
			'#newIssueDetails.Date_Sent#',
			#newIssueDetails.issueHasBeenSent#,
			'#newIssueDetails.issueSent#'			
		)
		</cfquery>
<cfreturn 1>

</cffunction>

<cffunction name="updateSentIssueDetails" access='remote' returntype='any'>
	<cfargument name="sentIssueDetails" type='any' required='true'>
		<cfquery name='update' datasource='eakinsMySQL'>
			update tbl_subscriptionsaledetail
				set issueSent = '#sentIssueDetails.issueSent#',
					dateIssueSent = '#sentIssueDetails.Date_Sent#',
					issueHasBeenSent = #sentIssueDetails.issueHasBeenSent#
				where id = #sentIssueDetails.id#
		</cfquery>
	<cfreturn 1>	
</cffunction>

<cffunction name="updateForSaleData" access="remote" returntype="Any">
    <cfargument name="issueForSale" required="true" type="any">
        <cfquery name="forSaleData" datasource="eakinsMySql">
            update tbl_DanceIndexIssues
            set shortDescription = '#issueForSale.shortDescription#',
            featuredIssue = #issueForSale.featuredIssue#,
            featuredIssueImage = '#issueForSale.featuredIssueImage#',
            longDescription = '#issueForSale.longDescription#',
            grams = '#issueForSale.grams#',
            pdfForSale = '#issueForSale.pdfForSale#'
            where id = #issueForSale.id#
        </cfquery>
    <cfreturn 1>
</cffunction>


<cffunction name="getForSaleData" access="remote" returntype="Any">
    <cfargument name="issueID" required="true" type="numeric">
        <cfquery name="forSaleData" datasource="eakinsMySql">
            select shortDescription, featuredIssue, id, featuredIssueImage,issueTitle,longDescription,grams,pdfForSale
            from tbl_DanceIndexIssues
            where id = #issueID#
        </cfquery>
    <cfreturn forSaleData>
</cffunction>






	

<cffunction name="deleteArticle" access="remote" returntype="any">
	<cfargument name="id" required="true" type="numeric">
		<cfquery name="deleted" datasource="eakinsMySql">
			delete from tbl_danceindexarticles
			where id = #id#;
		</cfquery>
	<cfreturn 1>
</cffunction>










<cffunction name="getCurrentDiscount" access="remote" returntype="Any">
    <cfquery datasource="eakinsMySql" name="discount">
        select *
        from tbldiscounts
        where id=1
    </cfquery>
    <cfreturn discount />
</cffunction>

<cffunction name="setCurrentDiscount" access=remote returntype="Any">
    <cfargument name="discount" required="true" type="any" />  
        <cfif discount.live EQ 'yes'>
            <cfset discount.live = 1 >
            <cfelse>
            <cfset discount.live = 0 >
        </cfif>  
        <cfquery datasource="eakinsMySql" name="discountResult">
            update tbldiscounts
            set tbldiscounts.discount = #discount.discount#,
            tbldiscounts.text = '#discount.text#',
            tbldiscounts.live = #discount.live#,
            tbldiscounts.textColor = '#discount.textColor#'
            where tbldiscounts.id = 1
        </cfquery>
    <cfreturn 1 />    
</cffunction>

<cffunction name="getBooksByClass" access="remote" returntype="Any" >
	<cfargument name="bookClass" required="true" type="numeric" default="2" >
		<cfquery name="books" datasource="eakinsMySQL">
			SELECT books.id, 
				books.title, 
				books.credits, 
				categories.name, 
				categorizations.category_id
			FROM books INNER JOIN categorizations ON books.id = categorizations.book_id
				 INNER JOIN categories ON categorizations.category_id = categories.id
			WHERE categorizations.category_id = 2
		</cfquery>
		<cfreturn books>
</cffunction>























<cffunction name="getEditionsDetails" returntype="Any" access="remote" >
	<cfargument name="edition_ID" type="numeric" required="true" >
	<cfquery name="editionDetails" datasource="eakinsMySQL">
		SELECT editions.id, 
			editions.book_id, 
			editions.isbn, 
			editions.format, 
			editions.price, 
			editions.out_of_print, 
			editions.weight, 
			editions.grams,
			editions.not_for_sale
			FROM editions
			where editions.id = #edition_ID#
	</cfquery>
	<cfreturn editionDetails>
</cffunction>
	








<cffunction name="saveAssetChanges" access="remote" returntype="Any" >
	<cfargument name="asset" type="any" required="true" >
		<cfquery name="assets" datasource="eakinsMySQL" >
			update assets
			set asset_file_name = '#asset.asset_file_name#', position = '#asset.position#'
			where id = '#asset.id#'
		</cfquery>	
	<cfreturn 1>
</cffunction>	



<cffunction name="deleteAsset" access="remote"  returntype="any">
	<cfargument name="id" type="numeric" required="true" >
		<cfquery name="deleteAsset" datasource="eakinsMySQL">
			delete from assets
			where id= #id#
		</cfquery>
	<cfreturn 1>	
</cffunction>








<cffunction name="deleteRelatedItem" access="remote" returntype="Any" >
	<cfargument name="id" required="true" type="any" >
	<cfquery name="delete" datasource="eakinsMySQL" >
		delete from relateditems where id = #id#
	</cfquery>
	<cfreturn 1>
</cffunction>
	


<cffunction name="getNewPhotoAssetsForBook" access="remote" returntype="Any" >
	<cfargument name="book_ID" type="numeric" required="true" >
	<cfquery name="photos" datasource="eakinsMySQL" >
		SELECT newphotoassets.id, 
			newphotoassets.fileName, 
			newphotoassets.assetPhotoType, 
			newphotoassets.bookID, 
			newphotoassets.position,
			assetphototypes.assetPhotoType AS photoTypeName
			FROM newphotoassets INNER JOIN assetphototypes ON newphotoassets.assetPhotoType = assetphototypes.id
			where newphotoassets.bookID = #book_ID#
	</cfquery>
	<cfreturn photos>
</cffunction>


<cffunction name="getNewPhotoTypes" access="remote" returntype="Any" >
	<cfquery name="types" datasource="eakinsMySQL" >
		SELECT assetphototypes.id AS `data`, 
		assetphototypes.assetPhotoType AS label
		FROM assetphototypes
	</cfquery>
	<cfreturn types>
</cffunction>

<cffunction name="saveNewPhotoTypeChanges" access="remote" returntype="Any" >
	<cfargument name="newPhoto" type="any" required="true" >
	<cfquery name="change" datasource="eakinsMySQL" >
		update newphotoassets
		set assetPhotoType = #newPhoto.assetPhotoType#,
		fileName = '#newPhoto.fileName#',
		position = #newPhoto.position#
		where id = #newPhoto.id#
	</cfquery>
	<cfreturn 1>
</cffunction>


<cffunction name="createNewPhotoAsset" access="remote" returntype="Any" >
	<cfargument name="newPhotoType" type="any" required="true" >
	`	<cfquery datasource="eakinsMySQL" name="newPhoto">
			insert into newphotoassets( assetPhotoType, bookID, fileName, position)
			values
			(#newPhotoType.assetPhotoType#,
			#newPhotoType.bookID#,
			'#newPhotoType.fileName#',
			#newPhotoType.position#
			)
		</cfquery>
		<cfreturn 1> 
</cffunction>

<cffunction name="deleteNewPhotoAsset" access="remote" returntype="Any" >
	<cfargument name="id" type="numeric" required="true" >
		<cfquery name="delete" datasource="eakinsMySQL" >
			delete from newphotoassets
			where id = #id#
		</cfquery>
	<cfreturn 1>
</cffunction>
	
	



<cffunction name="getNewsForBook" access="remote" returntype="Any" >
	<cfargument name="bookID" type="numeric" required="true" >
	<cfquery name="news" datasource="eakinsMySQL" >
		SELECT books.id, 
	books.news
	FROM books
	where books.id = #bookID#
	</cfquery>
	<cfreturn news>
</cffunction>	

<cffunction name="QueryToStruct" access="public" returntype="any" output="false"
hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">

<!--- Define arguments. --->
<cfargument name="Query" type="query" required="true"/>
<cfargument name="Row" type="numeric" required="false" default="0"/>

<cfscript>

// Define the local scope.
var LOCAL = StructNew();

// Determine the indexes that we will need to loop over.
// To do so, check to see if we are working with a given row,
// or the whole record set.
if (ARGUMENTS.Row) {

// We are only looping over one row.
	LOCAL.FromIndex = ARGUMENTS.Row;
	LOCAL.ToIndex = ARGUMENTS.Row;

} else {

// We are looping over the entire query.
	LOCAL.FromIndex = 1;
	LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

}

// Get the list of columns as an array and the column count.
LOCAL.Columns = ListToArray(ARGUMENTS.Query.ColumnList);
LOCAL.ColumnCount = ArrayLen(LOCAL.Columns);

// Create an array to keep all the objects.
LOCAL.DataArray = ArrayNew(1);

// Loop over the rows to create a structure for each row.
for (LOCAL.RowIndex = LOCAL.FromIndex; LOCAL.RowIndex LTE LOCAL.ToIndex; LOCAL.RowIndex = (LOCAL.RowIndex + 1)) {

// Create a new structure for this row.
	ArrayAppend(LOCAL.DataArray, StructNew());

// Get the index of the current data array object.
	LOCAL.DataArrayIndex = ArrayLen(LOCAL.DataArray);

// Loop over the columns to set the structure values.
	for (LOCAL.ColumnIndex = 1; LOCAL.ColumnIndex LTE LOCAL.ColumnCount; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)) {

// Get the column value.
		LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

// Set column value into the structure.
		LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

	}

}


// At this point, we have an array of structure objects that
// represent the rows in the query over the indexes that we
// wanted to convert. If we did not want to convert a specific
// record, return the array. If we wanted to convert a single
// row, then return the just that STRUCTURE, not the array.
if (ARGUMENTS.Row) {

// Return the first array item.
	return( LOCAL.DataArray[ 1 ] );

} else {

// Return the entire array.
	return( LOCAL.DataArray );

}

</cfscript>
</cffunction>


</cfcomponent>


