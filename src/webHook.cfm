<cfscript>

    myData = deserializeJSON(ToString(getHTTPRequestData().content));
    
</cfscript>

<cfoutput>
    <cfif #myData.eventName# eq "order.completed">
    
        <cfset newMyData = #myData.content.items#>
        <cfset userData = #myData.content.user#>
        <cfset paymentData = #myData.content.paymentDetails#>
    
        <cfloop from="1" to="#arrayLen(newMyData)#" index="i">
        
            <!--- dance index --->
            <cfif #findNoCase("Dance Index", myData.content.items[i].name)# GT 0>
                <cfif (#findNoCase("Subscription", myData.content.items[i].name)#) EQ 0>
                    <!--- not a subscription --->
                    #myData.content.items[i].name# 
                    #myData.content.items[i].uniqueId# 
                    #myData.content.items[i].categories[2]# 
                    #myData.content.user.email#
                    <cfquery datasource="eakinsMySql">
                        insert into tbl_danceissuedownloads
                        (
                        pdfFileName,
                        code,
                        counter,
                        email
                        )values(
                        '#myData.content.items[i].categories[2]#',
                        '#myData.content.items[i].uniqueId#',
                        0,
                        '#myData.content.user.email#'
                        )
                    </cfquery>
                
                    <cfquery datasource="eakinsMySql">
                        insert into tbl_subscriptionsale
                        (
                        numberOfIssues,
                        numberOfIssuesSent,
                        customerEmail,
                        user_ID,
                        shippingAddressName,
                        shippingAddressCompanyName,
                        shippingAddressAddress1,
                        shippingAddressAddress2,
                        shippingAddressCity,
                        shippingAddressCountry,
                        shippingAddressState,
                        shippingAddressPostalCode
                        )
                        values( #myData.content.items[i].categories[3]#,
                        0,
                        '#myData.content.user.email#',
                        '#userData.id#',
                        '#userData.billingAddressName#',
                        '#userData.billingAddressCompanyName#',
                        '#userData.billingAddressAddress1#',
                        '#userData.billingAddressAddress2#',
                        '#userData.billingAddressCity#',
                        '#userData.billingAddressCountry#',
                        '#userData.billingAddressProvince#',
                        '#userData.billingAddressPostalCode#'
                        )
                    </cfquery>

                    <cfif (#findNoCase("PDF", myData.content.items[i].name)#) EQ 0>

                        <cfmail to="#myData.content.user.email#" from="info@eakinspress.com" 
                                bcc="lrlarson@mac.com" subject="Your Download Instructions" type="html">
                        
                            <div class="body" style="background-color:##e8e7e5">
                            <br/>
                            <br/>
                            Thank you for your purchase. If you purchased a print copy, it will be
                            mailed to you soon. You
                            have immediate access to a PDF version of the issue. Clicking this link
                            will take you the download page for 
                            <em>
                            #myData.content.items[i].name#
                            </em>
                            in PDF format.
                            <br/>
                            <br/>
                            You may download the issue up to three times.
                            <br/>
                            <br/>
                            <div style="text-align:center;">
                            <a href="https://www.eakinspress.com/danceindex/downloads/downloadPage.cfm?e=#myData.content.user.email#&ui=#myData.content.items[i].uniqueId#">
                            DOWNLOAD
                            </a>
                            </div>
                            </div>
                        </cfmail>
                    </cfif>

                    <cfquery datasource="eakinsMySql" name="doesCustomerExist">
                        select snipcart_id from tbl_customers
                        where snipcart_id = '#userData.id#'
                    </cfquery>
                    <!--- if customer exists --->
                    <cfif doesCustomerExist.recordCount GT 0>
                        <!--- it is loop index 1 --->
                        <cfif i EQ 1>
                            <!--- update demo data --->
                            <cfquery datasource="eakinsMySql">
                                update tbl_customers
                                set orderCount = orderCount + 1,
                                ordersAmount = ordersAmount + #myData.content.total#,
                                
                                lastDate = CURRENT_DATE(),
                                Name = '#userData.billingAddressName#',
                                Business = '#userData.BillingAddressCompanyName#',
                                Address_1 = '#userData.billingAddressAddress1#',
                                address_2 = '#userData.billingAddressAddress2#',
                                City = '#userData.billingAddressCity#',
                                Country = '#userData.billingAddressCountry#',
                                State = '#userData.billingAddressProvince#',
                                zip = '#userData.billingAddressPostalCode#'
                                where snipcart_id = '#userData.id#'
                            </cfquery>
                        </cfif>
                    <cfelse><!---New Customer --->
                        <cfquery name="newCustomer" datasource="eakinsMySQL">
                            insert into tbl_customers
                            (snipcart_id, email, orderCount, lastDate, Name,
                            Business, Address_1, address_2, City, Country,
                            State, zip,ordersAmount)
                            
                            values
                            (<cfqueryparam value="#userData.id#" cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.email#" cfsqltype="cf_sql_varchar">
                            ,
                            1,
                            CURRENT_DATE(),<cfqueryparam value="#userData.billingAddressName#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.BillingAddressCompanyName#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressAddress1#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressAddress2#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressCity#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressCountry#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressProvince#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value="#userData.billingAddressPostalCode#" 
                                      cfsqltype="cf_sql_varchar">
                            ,<cfqueryparam value=#myData.content.total# cfsqltype="cf_sql_decimal">
                            )
                        </cfquery>
                        new customer
                        #userData.id# 
                        #userData.email# 
                        #myData.content.items[i].name# 
                        i=
                        #i# 
                        #myData.content.total# 
                    </cfif>
                <cfelse>
                    <!--- it is a dance index subscription --->
                    #myData.content.items[i].name# 
                    #myData.content.items[i].uniqueId# 
                    #myData.content.items[i].categories[2]# 
                    #myData.content.user.email#
                    <cfquery datasource="eakinsMySql">
                        insert into tbl_danceissuedownloads
                        (
                        pdfFileName,
                        code,
                        counter,
                        email
                        )values(
                        '#myData.content.items[i].categories[2]#',
                        '#myData.content.items[i].uniqueId#',
                        0,
                        '#myData.content.user.email#'
                        )
                    </cfquery>
                    <!--- punch in subscription information --->
                    <cfquery datasource="eakinsMySql">
                        insert into tbl_subscriptionsale
                        (
                        numberOfIssues,
                        numberOfIssuesSent,
                        customerEmail,
                        user_ID,
                        shippingAddressName,
                        shippingAddressCompanyName,
                        shippingAddressAddress1,
                        shippingAddressAddress2,
                        shippingAddressCity,
                        shippingAddressCountry,
                        shippingAddressState,
                        shippingAddressPostalCode
                        
                        
                        
                        
                        
                        )
                        values( #myData.content.items[i].categories[3]#,
                        0,
                        '#myData.content.user.email#',
                        '#userData.id#',
                        '#userData.billingAddressName#',
                        '#userData.billingAddressCompanyName#',
                        '#userData.billingAddressAddress1#',
                        '#userData.billingAddressAddress2#',
                        '#userData.billingAddressCity#',
                        '#userData.billingAddressCountry#',
                        '#userData.billingAddressProvince#',
                        '#userData.billingAddressPostalCode#'
                        )
                    </cfquery>
                
                    <cfquery datasource="eakinsMySql">
                    
                        insert into tbl_subscriptionsaledetail
                        (subscriptionSaleID,
                        issueSent
                        )
                        values
                        (LAST_INSERT_ID(),
                        '#myData.content.items[i].name#'
                        )
                    </cfquery>
                    <cfmail to="#myData.content.user.email#" from="info@eakinspress.com" 
                            subject="Your Download Instructions" type="html">
                    
                        <div class="body" style="background-color:##e8e7e5">
                        <br/>
                        <br/>
                    
                        Thank you for your subscription. Your print copy of the currently available
                        issue will be mailed to you soon. You also have immediate access to a PDF
                        version of the issue. Clicking this link will take you to the download page
                        for 
                        <em>
                        #myData.content.items[i].name#
                        </em>
                        in PDF format.
                        <br/>
                        <br/>
                        You may download the issue up to 3 times.
                        <br/>
                        <br/>
                        <div style="text-align:center;">
                        <a href="https://www.eakinspress.com/danceindex/downloads/downloadPage.cfm?e=#myData.content.user.email#&ui=#myData.content.items[i].uniqueId#">
                        DOWNLOAD
                        </a>
                        </div>
                        </div>
                    </cfmail>
                    <!--- record purchase in customers table --->
                    <cfquery datasource="eakinsMySql" name="doesCustomerExist">
                        select snipcart_id from tbl_customers
                        where snipcart_id = '#userData.id#'
                    </cfquery>
                    <!--- if customer exists --->
                    <cfif doesCustomerExist.recordCount GT 0>
                        <!--- it is loop index 1 --->
                        <cfif i EQ 1>
                            <!--- update demo data --->
                            <cfquery datasource="eakinsMySql">
                                update tbl_customers
                                set orderCount = orderCount + 1,
                                ordersAmount = ordersAmount + #myData.content.total#,
                                
                                lastDate = CURRENT_DATE(),
                                Name = '#userData.billingAddressName#',
                                Business = '#userData.BillingAddressCompanyName#',
                                Address_1 = '#userData.billingAddressAddress1#',
                                address_2 = '#userData.billingAddressAddress2#',
                                City = '#userData.billingAddressCity#',
                                Country = '#userData.billingAddressCountry#',
                                State = '#userData.billingAddressProvince#',
                                zip = '#userData.billingAddressPostalCode#'
                                where snipcart_id = '#userData.id#'
                            </cfquery>
                        </cfif>
                    <cfelse><!---New Customer --->
                        <cfquery name="newCustomer" datasource="eakinsMySQL">
                            insert into tbl_customers
                            (snipcart_id, email, orderCount, lastDate, Name, Business, Address_1,
                            address_2, City, Country, State, zip,ordersAmount)
                            values
                            (
                            '#userData.id#','#userData.email#',1,CURRENT_DATE(),'#userData.billingAddressName# 
                            ','#userData.BillingAddressCompanyName#','#userData.billingAddressAddress1# 
                            ','#userData.billingAddressAddress2#','#userData.billingAddressCity#','#userData.billingAddressCountry# 
                            ','#userData.billingAddressProvince#','#userData.billingAddressPostalCode# 
                            ', #myData.content.total# )
                        </cfquery>
                        new customer
                        #userData.id# 
                        #userData.email# 
                        #myData.content.items[i].name# 
                        i=
                        #i#
                    </cfif>
                </cfif>
            <cfelse>
                <!--- it is a completed purchase but not dance index--->
                <!--- record purchase in customers table --->
                <cfquery datasource="eakinsMySql" name="doesCustomerExist">
                    select snipcart_id from tbl_customers
                    where snipcart_id = '#userData.id#'
                </cfquery>
                <!--- if customer exists--->
                <cfif doesCustomerExist.recordCount GT 0>
                    <!--- it is loop index 1 --->
                    <cfif i EQ 1>
                        <!--- update demo data --->
                        <cfquery datasource="eakinsMySql">
                            update tbl_customers
                            set orderCount = orderCount + 1,
                            lastDate = CURRENT_DATE(),
                            ordersAmount = ordersAmount + #myData.content.total#,
                            Name = '#userData.billingAddressName#',
                            Business = '#userData.BillingAddressCompanyName#',
                            Address_1 = '#userData.billingAddressAddress1#',
                            address_2 = '#userData.billingAddressAddress2#',
                            City = '#userData.billingAddressCity#',
                            Country = '#userData.billingAddressCountry#',
                            State = '#userData.billingAddressProvince#',
                            zip = '#userData.billingAddressPostalCode#'
                            where snipcart_id = '#userData.id#'
                        </cfquery>
                    </cfif>
                <cfelse><!---New Customer --->
                    <cfquery name="newCustomer" datasource="eakinsMySQL">
                        insert into tbl_customers
                        (snipcart_id, email, orderCount, lastDate, Name, Business, Address_1,
                        address_2, City, Country, State, zip,ordersAmount)
                        values
                        (
                        '#userData.id#','#userData.email#',1,CURRENT_DATE(),'#userData.billingAddressName# 
                        ','#userData.BillingAddressCompanyName#','#userData.billingAddressAddress1# 
                        ','#userData.billingAddressAddress2#','#userData.billingAddressCity#','#userData.billingAddressCountry# 
                        ','#userData.billingAddressProvince#','#userData.billingAddressPostalCode#',#myData.content.total# 
                        )
                    </cfquery>
                    new customer
                </cfif>
                #myData.content.items[i].price#
                ---total-'
                #mydata.content.items[i].totalPrice#
                ' 
                #userData.id# 
                #userData.email# 
                #myData.content.items[i].name# 
                i=
                #i#
                ,
                #myData.content.token#
                ,
                #myData.content.items[i].id#
                ,
                #mydata.createdOn#
                #myData.content.grandTotal#
            </cfif>
            <!--- insert into orders table --->
            <cfif i EQ 1>
                <cfquery datasource="eakinsMySQL">
                
                    insert into tbl_orders
                    (Trans_ID,
                    items__items__id,
                    itemName,
                    item_Quantity,
                    snipcart_ID,
                    items__completionDate,
                    items__numberOfItemsInOrder,
                    items__finalGrandTotal,
                    items__invoiceNumber,
                    Price,
                    items__items__totalPrice,
                    masterTrans
                    )
                    values(
                    '#myData.content.token#',
                    '#myData.content.items[i].id#',
                    '#myData.content.items[i].name#', #myData.content.items[i].quantity#,
                    '#userData.id#',
                    '#mydata.createdOn#', #mydata.content.numberOfItemsInOrder#, #myData.content.finalGrandTotal# 
                    ,
                    '#myData.content.invoiceNumber#',
                    '#myData.content.items[i].price#',
                    '#mydata.content.items[i].totalPrice#',
                    1
                    )
                </cfquery>
                
                
            <cfelse>
                <cfquery datasource="eakinsMySQL">
                
                    insert into tbl_orders
                    (Trans_ID,
                    items__items__id,
                    itemName,
                    item_Quantity,
                    snipcart_ID,
                    items__completionDate,
                    items__numberOfItemsInOrder,
                    items__finalGrandTotal,
                    items__invoiceNumber,
                    Price,
                    items__items__totalPrice,
                    masterTrans
                    )
                    values(
                    '#myData.content.token#',
                    '#myData.content.items[i].id#',
                    '#myData.content.items[i].name#', #myData.content.items[i].quantity#,
                    '#userData.id#',
                    '#mydata.createdOn#', #mydata.content.numberOfItemsInOrder#, #myData.content.finalGrandTotal# 
                    ,
                    '#myData.content.invoiceNumber#',
                    '#myData.content.items[i].price#',
                    '#mydata.content.items[i].totalPrice#',
                    0
                    )
                </cfquery>
                
            </cfif>
        </cfloop>
    
    <cfelse>
        <!--- it is not a completed purchase but could be client update--->
        triggered
    </cfif>
</cfoutput>