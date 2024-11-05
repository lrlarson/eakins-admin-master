<cfcomponent>

    <cfheader name="Access-Control-Allow-Origin" value="*">

    <cfheader name="Access-Control-Allow-Methods" value="OPTIONS,GET,PUT,POST,DELETE">

    <cfheader name="Access-Control-Allow-Headers" value="Origin, X-Requested-With, Content-Type, Accept">
   
    <cffunction name="init" access="remote" returntype="any">
        <cfreturn this/>
    </cffunction> 
      

    <cffunction name="getOneMemory" access="remote" returntype="any" returnformat="JSON" >
        <cfargument name="id" type="numeric" required="true" >
        <cfquery name=memory datasource="merce5">
            select tbl_Remember.id, image, name,  publish, headline, localVideo, type, memory_text, memoryImage, memoryCaption,tbl_MemoryTypes.memoryType
            from tbl_Remember
            inner join tbl_MemoryTypes on tbl_MemoryTypes.id = tbl_Remember.type
            where tbl_Remember.id = #id#  
        </cfquery>
     <cfset arrGirls = QueryToStruct(memory) />
     <cfset objectWrapper = structNew()>
     <cfset objectWrapper.results = #arrGirls#>
     <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getMemoryTypes" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="types" datasource="merce5">
            select id as data, memoryType as label from tbl_MemoryTypes
        </cfquery>
        <cfset arrGirls = QueryToStruct(types) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>


    <cffunction name="getMemories" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="memories" datasource="merce5">
            select tbl_Remember.id, image, name,  publish, headline, localVideo, type, memory_text, memoryImage, memoryCaption,tbl_MemoryTypes.memoryType
            from tbl_Remember
            inner join tbl_MemoryTypes on tbl_MemoryTypes.id = tbl_Remember.type
        </cfquery>
        <cfset arrGirls = QueryToStruct(memories) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>
    
    
    <cffunction name="getAnnouncements" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="popup" datasource="merce5">
            select convert(varchar(16), pubDateStart, 23) as pubDateStart,convert(varchar(16), pubDateEnd, 23) as pubDateEnd,display,text
            from tbl_PopUpContent
            where id=1
        </cfquery>
        <cfset arrGirls = QueryToStruct(popup) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>


    <cffunction name="updateShowcaseLink" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="showcaseObject" type="any">
        <cfset showcaseObject = DeserializeJSON(showcaseObject)> 
        <cfquery name="link" datasource="merce_5">
            update tbl_HomePageShowcase
            set showcaseLink = '#showcaseObject.SHOWCASELINK#'
            where id = #showcaseObject.ID#
        </cfquery>
        <cfreturn 1>   
    </cffunction>

    <cffunction name="getShowCaseLink" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="link" datasource="merce_5">
            select * from tbl_HomePageShowcase
            where id = 1
        </cfquery>
        <cfset arrGirls = QueryToStruct(link) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>


    <cffunction name="saveNewLetter" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="letterObject" type="any" required="true">
        <cfset letterObject = DeserializeJSON(letterObject)> 
        <cfif letterObject.PUBLISH EQ 'true'>
            <cfset letterObject.PUBLISH = 1>
        <cfelseif letterObject.PUBLISH EQ 'false'>  
            <cfset letterObject.PUBLISH = 0>
        </cfif>
        <cfquery name="newLetter" datasource="merce_5">
            insert into tbl_DirectorsLetters(text, 
                                 pubDate, 
                                 publish, 
                                 datestring)
                                 values(
                                    '#letterObject.TEXT#',
                                    '#letterObject.PUBDATE#',  
                                    #letterObject.PUBLISH#,
                                    '#letterObject.DATESTRING#'
                                 )
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="editMessage" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="messageObject" type="any" required="true">
        <cfset messageObject = DeserializeJSON(messageObject)> 
        <cfif messageObject.DISPLAY EQ 'true'>
            <cfset messageObject.DISPLAY = 1>
        <cfelseif messageObject.DISPLAY EQ 'false'>  
            <cfset messageObject.DISPLAY = 0>
        </cfif>
        <cfquery name="message" datasource="merce_5">
            update tbl_PopUpContent
            set display = #messageObject.DISPLAY#,
            pubDateStart = '#messageObject.PUBDATESTART#',
            pubDateEnd = '#messageObject.PUBDATEEND#',
            text = '#messageObject.TEXT#'
            where id = 1
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="editLetter" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="letterObject" type="any" required="true">
        <cfset letterObject = DeserializeJSON(letterObject)> 
        <cfif letterObject.PUBLISH EQ 'true'>
            <cfset letterObject.PUBLISH = 1>
        <cfelseif letterObject.PUBLISH EQ 'false'>  
            <cfset letterObject.PUBLISH = 0>
        </cfif>
        <cfquery name="editLetter" datasource="merce_5">
            update tbl_DirectorsLetters
            set text = '#letterObject.TEXT#',
            pubDate = '#letterObject.PUBDATE#',
            publish = #letterObject.PUBLISH#,
            datestring = '#letterObject.DATESTRING#'
            where id = #letterObject.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>


    <cffunction name="getDirectorLetters" access="remote" returntype="any" returnformat="JSON">
         <cfquery name='letters' datasource="merce_5">
         select datestring,id,convert(varchar(16), pubDate, 23) as pubDate,publish,text 
         from tbl_DirectorsLetters
            order by pubDate desc
         </cfquery>   
        <cfset arrGirls = QueryToStruct(letters) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getLetter" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name= "letterID" type="any" required="true">
        <cfquery name="id" datasource="merce_5">
            select datestring,id,convert(varchar(16), pubDate, 23) as pubDate,publish,text 
            from tbl_DirectorsLetters
           where id = #letterID#
        </cfquery>
        <cfset arrGirls = QueryToStruct(id) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getLatestLetter" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="id" datasource="merce_5">
            select top 1 *
            from tbl_DirectorsLetters
            order by pubDate desc
        </cfquery>
        <cfreturn id>
    </cffunction>

    <cffunction name="deleteWorkshop" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="id" datasource="merce_5">
            delete from tbl_Workshops
            where id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction>
    

    <cffunction name="insertNewWorkshop" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="workshop" type="any">
        <cfset workshop = DeserializeJSON(workshop)> 
        <cfquery name="work" datasource="merce_5">
            insert into tbl_Workshops (title, dance, dateString, startDate, workshopType, leader, location, endDate)
            values
            (
            '#workshop.TITLE#',
            '#workshop.DANCE#',
            '#workshop.DATESTRING#',
            '#workshop.STARTDATE#',
            #workshop.WORKSHOPTYPE#,
            '#workshop.LEADER#',
            '#workshop.LOCATION#',
            '#workshop.ENDDATE#'
            )
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="updateWorkshop" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="workshop" type="any">
        <cfset workshop = DeserializeJSON(workshop)> 
        <cfquery name="edit" datasource="merce_5">
            update tbl_Workshops
            set title = '#workshop.TITLE#',
            dance = '#workshop.DANCE#',
            dateString = '#workshop.DATESTRING#',
            startDate = '#workshop.STARTDATE#',
            workshopType = #workshop.WORKSHOPTYPE#,
            leader = '#workshop.LEADER#',
            location = '#workshop.LOCATION#',
            endDate = '#workshop.ENDDATE#'
            where id = #workshop.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="getWorkshop" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="id" type="numeric" required="true">
        <cfquery name="workShops" datasource="merce_5">
            select tbl_Workshops.id, title, dance, dateString, convert(varchar(16), startDate, 23) as startDate,convert(varchar(16), endDate, 23) as endDate, tbl_WorkshopTypes.workshopType as workShopTypeString, tbl_Workshops.workshopType, leader, location, PDFLink, endDate
            from tbl_Workshops inner join tbl_WorkshopTypes on tbl_Workshops.workshopType = tbl_WorkshopTypes.id
            where tbl_Workshops.id = #id#
        </cfquery>
         <cfset arrGirls = QueryToStruct(workShops) />
         <cfset objectWrapper = structNew()>
         <cfset objectWrapper.results = #arrGirls#>
         <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getAllWorkshops" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="workShops" datasource="merce_5">
            select tbl_Workshops.id, title, dance, dateString, startDate, tbl_WorkshopTypes.workshopType as workShopTypeString, tbl_Workshops.workshopType, leader, location, PDFLink, endDate
            from tbl_Workshops inner join tbl_WorkshopTypes on tbl_Workshops.workshopType = tbl_WorkshopTypes.id
        </cfquery>
        <cfset arrGirls = QueryToStruct(workShops) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getWorkShopTypes" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="types" datasource="merce_5">
            select id as data, workshopType as label from tbl_WorkshopTypes
        </cfquery>
        <cfset arrGirls = QueryToStruct(types) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>
   

    <cffunction name="updateHomePageVideo" access="remote"   returntype="Any" returnformat="JSON">
       <cfargument name="webVideoObject" type="any">
         <cfset webVideoObject = DeserializeJSON(webVideoObject)> 
        <cfif webVideoObject.PUBLISH EQ 'true'>
            <cfset webVideoObject.PUBLISH = 1>
            <cfelse>
            <cfset webVideoObject.PUBLISH = 0>
        </cfif>
        <cfquery name="update" datasource="merce_5">
            update tbl_WebVideos
            set
            fileName = '#webVideoObject.FILENAME#',
            Description = '#webVideoObject.DESCRIPTION#',
            thumb = '#webVideoObject.THUMB#',
            publish = #webVideoObject.PUBLISH#
            where id = #webVideoObject.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>


 <cffunction name="insertNewHomePageVideo" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="webVideoObject" type="any">
         <cfset webVideoObject = DeserializeJSON(webVideoObject)> 
         <cfif StructKeyExists(webVideoObject, "PUBLISH")>
            <cfif webVideoObject.PUBLISH EQ 'true'>
                <cfset webVideoObject.PUBLISH = 1>
            <cfelse>
                <cfset webVideoObject.PUBLISH = 0>
            </cfif>
    <cfelse>
        <cfset webVideoObject.PUBLISH = 0>
    </cfif>
        <cfquery name="video" datasource="merce_5">
            insert into tbl_WebVideos (
                fileName, 
                Description, 
                assetTarget, 
                thumb, 
                publish)
            values (
            '#webVideoObject.FILENAME#',
            '#webVideoObject.DESCRIPTION#',
                     1,
            '#webVideoObject.THUMB#',
            #webVideoObject.PUBLISH#
            )
            select @@identity
        </cfquery>
        <cfreturn video>
    </cffunction>


    <cffunction name="getSpecificWebVideo" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="id" type="numeric" required="true">
        <cfquery name="video" datasource="merce_5">
            select * from tbl_WebVideos
            where id = #id#
        </cfquery>
        <cfset arrGirls = QueryToStruct(video) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>
    
    
    <cffunction name="getWebVideos" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="videos" datasource="merce_5">
            select * from tbl_WebVideos
        </cfquery>
        <cfset arrGirls = QueryToStruct(videos) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    
         <cffunction name="getLicTypes" access="remote" returntype="Any" returnformat="JSON">
        <cfquery name="licTypes" datasource="merce_5">
            select id as data, licType as Label from tbl_LicType
        </cfquery>
        <cfset arrGirls = QueryToStruct(licTypes) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="addRelatedDance" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="selectedDance" type="any" >
     <cfset selectedDance = DeserializeJSON(selectedDance)> 
    <cfquery name="queryName" datasource="merce_5">
        insert into tbl_Lic_Dance
        (
            licID,
            danceID
        ) 
        VALUES
        (
           #selectedDance.LICID#,
             #selectedDance.DATA#
        )
    </cfquery>

        <cfreturn 1> 
        </cffunction>

     <cffunction name="deleteRelatedDance" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="relatedID" type="any" >
    <cfquery name="queryName" datasource="merce_5">
        delete from tbl_Lic_Dance
        where id = #relatedID#
    </cfquery>
    <cfreturn 1>
</cffunction>

    <cffunction name="getRelatedDancesForLic" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="licID" type="numeric" required="true">
            <cfquery name="dances" datasource="merce_5">
                select tbl_Works.workTitle,tbl_Works.id as workID,tbl_Lic_Dance.id as relatedID from  tbl_Lic_Dance inner join tbl_Works on tbl_Lic_Dance.danceID = tbl_Works.id
                where tbl_Lic_Dance.licID = #licID#
            </cfquery>
               <cfset arrGirls = QueryToStruct(dances) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="getDanceName" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="id" type="any" >
    <cfquery name="queryName" datasource="merce_5">

  </cfquery>
    <cfset arrGirls = QueryToStruct(queryName) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper> 
</cffunction>

    <cffunction name="getDanceNames" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="dances" datasource="merce_5">
            select  workTitle as label, id as data
            from tbl_Works
            order by workTitle
        </cfquery>
        <cfset arrGirls = QueryToStruct(dances) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>
    
    <cffunction name="getLicenses" access="remote"   returntype="Any" returnformat="JSON">
        <cfquery name="lic" datasource="merce_5">
        select tbl_LicenseNew.id, danceName, company, tbl_LicType.licType, tbl_LicenseNew.active, tbl_LicenseNew.referenceYear from tbl_LicenseNew
        inner join tbl_LicType on tbl_LicenseNew.licType = tbl_LicType.id
        order by tbl_LicenseNew.referenceYear DESC
        </cfquery>
       <cfset arrGirls = QueryToStruct(lic) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>
    
    
    <cffunction name="getLicenseDetails" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="licID" type="numeric" required="true">
            <cfquery name="lic" datasource="merce_5">
                select * from tbl_LicenseNew
                where id = #licID#
            </cfquery>
         <cfset arrGirls = QueryToStruct(lic) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

        <cffunction name="saveLicEdit" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="licenseObject" type="any" required="true">
         <cfset licenseObject = DeserializeJSON(licenseObject)> 
            <cfif licenseObject.ACTIVE EQ 'true'>
                <cfset licenseObject.ACTIVE = 1>
                <cfelse>
                <cfset licenseObject.ACTIVE = 0>
            </cfif>
            <cfquery name="licEdit" datasource="merce_5">
                update tbl_LicenseNew
                set yearString = '#licenseObject.YEARSTRING#',
                stager = '#licenseObject.STAGER#',
                  company = '#licenseObject.COMPANY#',
                  licType = #licenseObject.LICTYPE#,
                  referenceYear = #licenseObject.REFERENCEYEAR#,
                  location = '#licenseObject.LOCATION#',
                  description = '#licenseObject.DESCRIPTION#',
                  active = #licenseObject.ACTIVE#,
                  danceName = '#licenseObject.DANCENAME#'
                where id = #licenseObject.ID#
            </cfquery>
        <cfreturn 1>
    </cffunction>
     
     <cffunction name="deleteLicense" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="id" type="numeric" >
    <cfquery name="queryName" datasource="merce_5">
            delete from tbl_LicenseNew
            where id = #id#
        </cfquery>
        <cfreturn 1> 
        </cffunction>


    <cffunction name="insertRelatedDanceLic" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="relatedDances" type="any" required="true">
            <cfquery name="insertDance" datasource="merce_5">
                insert into tbl_Lic_Dance(
                licID,
                danceID
                )values (
                    #relatedDances.licID#,
                    #relatedDances.danceID#
                )
            </cfquery>
        <cfreturn 1>
    </cffunction>

     <cffunction name="insertNewLicense" access="remote"   returntype="Any" returnformat="JSON">
        <cfargument name="licenseObject" type="any" required="true">
         <cfset licenseObject = DeserializeJSON(licenseObject)> 
            <cfif LICENSEOBJECT.ACTIVE EQ 'true'>
                <cfset LICENSEOBJECT.ACTIVE = 1>
            <cfelse>
                <cfset LICENSEOBJECT.ACTIVE = 0>
            </cfif>
            <cfquery name="newLic" datasource="merce_5">
                insert into tbl_LicenseNew
                (yearString, 
                danceName,  
                company, 
                stager, 
                licType, 
                referenceYear, 
                location, 
                description, 
                active)
                values (
                '#licenseObject.YEARSTRING#', 
                '#licenseObject.DANCENAME#', 
                '#licenseObject.COMPANY#', 
                '#licenseObject.STAGER#', 
                #licenseObject.LICTYPE#, 
                #licenseObject.REFERENCEYEAR#, 
                '#licenseObject.LOCATION#', 
                '#licenseObject.DESCRIPTION#', 
                #licenseObject.ACTIVE#
                )
                select @@IDENTITY
            </cfquery>
        <cfreturn newLic>
    </cffunction>

     <cffunction name="deleteRevival" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="revival_ID" type="any" >
    <cfquery name="queryName" datasource="merce_5">
        delete from tbl_Revivals
        where id = #revival_ID#
        select 1
  </cfquery>
    <cfset arrGirls = QueryToStruct(queryName) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper> 
</cffunction>

     <cffunction name="getRevivalsDetails" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="revival_ID" type="any">
        <cfquery name="revivals" datasource="merce_5">
            select id, revivalYear,revivalNotes,city,dance_ID from tbl_Revivals
            where id = #revival_ID#
        </cfquery>
        <cfset arrGirls = QueryToStruct(revivals) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="insertNewRevival" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="revivalObject" type="any">
         <cfset revivalObject = DeserializeJSON(revivalObject)> 
        <cfquery name="newRevival" datasource="merce_5">
            insert into tbl_Revivals(
            dance_ID,
            revivalYear,
            city,
            revivalNotes)
            values(
            #revivalObject.DANCE_ID#,
            '#revivalObject.REVIVALYEAR#',
            '#revivalObject.CITY#',
            '#revivalObject.REVIVALNOTES#'
            )
           
        </cfquery>
        <cfreturn 1>
    </cffunction>


    <cffunction name="updateRevival" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="revivalObject" type="any">
         <cfset revivalObject = DeserializeJSON(revivalObject)> 
        <cfquery name="revival" datasource="merce_5">
            update tbl_Revivals
            set revivalYear = '#revivalObject.REVIVALYEAR#',
            city = '#revivalObject.CITY#',
            revivalNotes = '#revivalObject.REVIVALNOTES#'
            where id = #revivalObject.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="getRevivalsForWork" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="dance_ID" type="any">
        <cfquery name="revivals" datasource="merce_5">
            select id, revivalYear,revivalNotes,city,dance_ID from tbl_Revivals
            where dance_ID = #dance_ID#
        </cfquery>
        <cfset arrGirls = QueryToStruct(revivals) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>



    <cffunction name="getMusicForWork" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableMusic">
SELECT     tbl_Music.id AS data, dbo.tbl_Composers.Composer_LN, dbo.tbl_Composers.Composer_FN, tbl_Music.Title, dbo.tbl_Composers.Composer_FN+' '+dbo.tbl_Composers.Composer_LN+' '+dbo.tbl_Music.title
                AS label, tbl_Work_Music.id
               FROM         tbl_Work_Music INNER JOIN
                              tbl_Music ON tbl_Work_Music.music = tbl_Music.id INNER JOIN
                              tbl_Composers ON tbl_Music.Composer = tbl_Composers.id  
                WHERE     (dbo.tbl_Work_Music.work= #danceID#)
                order by ID desc
    </cfquery>
   <cfset arrGirls = QueryToStruct(availableMusic) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    
    <cffunction name="createAssocRecordForMusic" access="remote" returntype="Any" returnformat="JSON">
            <cfargument name="danceID" required="yes" type="numeric">
            <cfargument name="MusicID" required="yes" type="numeric">
            <cfargument name="notes" required="yes" type="string">
            <cfquery datasource="merce_5" name="addAssocRecord">
            	INSERT INTO dbo.tbl_Work_Music
                ( work ,
                  Music,
                  notes 

                )
      		  VALUES  ( 
              	  #danceID#,
                 #MusicID#,
                 '#notes#'  
                )
            </cfquery>
            <cfreturn 1>
    </cffunction>
    
     <cffunction name="deleteMusicAssociation" access="remote" returntype="Any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="deleteReturn">
        	DELETE FROM dbo.tbl_Work_Music
			WHERE id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction>  
   
    <cffunction name="updateMusicAssociation" access="remote" returntype="Any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
         <cfargument name="notes"  type="string">
        <cfquery datasource="merce_5" name="associationReturn">
        	update dbo.tbl_Work_Music
            set notes = '#notes#'
			WHERE id = #id#
            select 1
        </cfquery>
         <cfset arrGirls = QueryToStruct(associationReturn) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    
    <cffunction name="getAssociationMusic" access="remote" returntype="Any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="associationReturn">
            SELECT     tbl_Work_Music.notes, tbl_Work_Music.id,tbl_Music.Title, tbl_Composers.Composer_FN, tbl_Composers.Composer_LN
            FROM         tbl_Work_Music INNER JOIN
                                  tbl_Music ON tbl_Work_Music.music = tbl_Music.id INNER JOIN
                                  tbl_Composers ON tbl_Music.Composer = tbl_Composers.id
            WHERE     (tbl_Work_Music.id = #id#)
        </cfquery>
       <cfset arrGirls = QueryToStruct(associationReturn) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

      <cffunction name="getAvailableMusic" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableMusic">
 		SELECT    tbl_Music.id AS data, dbo.tbl_Composers.Composer_LN, dbo.tbl_Composers.Composer_FN, tbl_Music.Title, dbo.tbl_Music.title + ', ' + dbo.tbl_Composers.Composer_LN
     AS label
        FROM         tbl_Music INNER JOIN
                      tbl_Composers ON tbl_Music.Composer = tbl_Composers.id
        WHERE tbl_Music.id NOT IN (
        SELECT     tbl_Music.id
        FROM         tbl_Work_Music INNER JOIN
                              tbl_Music ON tbl_Work_Music.Music = tbl_Music.id
        WHERE     (tbl_Work_Music.[work] = #danceID#)
        )
    	order by label
    </cfquery>
   <cfset arrGirls = QueryToStruct(availableMusic) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getAllMusic" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="danceID" type="numeric">
        <cfquery datasource="merce_5" name="availableMusic">
             SELECT    tbl_Music.id, dbo.tbl_Composers.Composer_LN, dbo.tbl_Composers.Composer_FN, tbl_Music.Title, dbo.tbl_Music.title + ', ' + dbo.tbl_Composers.Composer_LN
         AS label, dbo.tbl_Composers.Composer_LN + ', ' + dbo.tbl_Composers.Composer_FN as fullName,tbl_composers.id as composerID
            FROM         tbl_Music INNER JOIN
                          tbl_Composers ON tbl_Music.Composer = tbl_Composers.id
            order by Title
        </cfquery>
       <cfset arrGirls = QueryToStruct(availableMusic) />
                        <cfset objectWrapper = structNew()>
                        <cfset objectWrapper.results = #arrGirls#>
                        <cfreturn objectWrapper> 
        </cffunction>

        <cffunction name="getMusicDetails" access="remote" returntype="Any" returnformat="JSON">
            <cfargument name="id" type="any" >
            <cfquery name="queryName" datasource="merce_5">
                 SELECT    tbl_Music.id, dbo.tbl_Composers.Composer_LN, dbo.tbl_Composers.Composer_FN, tbl_Music.Title,tbl_composers.id as composerID
            FROM         tbl_Music INNER JOIN
                          tbl_Composers ON tbl_Music.Composer = tbl_Composers.id
            where tbl_Music.id = #id#              
            </cfquery>
           <cfset arrGirls = QueryToStruct(queryName) />
           <cfset objectWrapper = structNew()>
           <cfset objectWrapper.results = #arrGirls#>
           <cfreturn objectWrapper> 
            </cffunction>

            <cffunction name="updateMusic" access="remote" returntype="Any" returnformat="JSON">
                <cfargument name="MusicObject" type="any" >
                <cfset MusicObject = DeserializeJSON(MusicObject)> 
                <cfquery name="queryName" datasource="merce_5">
                 update tbl_Music
                set Title = '#MusicObject.TITLE#',Composer=#MusicObject.COMPOSERID#
                where id = #MusicObject.ID#
                  </cfquery>
                <cfreturn 1> 
                </cffunction>

            <cffunction name="getComposersNew" access="remote" returntype="Any" returnformat="JSON">
                <cfquery name="queryName" datasource="merce_5">
                  select * from tbl_Composers
                    order by Composer_LN
                </cfquery>
                <cfset arrGirls = QueryToStruct(queryName) />
                <cfset objectWrapper = structNew()>
                <cfset objectWrapper.results = #arrGirls#>
                <cfreturn objectWrapper> 
                </cffunction>

         <cffunction name="deleteLightingAssociation" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="id" type="any" >
        <cfquery name="queryName" datasource="merce_5">
            delete from tbl_Work_Lighting
            where id = #ID#
        </cfquery>
        <cfreturn 1>
        </cffunction>

        <cffunction name="getAssociationLighting" access="remote" returntype="any"  returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="associationReturn">
           SELECT     tbl_Work_Lighting.notes, tbl_lightingDesigner.lightingDesigner_FN, tbl_lightingDesigner.lightingDesigner_LN,
                         tbl_lightingDesigner.lightingDesigner_FN + ' ' +  tbl_lightingDesigner.lightingDesigner_LN as LIGHTINGFULLNAME,
                         tbl_Work_Lighting.ID  
            FROM         tbl_Work_Lighting INNER JOIN
                                  tbl_LightingDesigner ON tbl_Work_Lighting.lightingDesigner = tbl_lightingDesigner.id
            WHERE     (tbl_Work_Lighting.id = #id#)
        </cfquery>
         <cfset arrGirls = QueryToStruct(associationReturn) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="getLightingDesignerDetails" access="remote" returntype="any" returnformat="JSON">
     <cfargument name="lightingDesignerID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="lightingDesigner">
                SELECT     id, lightingDesigner_FN, lightingDesigner_LN
                FROM         tbl_lightingDesigner
                WHERE     (id = #lightingDesignerID#)
        </cfquery> 
		<cfreturn lightingDesigner>
	</cffunction>
    
    <cffunction name="insertNewlightingDesigner" access="remote" returntype="any" returnformat="JSON">
        
             <cfset selectedNewLightingObject = DeserializeJSON(selectedNewLightingObject)> 
		<cfquery datasource="merce_5" name="lightingDesigner">
              insert into tbl_Work_Lighting
                (lightingDesigner, work, notes) 
                values(
                   #selectedNewLightingObject.ID#,
                   #selectedNewLightingObject.danceID#,
                   '#selectedNewLightingObject.NOTES#' 
                ) 
                select newID = @@IDENTITY
        </cfquery> 
		 <cfreturn lightingDesigner>
	</cffunction>

     <cffunction name="updatelightingDesignerDetails" access="remote" returntype="any" returnformat="JSON">
         <cfargument name="associatedLightingObject" type="any" required="true"> 
          <cfset associatedLightingObject = DeserializeJSON(associatedLightingObject)>   
		<cfquery datasource="merce_5" name="lightingDesigner">
                update tbl_Work_Lighting
            set notes = '#associatedLightingObject.NOTES#'
            where id = #associatedLightingObject.ID#
        </cfquery> 
		<cfreturn 1>
	</cffunction>
    
    
    
    
     <cffunction name="getAvailableLighting" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableLighting">
    	SELECT  id AS data, LightingDesigner_LN, LightingDesigner_FN, label = LightingDesigner_LN + ', ' +LightingDesigner_FN
        FROM         tbl_LightingDesigner
        WHERE id NOT IN (
        SELECT     tbl_LightingDesigner.id
        FROM         tbl_Work_Lighting INNER JOIN
                              tbl_LightingDesigner ON tbl_Work_Lighting.LightingDesigner = tbl_LightingDesigner.id
        WHERE     (tbl_Work_Lighting.[work] = #danceID#)
        )
    	order by label
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableLighting) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    
    <cffunction name="getLightingForWork" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableLighting">
        SELECT     tbl_LightingDesigner.LightingDesigner_FN, tbl_LightingDesigner.LightingDesigner_LN, tbl_Work_Lighting.id, 
                              tbl_LightingDesigner.LightingDesigner_LN + ', ' + tbl_LightingDesigner.LightingDesigner_FN AS LightingFullName
        FROM         tbl_LightingDesigner INNER JOIN
                              tbl_Work_Lighting ON tbl_LightingDesigner.id = tbl_Work_Lighting.LightingDesigner
        WHERE     (tbl_Work_Lighting.[work] = #danceID#)
    	order by LightingFullName
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableLighting) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>



    <cffunction name="deleteDecorAssociation" access="remote" returntype="any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="deleteReturn">
        	DELETE FROM dbo.tbl_Work_Decor
			WHERE id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction> 

    <cffunction name="insertNewDecorAssociation" access="remote" returntype="any" returnformat="JSON">
                <cfset selectedNewDecorObject = DeserializeJSON(selectedNewDecorObject)> 
		<cfquery datasource="merce_5" name="decor">
               insert into tbl_Work_Decor(decor, work, notes)
            values(
                #selectedNewDecorObject.ID#,
                #selectedNewDecorObject.danceID#,
                '#selectedNewDecorObject.NOTES#'
            )
        </cfquery> 
		<cfreturn 1>
	</cffunction>



     <cffunction name="updateDecorAssociation" access="remote" returntype="any" returnformat="JSON">
                <cfargument name="associatedDecorObject" type="any" required="true">
        <cfset associatedDecorObject = DeserializeJSON(associatedDecorObject)> 
                <cfquery datasource="merce_5" name="update">
                    update dbo.tbl_Work_Decor
                    set notes = '#associatedDecorObject.NOTES#'
                    WHERE id = #associatedDecorObject.ID#
                </cfquery>
                <cfreturn 1>
            </cffunction>

     <cffunction name="getAssociationDecor" access="remote" returntype="any"  returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="associationReturn">
           SELECT     tbl_Work_Decor.notes, tbl_Decor.decor_FN, tbl_Decor.decor_LN,
                         tbl_Decor.decor_FN + ' ' +  tbl_Decor.decor_LN as DECORFULLNAME,
                         tbl_Work_Decor.ID  
            FROM         tbl_Work_Decor INNER JOIN
                                  tbl_Decor ON tbl_Work_Decor.decor = tbl_Decor.id
            WHERE     (tbl_Work_Decor.id = #id#)
        </cfquery>
         <cfset arrGirls = QueryToStruct(associationReturn) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    
     <cffunction name="getAvailableDecor" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableDecor">
    	SELECT  id AS data, Decor_LN, Decor_FN, label = Decor_LN + ', ' +Decor_FN,Decor_FN + ' ' + decor_LN as DecorFullName
        FROM         tbl_Decor
        WHERE id NOT IN (
        SELECT     tbl_Decor.id
        FROM         tbl_Work_Decor INNER JOIN
                              tbl_Decor ON tbl_Work_Decor.Decor = tbl_Decor.id
        WHERE     (tbl_Work_Decor.[work] = #danceID#)
        )
    	order by label
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableDecor) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    
        <cffunction name="getAssociatedDecor" access="remote"  returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableDecor">
        SELECT     tbl_Decor.Decor_FN, tbl_Decor.Decor_LN, tbl_Work_Decor.id as DATA, 
                              tbl_Decor.Decor_LN + ', ' + tbl_Decor.Decor_FN AS LABEL,
                              tbl_Decor.Decor_FN + ' ' + tbl_Decor.Decor_LN as Decor_FULLNAME
        FROM         tbl_Decor INNER JOIN
                              tbl_Work_Decor ON tbl_Decor.id = tbl_Work_Decor.Decor
        WHERE     (tbl_Work_Decor.[work] = #danceID#)
    	order by label
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableDecor) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="deleteCostumerAssociation" access="remote" returntype="any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="deleteReturn">
        	DELETE FROM dbo.tbl_Work_Costumer
			WHERE id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction> 


         <cffunction name="createAssocRecordForCostumer" access="remote" returntype="any" returnformat="JSON">
            <cfargument name="selectedNewCostumerObject" required="True">
            <cfset selectedNewCostumerObject = DeserializeJSON(selectedNewCostumerObject)> 
            <cfquery datasource="merce_5" name="addAssocRecord">
            	INSERT INTO dbo.tbl_Work_costumer
                ( work ,
                  costumer, 
				notes	
                )
      		  VALUES  ( 
              	  #selectedNewCostumerObject.danceID#,
                 #selectedNewCostumerObject.ID#,
                 '#selectedNewCostumerObject.notes#'  
                )
            </cfquery>
            <cfreturn 1>
    </cffunction>


        <cffunction name="updateCostumerAssociation" access="remote" returntype="any" returnformat="JSON">
                <cfargument name="associatedCostumerObject" type="any" required="true">
        <cfset associatedCostumerObject = DeserializeJSON(associatedCostumerObject)> 
                <cfquery datasource="merce_5" name="update">
                    update dbo.tbl_Work_Costumer
                    set notes = '#associatedCostumerObject.NOTES#'
                    WHERE id = #associatedCostumerObject.ID#
                </cfquery>
                <cfreturn 1>
            </cffunction>

         <cffunction name="getCostumerAssociation" access="remote" returntype="any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="associationReturn">
           SELECT     tbl_Work_Costumer.id,tbl_Work_Costumer.notes, tbl_Costumers.Costumer_FN, tbl_Costumers.Costumer_LN, tbl_Costumers.costumerFullName
            FROM         tbl_Work_Costumer INNER JOIN
                                  tbl_Costumers ON tbl_Work_Costumer.Costumer = tbl_Costumers.id
            WHERE     (tbl_Work_Costumer.id = #id#)
        </cfquery>
         <cfset arrGirls = QueryToStruct(associationReturn) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

            <cffunction name="getCostumersForWork" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableCostumers">
        SELECT     tbl_Costumers.costumer_FN, tbl_Costumers.costumer_LN, tbl_Work_costumer.id, 
                              tbl_Costumers.costumer_LN + ', ' + tbl_Costumers.costumer_FN AS label
        FROM         tbl_Costumers INNER JOIN
                              tbl_Work_costumer ON tbl_Costumers.id = tbl_Work_costumer.costumer
        WHERE     (tbl_Work_costumer.[work] = #danceID#)
    	order by label
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableCostumers) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="getAvailableCostumers" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableCostumers">
    	SELECT  id AS data, Costumer_LN, Costumer_FN, label = Costumer_LN + ', ' +Costumer_FN
        FROM         tbl_Costumers
        WHERE id NOT IN (
        SELECT     tbl_Costumers.id
        FROM         tbl_Work_Costumer INNER JOIN
                              tbl_Costumers ON tbl_Work_Costumer.Costumer = tbl_Costumers.id
        WHERE     (tbl_Work_Costumer.[work] = #danceID#)
        )
    	order by label
    </cfquery>
   <cfset arrGirls = QueryToStruct(availableCostumers) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>


    <cffunction name="createAssocRecordForDancer" access="remote"  returntype="any" returnformat="JSON">
       <cfargument name="associatedDancerObject" type="any" required="true">
        <cfset associatedDancerObject = DeserializeJSON(associatedDancerObject)> 
        <cfif associatedDancerObject.ORIGINALDANCER EQ 'true'>
            <cfset associatedDancerObject.ORIGINALDANCER = 1>
        <cfelse>
            <cfset associatedDancerObject.ORIGINALDANCER = 0>
        </cfif>   
            <cfquery datasource="merce_5" name="addAssocRecord">
            	INSERT INTO dbo.tbl_Work_Dancer
                ( work ,
                  dancer ,
                  originalDancer ,
                  castInititials
                )
      		  VALUES  ( 
              	  #associatedDancerObject.WORK#,
                 #associatedDancerObject.DANCER#,
                 #associatedDancerObject.ORIGINALDANCER#, 
                 '#associatedDancerObject.CASTINITITIALS#'  
                )
                select @@identity as newData
            </cfquery>
        <cfreturn addAssocRecord>    
    </cffunction>

     <cffunction name="deleteDancerAssociation" access="remote" returntype="any" returnformat="JSON">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="deleteReturn">
        	DELETE FROM dbo.tbl_Work_Dancer
			WHERE id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction> 
    

    <cffunction name="getAssocRecordForDancer" access="remote"  returntype="any" returnformat="JSON">
    <cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="returnRecord">
          	SELECT     tbl_Work_Dancer.id,dancer, [work], originalDancer, castInititials, tD.dancer_FN,tD.dancer_LN
            FROM         tbl_Work_Dancer inner join tbl_Dancers tD on tD.id = tbl_Work_Dancer.dancer
            WHERE     (tbl_Work_Dancer.id = #id#) 
        </cfquery>
        <cfset arrGirls = QueryToStruct(returnRecord) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>
    

     <cffunction name="editAssociationForDancer" access="remote"  returntype="any" returnformat="JSON">
      <cfargument name="associatedDancerObject" type="any" required="true">
      <cfset associatedDancerObject = DeserializeJSON(associatedDancerObject)>
      <cfif (associatedDancerObject.ORIGINALDANCER neq 1) OR (associatedDancerObject.ORIGINALDANCER neq 0)>
          <cfif associatedDancerObject.ORIGINALDANCER eq 'YES'>
              <cfset associatedDancerObject.ORIGINALDANCER = 1>
          <cfelse>
                 <cfset associatedDancerObject.ORIGINALDANCER = 0>
          </cfif>
      </cfif>
    <cfquery name="editAssociation" datasource="merce_5">
    	UPDATE dbo.tbl_Work_Dancer

		SET originalDancer = #associatedDancerObject.ORIGINALDANCER#,
        castInititials = '#associatedDancerObject.CASTINITITIALS#'

		WHERE id = #associatedDancerObject.ID#
    </cfquery>
    <cfreturn 1>
    </cffunction>

    <cffunction name="getDancersForWork" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableDancers">
        SELECT     tbl_Dancers.dancer_FN, tbl_Dancers.dancer_LN, tbl_Work_Dancer.id, tbl_Work_Dancer.originalDancer, tbl_Work_Dancer.castInititials, 
                              tbl_Dancers.dancer_LN + ', ' + tbl_Dancers.dancer_FN AS label
        FROM         tbl_Dancers INNER JOIN
                              tbl_Work_Dancer ON tbl_Dancers.id = tbl_Work_Dancer.dancer
        WHERE     (tbl_Work_Dancer.[work] = #danceID#)
    	order by label
    </cfquery>
    <cfset arrGirls = QueryToStruct(availableDancers) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="getAvailableDancers" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="danceID" type="numeric">
    <cfquery datasource="merce_5" name="availableDancers">
    	SELECT  id AS data, dancer_LN, dancer_FN, label = dancer_LN + ', ' +dancer_FN
        FROM         tbl_Dancers
        WHERE id NOT IN (
        SELECT     tbl_Dancers.id
        FROM         tbl_Work_Dancer INNER JOIN
                              tbl_Dancers ON tbl_Work_Dancer.dancer = tbl_Dancers.id
        WHERE     (tbl_Work_Dancer.[work] = #danceID#)
        )
    	order by label
    </cfquery>
  <cfset arrGirls = QueryToStruct(availableDancers) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="updateDanceDetails" access="remote" returntype="any" returnformat="JSON"> 
    <cfargument name="danceObject" type="any" required="yes">
    <cfset danceObject = DeserializeJSON(danceObject)>

    	<cfquery datasource="merce_5" name="danceDetailsReturn">
			UPDATE dbo.tbl_Works
			SET workTitle = '#danceObject.WORKTITLE#' ,
              length = #danceObject.LENGTH# ,
              workLengthString = '#danceObject.WORKLENGTHSTRING#' ,
              premiereDate = '#danceObject.PREMIEREDATE#',
              premiereVenue = '#danceObject.PREMIEREVENUE#' ,
              premiereString= '#danceObject.PREMIERESTRING#' ,
              premiereCity = '#danceObject.PREMIERECITY#' ,
              premiereCountry = '#danceObject.PREMIERECOUNTRY#' ,
            workImage = '#danceObject.WORKIMAGE#',
            workImageNotes = '#danceObject.WORKIMAGENOTES#',
            capsuleURL = '#danceObject.CAPSULEURL#',
            link = '#danceObject.LINK#',
            mediaLink = '#danceObject.MEDIALINK#'
			WHERE id = #danceObject.ID#
    	</cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="insertNewDance" access="remote" returntype="any" returnformat="JSON"> 
        <cfargument name="danceObject" type="any" required="yes">
        <cfset danceObject = DeserializeJSON(danceObject)>
    
            <cfquery datasource="merce_5" name="danceDetailsReturn">
                insert into tbl_Works(
                      workTitle,
                      length,
                      workLengthString,
                      premiereDate,
                      premiereVenue,
                      premiereString,
                      premiereCity,
                      premiereCountry,
                      workImage,
                      workImageNotes,
                      capsuleURL,
                       link,
                      mediaLink,
                      hasRevival,
                    workCollabSummary,
                      description,
                      premiereYear,
                      timeSearch,
                      yearsSearch )
                      values (
                      '#danceObject.WORKTITLE#' ,
                    #danceObject.LENGTH# ,
              '#danceObject.WORKLENGTHSTRING#' ,
             '#danceObject.PREMIEREDATE#',
             '#danceObject.PREMIEREVENUE#' ,
             '#danceObject.PREMIERESTRING#' ,
             '#danceObject.PREMIERECITY#' ,
              '#danceObject.PREMIERECOUNTRY#' ,
           '#danceObject.WORKIMAGE#',
             '#danceObject.WORKIMAGENOTES#',
            '#danceObject.CAPSULEURL#',
            '#danceObject.LINK#',
           '#danceObject.MEDIALINK#' ,
           #danceObject.HAS_REVIVAL#,
           '#danceObject.WORKCOLLABSUMMARY#',
                      '#danceObject.DESCRIPTION#',
                      '#danceObject.PREMIEREYEAR#',
                      '#danceObject.TIMESEARCH#',
                      '#danceObject.YEARSSEARCH#' 
                      )
                      select @@identity
            </cfquery>
            <cfreturn danceDetailsReturn>
        </cffunction>



    <cffunction name="getDanceDetails" access="remote" returntype="Any" returnformat="JSON">
     <cfargument name="danceID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="dances">
                select id, workTitle, length, workLengthString, convert(varchar(16), premiereDate, 23) as premiereDate, premiereVenue, premiereString, premiereCity, premiereCountry, revivalYear, revivalLocation, revivalNotes, workImage, workImageNotes, description, capsuleURL, isCapsule, hasRevival, workCollab, workCollabSummary, workLargeImage, workLargeImageCredit, link, timeSearch, yearsSearch, premiereYear, composerSlugs, decorSlugs, costumerSlugs, lightingSlugs, mediaLink, includInPerfList 
                from tbl_Works

                WHERE     (id = #danceID#)
        </cfquery> 
		<cfset arrGirls = QueryToStruct(dances) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
	</cffunction>


    <cffunction name="getDances" access="remote" returntype="Any" returnformat="JSON">
		<cfquery datasource="merce_5" name="dances">
        SELECT     id, workTitle,premiereDate
        FROM         tbl_Works
        ORDER BY workTitle
        </cfquery> 
	 <cfset arrGirls = QueryToStruct(dances) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
	</cffunction>

    <cffunction name="insertOtherOverviewStub" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="mediaSummary_ID" type="any">
    <cfargument name="mediaType_ID" type="any">
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_OtherDetail
    (mediaType,mediaSummary_ID)
    values(
        #mediaType_ID#,
      #mediaSummary_ID#
      
          )
  </cfquery>
<cfreturn 1> 
</cffunction>

     <cffunction name="insertWritingOverviewStub" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="mediaSummary_ID" type="any">
    <cfargument name="mediaType_ID" type="any">
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_WritingDetail
    (mediaType,mediaSummary_ID)
    values(
        #mediaType_ID#,
      #mediaSummary_ID#
      
          )
  </cfquery>
<cfreturn 1> 
</cffunction>

    <cffunction name="insertArticleOverviewStub" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="mediaSummary_ID" type="any">
    <cfargument name="mediaType_ID" type="any">
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_ArticleDetail
    (mediaType_ID,mediaSummary_ID)
    values(
        #mediaType_ID#,
      #mediaSummary_ID#
      
          )
  </cfquery>
<cfreturn 1> 
</cffunction>


    <cffunction name="insertVideoOverviewStub" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="mediaSummary_ID" type="any">
    <cfargument name="mediaType_ID" type="any">
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_VideoDetail
    (summary_ID,mediaTypeID)
    values(
      #mediaSummary_ID#,
      #mediaType_ID#
          )
  </cfquery>
<cfreturn 1> 
</cffunction>

     <cffunction name="insertBookOverviewStub" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="mediaSummary_ID" type="any">
    <cfargument name="mediaType_ID" type="any">
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_BookDetail
    (mediaSummary_ID,mediaType_ID)
    values(
      #mediaSummary_ID#,
      #mediaType_ID#
          )
  </cfquery>
<cfreturn 1> 
</cffunction>

     <cffunction name="insertNewMediaOverview" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="mediaOverview" type="any" required="true">
        <cfset mediaOverview = DeserializeJSON(mediaOverview)>
        <cfif mediaOverview.publish EQ 'true'>
            <cfset mediaOverview.PUBLISH = 1>
        <cfelse>
            <cfset mediaOverview.PUBLISH = 0>
        </cfif>
            <cfquery name="insertNew" datasource="merce_5">
                    insert into tbl_MediaSummary
                    ( title, shortDescription, thumbNail, assetURL, yearText, publish,mediaType)
                values (
                    
                    '#mediaOverview.TITLE#',
               ' #mediaOverview.SHORTDESCRIPTION#',
                    '#mediaOverview.THUMBNAIL#',
                    '#mediaOverview.ASSETURL#',
                '#mediaOverview.YEARTEXT#',
                #mediaOverview.PUBLISH#,
                #mediaOverview.MEDIATYPE#
            
                )
                select @@identity as NEW_SUMMARY_ID
            </cfquery>
        <cfreturn insertNew>
    </cffunction>

    
    <cffunction name="getVideoTypes" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="videoTypes" datasource="merce_5">
            select id as data, videoType as label  from tbl_VideoTypes
        </cfquery>
                    <cfset arrGirls = QueryToStruct(videoTypes) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
    </cffunction>    

     <cffunction name="updateVideoDetails" access="remote" returnformat="JSON">
        <cfargument name="videoDetailObject" type="any">
        <cfset videoDetailObject = DeserializeJSON(videoDetailObject)>
        <cfquery name="update" datasource="merce_5">    
            update tbl_VideoDetail
            set  lengthString = '#videoDetailObject.LENGTHSTRING#',
            length = '#videoDetailObject.LENGTH#',
            colorBW =  '#videoDetailObject.COLORBW#',
           colorCode = #videoDetailObject.COLORCODE#,
            director = '#videoDetailObject.DIRECTOR#',
            producer = '#videoDetailObject.PRODUCER#',
            distributor = '#videoDetailObject.DISTRIBUTOR#',
            description = '#videoDetailObject.DESCRIPTION#',
            music = '#videoDetailObject.MUSIC#',
            musicians =  '#videoDetailObject.MUSICIANS#',
            summary_ID = #videoDetailObject.SUMMARY_ID#,
            mediaTypeID=  #videoDetailObject.MEDIATYPEID#,
            videoType = #videoDetailObject.VIDEOTYPE#
            where detail_ID = #videoDetailObject.DETAIL_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="updateArticleDetails" access="remote" returntype="any" returnformat="JSON"> 
        <cfargument name="articleDetailObject" type="any">
        <cfset articleDetailObject = DeserializeJSON(articleDetailObject)>
        <cfquery name="detail" datasource="merce_5">
            update tbl_ArticleDetail
            set author = '#articleDetailObject.AUTHOR#',
            publication = '#articleDetailObject.PUBLICATION#',
            description = '#articleDetailObject.DESCRIPTION#'
            where articleDetail_ID = #articleDetailObject.ARTICLEDETAIL_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

     <cffunction name="updateWritingDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="writingDetailObject" type="any">
        <cfset writingDetailObject = DeserializeJSON(writingDetailObject)>
        <cfquery name="detail" datasource="merce_5">
            update tbl_WritingDetail
            set text = '#writingDetailObject.TEXT#',
            description = '#writingDetailObject.DESCRIPTION#',
            publication = '#writingDetailObject.PUBLICATION#'
            where writingDetail_ID = #writingDetailObject.WRITINGDETAIL_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    
    <cffunction name="updateOtherDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="otherDetailsObject" type="any">
        <cfset otherDetailsObject = DeserializeJSON(otherDetailsObject)>
        <cfquery name="detail" datasource="merce_5">
            update tbl_OtherDetail
            set text = '#otherDetailsObject.TEXT#',
        description = '#otherDetailsObject.DESCRIPTION#',
        publication = '#otherDetailsObject.PUBLICATION#',
        author = '#otherDetailsObject.AUTHOR#'
        where otherDetail_ID = #otherDetailsObject.OTHERDETAIL_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="updateBookDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="bookDetailObject" type="any">
        <cfset bookDetailObject = DeserializeJSON(bookDetailObject)>
        <cfquery name="" datasource="merce_5">
            update tbl_BookDetail
            set author = '#bookDetailObject.AUTHOR#',
            publisher = '#bookDetailObject.PUBLISHER#',
            descriptions = '#bookDetailObject.DESCRIPTIONS#'
            where bookdetail_ID = #bookDetailObject.BOOKDETAIL_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

     <cffunction name="getOtherDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="summaryID" type="numeric">
        <cfquery name="writing" datasource="merce_5">
            select * from tbl_OtherDetail
            where mediaSummary_ID = #summaryID# 
        </cfquery>
         <cfset arrGirls = QueryToStruct(writing) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getArticleDetails" access="remote" returntype="any"  returnformat="JSON">
        <cfargument name="summaryID" type="numeric">
        <cfquery name="article" datasource="merce_5">
            select * from tbl_ArticleDetail
            where mediaSummary_ID = #summaryID# 
        </cfquery>
        <cfset arrGirls = QueryToStruct(article) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="getWritingDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="summaryID" type="numeric">
        <cfquery name="writing" datasource="merce_5">
            select * from tbl_WritingDetail
            where mediaSummary_ID = #summaryID# 
        </cfquery>
         <cfset arrGirls = QueryToStruct(writing) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>


    <cffunction name="updateMediaOverview" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="mediaOverview" type="any" required="true">
        <cfset mediaOverview = DeserializeJSON(mediaOverview)>
            <cfif mediaOverview.PUBLISH EQ 'true'>
                <cfset mediaOverview.PUBLISH = 1>
               <cfelse>
                <cfset mediaOverview.PUBLISH = 0>
            </cfif>
            <cfquery name="update" datasource="merce_5">
                update tbl_MediaSummary
                set shortDescription = '#mediaOverview.SHORTDESCRIPTION#',
                title = '#mediaOverview.TITLE#',
                thumbNail = '#mediaOverview.THUMBNAIL#',
                mediaType = #mediaOverview.MEDIATYPE#,
                yearText = '#mediaOverview.YEARTEXT#',
                assetURL = '#mediaOverview.ASSETURL#',
                link = '#mediaOverview.LINK#',
                publish = #mediaOverview.PUBLISH#,
                thumbnailCredit = '#mediaOverview.THUMBNAILCREDIT#'
                
                where id = #mediaOverview.ID#
            </cfquery>
        <cfreturn 1>
    </cffunction>
        
            <cffunction name="getColorTypes" access="remote" returntype="any" returnformat="JSON">
                <cfquery name="colorTypes" datasource="merce_5">
                    select * from tbl_ColorTypes
                </cfquery>
                         <cfset arrGirls = QueryToStruct(colorTypes) />
                    <cfset objectWrapper = structNew()>
                    <cfset objectWrapper.results = #arrGirls#>
                    <cfreturn objectWrapper> 
            </cffunction>

        
        <cffunction name="getVideoDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="summary_ID" type="numeric">
        <cfquery name="detail" datasource="merce_5">
            select * from tbl_VideoDetail
            where summary_ID = #summary_ID#
        </cfquery>
         <cfset arrGirls = QueryToStruct(detail) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getBookDetails" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="summaryID" type="numeric">
        <cfquery name="book" datasource="merce_5">
            select * from tbl_BookDetail
            where mediaSummary_ID = #summaryID# 
        </cfquery>
        <cfset arrGirls = QueryToStruct(book) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>


        <cffunction name="getMediaLabel" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="numeric">
        <cfquery name="label" datasource="merce_5">
            select mediaType from tbl_MediaTypes
            where id = #id#
        </cfquery>
         <cfset arrGirls = QueryToStruct(label) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

      <cffunction name="deleteDistRecord" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="numeric">
        <cfquery name="delete" datasource="merce_5">
            delete from tbl_Media_Distributor
            where id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction>
      

    <cffunction name="updateDistributorRecord" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="selectedDistributorObject" type="any">
           <cfset selectedDistributorObject = DeserializeJSON(selectedDistributorObject)>
        <cfquery name="insert" datasource="merce_5">
           update tbl_Media_Distributor
           set 
            mediaObject = #selectedDistributorObject.MEDIAOBJECT#,
             distributorName = '#selectedDistributorObject.DISTRIBUTORNAME#',
           distibutorLink = '#selectedDistributorObject.DISTIBUTORLINK#'
           where id = #selectedDistributorObject.ID#
           
        </cfquery>
        <cfreturn 1>
    </cffunction>

     <cffunction name="addDistributorRecord" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="selectedDistributorObject" type="any">
         <cfset selectedDistributorObject = DeserializeJSON(selectedDistributorObject)>
        <cfquery name="insert" datasource="merce_5">
            insert into tbl_Media_Distributor(
            mediaObject,
            distributorName,
            distibutorLink)
            values (
            #selectedDistributorObject.MEDIAOBJECT#,
            '#selectedDistributorObject.DISTRIBUTORNAME#',
            '#selectedDistributorObject.DISTIBUTORLINK#'
            )
            select @@identity as newID
        </cfquery>
          <cfset arrGirls = QueryToStruct(insert) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

         <cffunction name="getDistributorObject" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="numeric">
        <cfquery name="dist" datasource="merce_5">
            select * from tbl_Media_Distributor
            where id =#id#
        </cfquery>
         <cfset arrGirls = QueryToStruct(dist) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

       <cffunction name="getDistributorsForMedia" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="mediaID" type="numeric">
        <cfquery name="dist" datasource="merce_5">
            select * from tbl_Media_Distributor
            where mediaObject = #mediaID#
        </cfquery>
         <cfset arrGirls = QueryToStruct(dist) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="getMediaOverview" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="media" type="numeric" required="true">
        <cfquery name="media" datasource="merce_5">
            select tbl_MediaSummary.id, tbl_MediaSummary.mediaType as mediaTypeID,title,publish, tbl_MediaTypes.mediaType
            from tbl_MediaSummary inner join tbl_MediaTypes on tbl_MediaSummary.mediaType = tbl_MediaTypes.id
            <cfif media GT 0>
            where   tbl_MediaSummary.mediaType = #media#
            </cfif>
            order by title
        </cfquery>
        <cfset arrGirls = QueryToStruct(media) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>
   
        <cffunction name="getMediaOverviewDetail" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="numeric" required="true">
            <cfquery name="overviewDetail" datasource="merce_5">
                select * from tbl_MediaSummary
                where id = #id#
            </cfquery>
         <cfset arrGirls = QueryToStruct(overviewDetail) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="getMediaTypes" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="mediaTypes" datasource="merce_5">
            select id, mediaType from tbl_MediaTypes
            where id  <> 4
        </cfquery>
        <cfset arrGirls = QueryToStruct(mediaTypes) />
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper> 
    </cffunction>

    <cffunction name="getSelectedExperience" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="id" type="any" >
    <cfquery name="queryName" datasource="merce_5">
        select experienceText,experienceYear,id
        from tbl_FellowExperience
        where id = #id#
  </cfquery>
<cfset arrGirls = QueryToStruct(queryName) />
<cfset objectWrapper = structNew()>
<cfset objectWrapper.results = #arrGirls#>
<cfreturn objectWrapper> 
</cffunction>

    <cffunction name="insertNewPerson" access="remote" returntype="any"  returnformat="JSON">
        <cfargument name="person" type="any">
         <cfset person = DeserializeJSON(person)>
        <cfif person.active EQ 'true'>
            <cfset person.active = 1>
        <cfelse>
            <cfset person.active = 0>
        </cfif>
        <cfquery name="newPerson" datasource="merce_5">
            insert into tbl_People (
                 <cfif StructKeyExists(person, "YEARSTRING")>
                yearsString, 
                </cfif>
                fellowName,  
                text,  
                personType,
                active,
                moreBio,
                status,
                classsTeacherImage)
            values (
              <cfif StructKeyExists(person, "YEARSTRING")>
               '#person.YEARSTRING#',
            </cfif>    
            '#person.FELLOWNAME#',
            '#person.TEXT#',
            #person.PERSONTYPE#,
            #person.ACTIVE#,
            '#person.MOREBIO#',
            '#person.STATUS#',
            '#person.CLASSSTEACHERIMAGE#'
            )
            select @@identity
        </cfquery>
    <cfset arrGirls = QueryToStruct(newPerson) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper>
    </cffunction>


    

    <cffunction name="getExperience" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="any">
        <cfquery name="experience" datasource="merce_5">
            select * from tbl_FellowExperience
            where fellowID = #id#
        </cfquery>
         <cfset arrGirls = QueryToStruct(experience) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper>
    </cffunction>

     <cffunction name="updatePerson" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="person" type="any">
         <cfset person = DeserializeJSON(person)>
        <cfif person.ACTIVE EQ 'true'>
            <cfset person.ACTIVE = 1>
            <cfelse>
            <cfset person.ACTIVE = 0>
        </cfif>
        <cfquery name="" datasource="merce_5">
            update tbl_People
            set yearsString = '#person.YEARSSTRING#',
            fellowName = '#person.FELLOWNAME#',
            text = '#person.TEXT#',
            personType = #person.PERSONTYPE#,
            active = #person.ACTIVE#,
            moreBio = '#person.MOREBIO#',
            status = '#person.STATUS#',
            classsTeacherImage = '#person.CLASSSTEACHERIMAGE#'
            where id = #person.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>
    
    <cffunction name="getTeachers" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="thisQuery" datasource="merce_5">
           select id,fellowName from tbl_People
            where personType = 4
            order by fellowName
        </cfquery>
        <cfset arrGirls = QueryToStruct(thisQuery) />
            <cfset objectWrapper = structNew()>
            <cfset objectWrapper.results = #arrGirls#>
            <cfreturn objectWrapper> 
        </cffunction>

     <cffunction name="getPeopleTypes" access="remote" returntype="Any" returnformat="JSON">
    <cfquery name="queryName" datasource="merce_5">
        select id as data, type as label
        from tbl_PeopleTypes
    </cfquery>
    <cfset arrGirls = QueryToStruct(queryName) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper> 
    </cffunction>

        <cffunction name="insertNewExperience" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="experienceObject" type="any" >
     <cfset experienceObject = DeserializeJSON(experienceObject)>
    <cfquery name="queryName" datasource="merce_5">
            insert into tbl_FellowExperience
            (experienceText, 
            experienceYear,
            fellowID)
            values
            (
            '#experienceObject.EXPERIENCETEXT#',
            '#experienceObject.EXPERIENCEYEAR#',
            #experienceObject.FELLOWID#
            )
  </cfquery>
<cfreturn 1> 
</cffunction>

 <cffunction name="updateExperience" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="experienceObject" type="any" >
     <cfset experienceObject = DeserializeJSON(experienceObject)>
    <cfquery name="queryName" datasource="merce_5">
            update tbl_FellowExperience
            set experienceYear = '#experienceObject.EXPERIENCEYEAR#',
            experienceText = '#experienceObject.EXPERIENCETEXT#'
            where id = #experienceObject.ID#
  </cfquery>
<cfreturn 1> 
</cffunction>

     <cffunction name="deleteExperience" access="remote" returntype="Any" returnformat="JSON">
                <cfargument name="id" type="any" >
    <cfquery name="queryName" datasource="merce_5">
       delete from tbl_FellowExperience
        where id = #id#
  </cfquery>
<cfreturn 1> 
     </cffunction> 


    <cffunction name="getFellow" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="any" required="true">
        <cfquery name="fellow" datasource="merce_5">
            select * from tbl_People
            where id = #id#
        </cfquery>
       <cfset arrGirls = QueryToStruct(fellow) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper>
    </cffunction>

    <cffunction name="getPeople" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="personType" type="any" required="true">
        <cfquery name="people" datasource="merce_5">
             select tbl_People.id, yearsString, fellowName, text, mainImage, smallImage, cast(active as bit) as active,personType, mainImageCredit,moreBio,status,tbl_PeopleTypes.type from tbl_People
                inner join tbl_PeopleTypes on personType = tbl_PeopleTypes.id
            where personType = #personType#
        </cfquery>
       <cfset arrGirls = QueryToStruct(people) />
    <cfset objectWrapper = structNew()>
    <cfset objectWrapper.results = #arrGirls#>
    <cfreturn objectWrapper> 
    </cffunction>

     <cffunction name="deleteEvent" access="remote" returntype="any" >  
            <cfargument name=ID>
            <cfquery name="delete" datasource="merce_5">
                delete from tbl_Events
                where ID = #ID#
            </cfquery>
            <cfreturn 1>
     </cffunction>     

     <cffunction name="createNewEvent" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="eventObject" type="any">
      <cfset eventObject = DeserializeJSON(eventObject)>
        <cfif eventObject.EVENTPUBLISH EQ 'true'>
            <cfset eventObject.EVENTPUBLISH = 1>
            <cfelse>
            <cfset eventObject.EVENTPUBLISH = 0>
        </cfif>
    <cfquery datasource="merce_5" name="newEvent">
    	INSERT INTO dbo.tbl_Events
        ( eventName ,
          eventType ,
          eventStartDate ,
          eventEndDate ,
          eventDateString ,
          eventDescription ,
          eventLocation ,
          eventPublish,
          eventWeb,
         eventImage,
           
        eventImageCredit,
        displayOrder
        

        )
VALUES  ( 
          
          '#eventObject.EVENTNAME#' ,
           #eventObject.EVENTTYPE# ,
          '#eventObject.EVENTSTARTDATE#' ,
          '#eventObject.EVENTENDDATE#',
          '#eventObject.EVENTDATESTRING#' ,
          '#eventObject.EVENTDESCRIPTION#' ,
          '#eventObject.EVENTLOCATION#',
          #eventObject.EVENTPUBLISH#,
         '#eventObject.EVENTWEB#',
        '#eventObject.EVENTIMAGE#',
        '#eventObject.eventImageCredit#',
        #eventObject.DISPLAYORDER#
)
        
         select @@identity
    </cfquery>
   <cfset arrGirls = QueryToStruct(newEvent)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>    
    
     <cffunction name="updateEvent" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="eventObject" type="any">
     <cfset eventObject = DeserializeJSON(eventObject)>
     <cfif eventObject.EVENTPUBLISH EQ 'true'>
           <cfset eventObject.EVENTPUBLISH = 1> 
     <cfelse>
            <cfset eventObject.EVENTPUBLISH = 0> 
     </cfif>
      <cfif eventObject.DISPLAYORDER eq ''>
          <cfset eventObject.DISPLAYORDER = 0>
      </cfif>  
    <cfquery datasource="merce_5" name="updatedEvent">
		UPDATE dbo.tbl_Events
				SET eventName = '#eventObject.EVENTNAME#' ,
          eventType = #eventObject.EVENTTYPE# ,
          eventStartDate = '#eventObject.EVENTSTARTDATE#' ,
          eventEndDate = '#eventObject.EVENTENDDATE#',
          eventDateString = '#eventObject.EVENTDATESTRING#' ,
          eventDescription = '#eventObject.EVENTDESCRIPTION#' ,
          eventLocation = '#eventObject.EVENTLOCATION#',
          eventPublish = #eventObject.EVENTPUBLISH#,
          eventWeb = '#eventObject.EVENTWEB#',
          eventImage = '#eventObject.EVENTIMAGE#',
        eventImageCredit = '#eventObject.EVENTIMAGECREDIT#',
         displayOrder = #eventObject.DISPLAYORDER#
       
        
         
         
          WHERE ID = #eventObject.ID#
    </cfquery>
    <cfreturn 1>
    </cffunction>

        <cffunction name="getSpecificEvent" access="remote" returntype="any" returnformat="JSON">
      <cfargument name="event_ID" type="numeric" required="yes">
    <cfquery datasource="merce_5" name="event">
 SELECT     tbl_Events.id, tbl_Events.eventName, tbl_EventType.eventType AS TypeLabel, tbl_Events.eventType, 
 convert(varchar(16), eventStartDate, 23) as eventStartDate,
     convert(varchar(16), eventEndDate, 23) as eventEndDate,
                      tbl_Events.eventDateString, tbl_Events.eventDescription, tbl_Events.eventLocation, tbl_Events.eventWeb, tbl_EventPublishTypes.eventPublishLabel, 
                      tbl_Events.eventPublish, tbl_Events.eventImage,tbl_Events.centennial,tbl_Events.displayOrder,tbl_Events.eventImageCredit,tbl_Events.eventPostDate, tbl_Events.month, tbl_Events.monthEnd
FROM         tbl_Events INNER JOIN
                      tbl_EventType ON tbl_Events.eventType = tbl_EventType.id INNER JOIN
                      tbl_EventPublishTypes ON tbl_Events.eventPublish = tbl_EventPublishTypes.eventPublish
                      WHERE     tbl_Events.id = #event_ID#
    </cfquery>
     <cfset arrGirls = QueryToStruct(event)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
   </cffunction>

    <cffunction name="getEventTypes" access="remote" returntype="any" returnformat="JSON">
   <cfquery datasource="merce_5" name="eventTypes">
   SELECT     id AS data, eventType AS label
        FROM         tbl_EventType
   </cfquery>
   <cfset arrGirls = QueryToStruct(eventTypes)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
   </cffunction> 

        <cffunction name="getCurrentEvents" access="remote" returntype="any" returnformat="JSON">
    <cfquery datasource="merce_5" name="events">
       SELECT     tbl_Events.id, tbl_Events.eventName, tbl_Events.eventType,
    convert(varchar(16), tbl_Events.eventStartDate, 107) as eventStartDate,
    convert(varchar(16), tbl_Events.eventEndDate, 107) as eventEndDate, tbl_Events.eventDateString,
                      tbl_Events.eventDescription, tbl_Events.eventLocation, tbl_Events.eventWeb,tbl_Events.eventPublish, tbl_Events.displayOrder, tbl_Events.month
FROM         tbl_Events
WHERE     (tbl_Events.eventEndDate > GETDATE())
    </cfquery>
     <cfset arrGirls = QueryToStruct(events)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

    <cffunction name="editPromo" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="promoObject" type="any">
        <cfset promoObject = DeserializeJSON(promoObject)>
        <cfquery name="promo" datasource="merce_5">
            update tbl_PromoBar
            set message = '#promoObject.MESSAGE#',
            link = '#promoObject.LINK#'
            where id = 1
        </cfquery>
        <cfreturn 1>
    </cffunction>

  

      <cffunction name="getPromoPost" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="post" datasource="merce_5">
            select * from tbl_PromoBar
            where id  =  1
        </cfquery>
       <cfset arrGirls = QueryToStruct(post)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

     <cffunction name="checkSecure" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="email" type="any">
        <cfargument name="pword" type="any">
        <cfquery name="queryName" datasource="merce_5">
            select email
            from tbl_security
            where pword = '#pword#' and email = '#email#'
        </cfquery>
        <cfset arrGirls = QueryToStruct(queryName)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

        <cffunction name="logInUser" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="user" type="any">
        <cfquery name="queryName" datasource="merce_5">
            insert into tbl_userLogs
            (userEmail)
            values(
            '#user#')
        </cfquery>
        <cfreturn 1>
    </cffunction>

   

    <cffunction name="getProductions" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="timeSearch" type="any" default="all">
          <cfargument name="dance" type="any" default="0">
          <cfargument name="country" type="any" default="all">
          <cfargument name="city" type="any" default="all">
          <cfargument name="company" type="any" default="all">
        <cfquery name="productions" datasource="merce_5">
            <cfif dance NEQ 999>
            select distinct datetext,country,city,company,code,dance,[years-search],venue,[date-real]
            from tbl_perf_history inner join tbl_Production_Dance on tbl_perf_history.[perf-id] = tbl_Production_Dance.[perf-id]
            where 1=1
            <cfif timeSearch NEQ 'all'>
                AND [years-search] = '#timeSearch#'
            </cfif>
            <cfif dance NEQ 0>
                and tbl_Production_Dance.workID = #dance#
            </cfif>
    
            <cfif country NEQ 'all'>
                and country = '#country#'
            </cfif>
             <cfif city NEQ 'all'>
                and charindex('#city#',city) > 0
            </cfif>
             <cfif company NEQ 'all'>
                and charindex('#company#',company) > 0
            </cfif>
           order by [date-real]
        <cfelse>
            select distinct datetext,country,city,company,code,dance,[years-search],venue,[date-real]
            from tbl_perf_history 
            where code = 'E'
            <cfif timeSearch NEQ 'all'>
                AND [years-search] = '#timeSearch#'
            </cfif>
           
    
            <cfif country NEQ 'all'>
                and country = '#country#'
            </cfif>
             <cfif city NEQ 'all'>
                and charindex('#city#',city) > 0
            </cfif>
             <cfif company NEQ 'all'>
                and charindex('#company#',company) > 0
            </cfif>
           order by [date-real]
              </cfif>  
        </cfquery>
      
        <cfreturn productions>
    </cffunction>

     <cffunction name="productionCities" access="remote" returntype="Any" returnformat="JSON">
        <cfargument name="timeSearch" type="any" default="all">
         <cfargument name="country" type="any" default="all">
        <cfquery name="cities" datasource="merce_5">
                select distinct ltrim(city) as city from tbl_perf_history
                where 1=1
                <cfif timeSearch NEQ'all'>
                    and  [years-search] = '#timeSearch#'
                </cfif>
                <cfif country NEQ'all'>
                    and  country = '#country#'
                </cfif>
                order by city
            </cfquery>
       <cfset jsonData = SerializeJson(cities,"struct")>
        <cfreturn jsonData>
        </cffunction>



    <cffunction name="aaPostStreamMessage" access="remote" returntype="Any">
        <cfargument name="message" type="any" >
        <cfquery name="queryName" datasource="merce_5">
            update tbl_StreamMessage
            set message = '#message#'
        where id = 1
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="aaStreamLive" access="remote" returntype="any">
    <cfargument name="live" type="any">
        <cfif live EQ 'true'>
            <cfset live = 1>
        <cfelse>
            <cfset live = 0>
        </cfif>
    <cfquery name="query" datasource="merce_5">
        update tbl_StreamMessage
        set live = #live#
        where id = 1
    </cfquery>
    <cfreturn 1>
</cffunction>


    <cffunction name="getOnThisDayAssetTypes" access="remote" returntype="any">
        <cfquery name="types" datasource="merce_5">
            select id as data, assetType as label from tbl_OnThisDayAssetType
        </cfquery>
        <cfreturn types>
    </cffunction>

    

    <cffunction name="getAllPromoPosts" access="remote" returntype="any">
        <cfquery name="promo" datasource="merce_5">
            select * from tbl_PromoBar
        </cfquery>
        <cfreturn promo>
    </cffunction>

 


    <cffunction name="insertNewMemory" access="remote" returntype="any">
        <cfargument name="memory" type="any" required="true">
        <cfif memory.publish EQ 'true'>
            <cfset memory.publish = 1>
        <cfelse>
            <cfset memory.publish = 0>
        </cfif>
        <cfquery name="newMemory" datasource="merce_5">
            insert into tbl_Remember (image, name, email, message, link, publish, headline,localVideo)
            values
            (
             '#memory.image#',
            '#memory.name#',
            '#memory.email#',
            '#memory.message#',
            '#memory.link#',
            #memory.publish#,
            '#memory.headline#',
            '#memory.localVideo#'
            )
            select @@identity

        </cfquery>
        <cfreturn memory>
    </cffunction>

    <cffunction name="updateMemory" access="remote" returntype="any">
        <cfargument name="memory" type="any">
        <cfif memory.publish EQ 'true'>
            <cfset memory.publish = 1>
            <cfelse>
            <cfset memory.publish = 0>
        </cfif>
        <cfquery name="memory" datasource="merce_5">
            update tbl_Remember
            set publish = #memory.publish#,
            image = '#memory.image#',
            name = '#memory.name#',
            email = '#memory.email#',
            message = '#memory.message#',
            link = '#memory.link#',
            headline = '#memory.headline#',
            localVideo = '#memory.localVideo#'
            where id = #memory.id#
        </cfquery>
        <cfreturn 1>
    </cffunction>



    <cffunction name="getMemory" access="remote" returntype="any">
        <cfargument name="id" type="any">
        <cfquery name="memory" datasource="merce_5">
            select * from tbl_Remember
            where id = #id#
        </cfquery>
        <cfreturn memory>
    </cffunction>


    <cffunction name="getAllMemories" access="remote" returntype="any">

        <cfquery name="memories" datasource="merce_5">
            select * from tbl_Remember
        </cfquery>
        <cfreturn memories>
    </cffunction>


    <cffunction name="saveMessageEdits" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="messageObject" type="any">
        <cfset messageObject = DeserializeJSON(messageObject)>
        <cfquery name="query" datasource="merce_5">
            update tbl_ClassMessages
            set rate = '#messageObject.RATE#'
            where id = 1
            select 1
        </cfquery>
       <cfset arrGirls = QueryToStruct(query)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>


    <cffunction name="getClassMessages" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="messages" datasource="merce_5">
            select * from tbl_ClassMessages
            where id = 1
        </cfquery>
        <cfset arrGirls = QueryToStruct(messages)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>
    
     <cffunction name="deleteClass" access="remote" returntype="Any" returnformat="JSON">
    <cfargument name="id" type="any" >
    <cfquery name="queryName" datasource="merce_5">
        delete from tbl_Classes
        where id = #id#

  </cfquery>
</cffunction>
    
    <cffunction name="insertNewClass" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="classObject" type="any">
        <cfset classObject = DeserializeJSON(classObject)>
        <cfset setWeek = #week(classObject.classDate)#>
        <cfquery name="newClass" datasource="merce_5">
            insert into tbl_Classes
            (classType, classDate, classDateTimeString, classTitle, classLocation, classTeacher,week,classTeacherID)
            values
            (#classObject.CLASSTYPEID#,'#classObject.CLASSDATE#','#classObject.CLASSDATETIMESTRING#','#classObject.CLASSTITLE#','#classObject.CLASSLOCATION#','#classObject.CLASSTEACHER#',#setWeek#,#classObject.CLASSTEACHERID#
            )
        select @@IDENTITY
        </cfquery>
        <cfreturn newClass>
    </cffunction>

   
    <cffunction name="getClass" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="id" type="any" required="true">
        <cfquery name="merceClass" datasource="merce_5">
            select week,convert(varchar(16), classDate, 23) as classDate,tbl_Classes.id,classDateTimeString,classLocation,classTeacher,classTitle,tbl_ClassTypes.classType,tbl_Classes.classTeacherID,tbl_People.fellowName,tbl_Classes.classType as classTypeID
            from tbl_Classes inner join tbl_ClassTypes
            on tbl_Classes.classType = tbl_ClassTypes.id left outer join tbl_People on tbl_People.id = tbl_Classes.classTeacherID
            where tbl_Classes.id =#id#
        </cfquery>
        <cfset arrGirls = QueryToStruct(merceClass)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

    <cffunction name="getClasses" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="current" type="any" default="true">
        <cfset thisDate = #now()#>
        <cfset thisWeek = #Week(thisDate)#>
        <cfset nextWeek = thisWeek + 1>
        <cfset current = true>
        <cfquery name="classes" datasource="merce_5">
            select tbl_Classes.id, week,convert(varchar(16), classDate, 107) as classDate,classDateTimeString,classLocation,classTeacher,classTitle,tbl_ClassTypes.classType,tbl_Classes.classType as classTypeID  from tbl_Classes inner join tbl_ClassTypes
            on tbl_Classes.classType = tbl_ClassTypes.id
            <cfif current>
                
                where (week= #thisWeek# OR week=#nextWeek#) AND classDate > DATEADD(DAY, -7, GETDATE())
                
                </cfif>
            
     
            order by week,classDate
            
        </cfquery>
        <cfset arrGirls = QueryToStruct(classes)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

    <cffunction name="getClassTypes" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="classTypes" datasource="merce_5">
            select id, classType from tbl_ClassTypes
        </cfquery>
        <cfset arrGirls = QueryToStruct(classTypes)/>
        <cfset objectWrapper = structNew()>
        <cfset objectWrapper.results = #arrGirls#>
        <cfreturn objectWrapper>
    </cffunction>

     <cffunction name="updateClass" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="classObject" type="any">
        <cfset classObject = DeserializeJSON(classObject)>
        <cfset setWeek = #week(classObject.CLASSDATE)#>
        <cfquery name="query" datasource="merce_5">
            update tbl_Classes
            set classType = #classObject.CLASSTYPEID#,
            classDate = '#classObject.CLASSDATE#',
            classTeacher = '#classObject.CLASSTEACHER#',
            classTitle = '#classObject.CLASSTITLE#',
            classDateTimeString = '#classObject.CLASSDATETIMESTRING#',
            classLocation = '#classObject.CLASSLOCATION#',
            week = #setWeek#,
            classTeacherID = #classObject.CLASSTEACHERID#
            where id = #classObject.ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>

    

    

    <cffunction name="getExperienceForPerson" access="remote" returntype="any">
        <cfargument name="id" type="any">
        <cfquery name="exp" datasource="merce_5">
            select * from tbl_FellowExperience
            where fellowID = #id#
        </cfquery>
        <cfreturn exp>
    </cffunction>

   

    

    

    

    


   

    <cffunction name="insertNewDocDetail" access="remote" returntype="any">
        <cfargument name="docDetail" type="any">
        <cfquery name="newDetail" datasource="merce_5">
            insert into tbl_DocumentaryDetail(
            mediaType,
            mediaSummary_ID,
            lengthString,
            length,
            colorBW,
            director,
            producer,
            distributor,
            description,
            colorCode)
            values (
            #docDetail.mediaType#,
            #docDetail.mediaSummary_ID#,
            '#docDetail.lengthString#',
            #docDetail.length#,
            '#docDetail.colorBW#',
            '#docDetail.director#',
            '#docDetail.producer#',
            '#docDetail.distributor#',
            '#docDetail.description#',
            #docDetail.colorCode#
            )
            select @@identity as newDetailID;
        </cfquery>
        <cfreturn newDetail>
    </cffunction>

    <cffunction name="updateDocDetail" access="remote" returntype="any">
        <cfargument name="docDetail" type="any">
        <cfquery name="doc" datasource="merce_5">
            update tbl_DocumentaryDetail
            set lengthString = '#docDetail.lengthString#',
            length = #docDetail.length#,
            colorBW = '#docDetail.colorBW#',
            colorCode = #docDetail.colorCode#,
            director = '#docDetail.director#',
            producer = '#docDetail.producer#',
            distributor = '#docDetail.distributor#',
            description = '#docDetail.description#'
            where docDetail_ID = #docDetail.docDetail_ID#
        </cfquery>
        <cfreturn 1>
    </cffunction>


    <cffunction name="getDocDetail" access="remote" returntype="any">
        <cfargument name="summaryID" type="numeric" required="true">
        <cfargument name="mediaType" type="numeric" required="true">
         <cfquery name="doc" datasource="merce_5">
            select * from tbl_DocumentaryDetail
             where mediaSummary_ID = #summaryID# AND mediaType = #mediaType#
        </cfquery>
        <cfreturn doc>
    </cffunction>


    <cffunction name="insertNewOnThisDay" access="remote" returntype="any">
        <cfargument name="day" type="any" required="true">
        <cfquery name="newDay" datasource="merce_5">
            insert into tbl_OnThisDay (
            introText,
            mainText,
            dateString,
            image,
            displayDate,
            videoImage)
            values
            (
            '#day.introText#',
            '#day.mainText#',
            '#day.dateString#',
            '#day.image#',
            #day.displayDate#,
            #day.videoImage#
            )
            select @@identity
        </cfquery>
        <cfreturn newDay>
    </cffunction>


    <cffunction name="updateOnThisDay" access="remote" returntype="any">
        <cfargument name="day" type="any">
        <cfquery name="newDay" datasource="merce_5">
            update tbl_OnThisDay
            set introText = '#day.introText#',
            mainText = '#day.mainText#',
            image = '#day.image#',
            dateString = '#day.dateString#',
            displayDate = #day.displayDate#,
            videoImage = #day.videoImage#
            where id = #day.id#
        </cfquery>
        <cfreturn 1>
    </cffunction>


    <cffunction name="getOnThisDay" access="remote" returntype="any">
        <cfargument name="id" type="any" required="true">
        <cfquery name="day" datasource="merce_5">
            SELECT dateString, date, id, introText, mainText,image, videoImage, displayDate from tbl_OnThisDay
            where id = #id#
        </cfquery>
        <cfreturn day>
    </cffunction>


    <cffunction name="getAllOnThisDay" access="remote" returntype="any">
        <cfquery name="days" datasource="merce_5">
            SELECT dateString, date, id, introText, mainText,image,displayDate from tbl_OnThisDay
            order by displayDate asc 
        </cfquery>
        <cfreturn days>
    </cffunction>

    <cffunction name="getHonors" access="remote" returntype="any">
        <cfargument name="honorTarget" type="int">
        <cfquery name="honors" datasource="merce_5">

            select * from tbl_Honors
            <cfif honorTarget EQ 50>
                where dateString > 1949 AND datestring < 1961
            <cfelseif honorTarget EQ 60>
                where dateString > 1959 AND datestring < 1971
                <cfelseif honorTarget EQ 70>
                where dateString > 1969 AND datestring < 1981
                <cfelseif honorTarget EQ 80>
                where dateString > 1979 AND datestring < 1991
                <cfelseif honorTarget EQ 90>
                where dateString > 1989 AND datestring < 2001
                <cfelseif honorTarget EQ 00>
                where dateString > 1999 AND datestring < 2010
            </cfif>
        </cfquery>
        <cfreturn honors>
    </cffunction>


    <cffunction name="insertNewWritingDetail" access="remote" returntype="any">
        <cfargument name="detail" type="any">
        <cfquery name="newDetail" datasource="merce_5">
            insert into tbl_WritingDetail (
            mediaType,
            mediaSummary_ID,
            text,
            description,
            publication) values
            (
            #detail.mediaType#,
            #detail.mediaSummary_ID#,
            '#detail.text#',
            '#detail.description#',
            '#detail.publication#'
            )
            select @@identity as newID

        </cfquery>
        <cfreturn newDetail>
    </cffunction>

    <cffunction name="insertNewOtherDetail" access="remote" returntype="any">
        <cfargument name="detail" type="any">
        <cfquery name="newDetail" datasource="merce_5">
            insert into tbl_OtherDetail (
            mediaType,
            mediaSummary_ID,
            text,
            description,
            publication,
            author) values
            (
            #detail.mediaType#,
            #detail.mediaSummary_ID#,
        '#detail.text#',
        '#detail.description#',
        '#detail.publication#',
            '#detail.author#'
        )
        select @@identity as newID

        </cfquery>
        <cfreturn newDetail>
    </cffunction>

   



   

   

    <cffunction name="insertNewArticleDetails" access="remote" returntype="any">
        <cfargument name="detail" type="any">
        <cfquery name="newDetail" datasource="merce_5">
            insert into tbl_ArticleDetail
            (author,
            publication,
            description,
            mediaType_ID,
            mediaSummary_ID)
            values (
            '#detail.author#',
            '#detail.publication#',
            '#detail.description#',
            #detail.mediaType_ID#,
            #detail.mediaSummary_ID#
            )
            select @@identity as newID;
        </cfquery>
        <cfreturn newDetail>
    </cffunction>

    

    


    


    <cffunction name="insertNewBookDetail" access="remote" returntype="any">
        <cfargument name="bookDetail" type="any">
        <cfquery name="bookDetail" datasource="merce_5">
            insert into tbl_BookDetail(
            author,
            publisher,
            descriptions,
            mediaType_ID,
            mediaSummary_ID)
            values(
            '#bookDetail.author#',
            '#bookDetail.publisher#',
            '#bookDetail.descriptions#',
            #bookDetail.mediaType_ID#,
            #bookDetail.mediaSummary_ID#
            )
            select @@identity as newDetailID
        </cfquery>
        <cfreturn bookDetail>
    </cffunction>

    

   

    <cffunction name="insertVideoDetails" access="remote" returntype="any">
        <cfargument name="videoDetail" type="any">
        <cfquery name="update" datasource="merce_5">
            insert into tbl_VideoDetail(
            lengthString,
            length,
            colorBW,
            director,
            producer,
            distributor,
            description,
            music,
            musicians,
            summary_ID,
            mediaTypeID,
            colorCode)
            values(
                '#videoDetail.lengthString#',
                '#videoDetail.length#',
                '#videoDetail.colorBW#',
                '#videoDetail.director#',
                '#videoDetail.producer#',
                '#videoDetail.distributor#',
                '#videoDetail.description#',
                '#videoDetail.music#',
                '#videoDetail.musicians#',
                #videoDetail.summary_ID#,
                #videoDetail.mediaTypeID#,
                #videoDetail.colorCode#
            )
            select @@IDENTITY as newDetailID
        </cfquery>
        <cfreturn update>
    </cffunction>

    <cffunction name="getVideoDetail" access="remote" returntype="any">
        <cfargument name="summaryID" type="numeric">
        <cfargument name="mediaType" type="numeric">
        <cfquery name="videoDetails" datasource="merce_5">
            select * from tbl_VideoDetail
            where summary_ID = #summaryID# AND mediaTypeID = #mediaType#
        </cfquery>
        <cfreturn videoDetails>
    </cffunction>


   
    


    




    

   





   
    
    
    <cffunction name="getAllNews" access="remote" returntype="any">
        <cfquery name="allNews" datasource="merce_5">
            select * from tbl_CentennialNews
order by rank
        </cfquery>
        <cfreturn allnews>
    </cffunction>
    
    
     <cffunction name="getNewsItem" access="remote" returntype="any">
        <cfargument name="id" type="numeric" required="true">
        <cfquery name="allNews" datasource="merce_5">
            select * from tbl_CentennialNews
                where id = #id#
        </cfquery>
        <cfreturn allnews>
    </cffunction>
    
    <cffunction name="deleteCentEvent" access="remote" returntype="any">
        <cfargument name="id" type="numeric" required="true">
        <cfquery name="allNews" datasource="merce_5">
                delete from tbl_CentennialNews
                where id = #id#
        </cfquery>
        <cfreturn 1>
    </cffunction>
    
     <cffunction name="createNewsItemEdit" access="remote" returntype="any">
        <cfargument name="news" type="any" required="true">
        <cfif news.publish EQ 'true'>
            <cfset news.publish = 1>
            <cfelse>
             <cfset news.publish = 0>
        </cfif>
        <cfquery name="allNews" datasource="merce_5">
            insert into tbl_CentennialNews
                (text,
                  link,
                  rank,
                  publish
                )values (
                '#news.text#',
                '#news.link#',
                #news.rank#,
                #news.publish#
                )
        </cfquery>
        <cfreturn 1>
    </cffunction>
        
        
        <cffunction name="saveNewsItemEdit" access="remote" returntype="any">
        <cfargument name="news" type="any" required="true">
        <cfif news.publish EQ 'true'>
            <cfset news.publish = 1>
            <cfelse>
             <cfset news.publish = 0>
        </cfif>
        <cfquery name="allNews" datasource="merce_5">
            update tbl_CentennialNews
                set text = '#news.text#',
                  link = '#news.link#',
                  rank= #news.rank#,
                  publish = #news.publish#
                where id = #news.id#
        </cfquery>
        <cfreturn 1>
    </cffunction>
    
     <cffunction name="createNewWriting" access="remote" returntype="any">
        <cfargument name="writing" type="any" required="true">
         <cfif writing.publish EQ 'yes'>
             <cfset writing.publish = 1>
         <cfelse>
             <cfset writing.publish = 0>
         </cfif>
            <cfquery name="newWriting" datasource="merce_5">
                INSERT INTO dbo.tblWritings
                (title,
                date,
                publication,
                description,
                link,
                text,
                publish
                )
                VALUES (
                '#writing.title#',
                #writing.date#,
                '#writing.publication#',
                '#writing.description#',
                '#writing.link#',
                '#writing.text#',
                #writing.publish#
                )
                select @@identity

            </cfquery>
        <cfreturn newWriting>
    </cffunction>


    <cffunction name="deleteWriting" access="remote" returntype="any">
        <cfargument name="id" type="numeric" required="true">
            <cfquery name="delete" datasource="merce_5">
                delete from dbo.tblWritings
                where id = #id#
                select 1
            </cfquery>
        <cfreturn delete>
    </cffunction>


    <cffunction name="getWritings"  access="remote" returntype="any">
        <cfquery name="writings" datasource="merce_5">
            select * from tblWritings
        </cfquery>
        <cfreturn writings>
    </cffunction>

    <cffunction name="getPublishedWritings"  access="remote" returntype="any">
        <cfquery name="writings" datasource="merce_5">
            select * from tblWritings
            where publish = 1
        </cfquery>
        <cfreturn writings>
    </cffunction>

    <cffunction name="getWriting" access="remote" returntype="any">
        <cfargument name="id" type="numeric" required="true">
            <cfquery name="writing" datasource="merce_5">
                select * from tblWritings
                where id = #id#
            </cfquery>
        <cfreturn writing>
    </cffunction>

    <cffunction name="updateWriting" access="remote" returntype="any">
        <cfargument name="writing" type="any" required="true">
        <cfif writing.publish EQ 'yes'>
            <cfset writing.publish = 1>
        <cfelse>
            <cfset writing.publish = 0>
        </cfif>
        <cfquery name="writingReturn" datasource="merce_5">
              UPDATE tblWritings
                set title = '#writing.title#',
                date = #writing.date#,
                publication = '#writing.publication#',
                description = '#writing.description#',
                link = '#writing.link#',
                text = '#writing.text#',
                publish = #writing.publish#
                where id = #writing.id#
                select 1
        </cfquery>
        <cfreturn writingReturn>
    </cffunction>


    
    
    

    
    
    <cffunction name="getLicenseHistory" access="remote" returntype="any">
    <cfargument name="licType" type="numeric" required="yes">
    <cfquery name="licenseHistory" datasource="merce_5">
    	SELECT * FROM dbo.tbl_LicHistory
        WHERE licType = #licType#
        ORDER BY referenceYear
    </cfquery>
    <cfreturn licenseHistory>
    </cffunction>
    
    <cffunction name="getAllLicenseHistory" access="remote" returntype="any">
    <cfquery name="licenseHistory" datasource="merce_5">
    	SELECT * FROM dbo.tbl_LicHistory
        ORDER BY referenceYear
    </cfquery>
    <cfreturn licenseHistory>
    </cffunction>
    
     <cffunction name="getLicenseByID" access="remote" returntype="any">
      <cfargument name="ID" type="numeric" required="yes">
    <cfquery name="licenseHistory" datasource="merce_5">
    	SELECT * FROM dbo.tbl_LicHistory
        where id = #ID#
    </cfquery>
    <cfreturn licenseHistory>
    </cffunction>
    
    
    <cffunction name="upateLicenseHistory" access="remote" returntype="any">
    <cfargument name="licenseHistory" type="any" required="yes">
    <cfquery name="updateHistory" datasource="merce_5">
    update tbl_LicHistory
    set Year  = '#licenseHistory.Year#',
          Dance = '#licenseHistory.Dance#' ,
          Company = '#licenseHistory.Company#',
          Stager = '#licenseHistory.Stager#' ,
          licType =#licenseHistory.licType#,
          referenceYear = #licenseHistory.referenceYear#
          where id = #licenseHistory.id#
          select 1
    </cfquery>
    <cfreturn updateHistory>
    </cffunction>
    
    <cffunction name="deleteLicenseHistoryByID" access="remote" returntype="any">
      <cfargument name="ID" type="numeric" required="yes">
    <cfquery name="licenseHistory" datasource="merce_5">
    	delete  FROM dbo.tbl_LicHistory
        where id = #ID#
        select 1
    </cfquery>
    <cfreturn licenseHistory>
    </cffunction>
    
    
     <cffunction name="insertNewLicenseHistory" access="remote" returntype="any">
    <cfargument name="licenseHistory" type="any" required="yes">
    <cfquery name="insertHistory" datasource="merce_5">
    INSERT INTO dbo.tbl_LicHistory
        ( Year ,
          Dance ,
          Company ,
          Stager ,
          licType ,
          referenceYear
        )
VALUES  ( '#licenseHistory.Year#' , -- Year - nvarchar(50)
          '#licenseHistory.Dance#'  , -- Dance - nvarchar(255)
         '#licenseHistory.Company#'  , -- Company - nvarchar(255)
          '#licenseHistory.Stager#'  , -- Stager - nvarchar(255)
          #licenseHistory.licType# , -- licType - int
          #licenseHistory.referenceYear#   -- referenceYear - int
        )
       SELECT @@IDENTITY
    </cfquery>
    <cfreturn insertHistory>
    </cffunction>
    
    
    <cffunction name="getWorkDescription" access="remote" returntype="any">
    <cfargument name="id" type="numeric" required="yes">
    <cfquery name="getDescription" datasource="merce_5">
    SELECT     id, workTitle, description
    FROM         tbl_Works
    WHERE id = #id#
    </cfquery>
    <cfreturn getDescription>
    </cffunction>
    
     <cffunction name="getWorkCollab" access="remote" returntype="any">
    <cfargument name="id" type="numeric" required="yes">
    <cfquery name="getDescription" datasource="merce_5">
    SELECT     id, workTitle, workCollab, workCollabSummary
    FROM         tbl_Works
    WHERE id = #id#
    </cfquery>
    <cfreturn getDescription>
    </cffunction>
    
    <cffunction name="updateWorkDescription" access="remote" returntype="any">
    <cfargument name="workDescription" type="any">
    <cfquery  name="updateDesc" datasource="merce_5">
    UPDATE dbo.tbl_Works

SET description = '#workDescription.description#'
WHERE id = #workDescription.id#
    </cfquery>
    
    <cfreturn 1>
    </cffunction>
    
     <cffunction name="updateWorkCollab" access="remote" returntype="any">
    <cfargument name="workCollab" type="any">
    <cfquery  name="updateDesc" datasource="merce_5">
           update tbl_Works
            set workCollab = '#workCollab.workCollab#',
            workCollabSummary = '#workCollab.workCollabSummary#'
            where id = #workCollab.id#
    </cfquery> 
    <cfreturn 1>
    </cffunction>

    <cffunction name="getMonths" access="remote" returntype="any">
        <cfquery name="months" datasource="merce_5">
            select id as data, Month as label from tbl_Months
        </cfquery>
        <cfreturn months>
    </cffunction>

    <cffunction name="getCurrentEventsALL" access="remote" returntype="query">
    <cfargument name="filter" default="dateDown" type="string" required="yes">
    <cfquery datasource="merce_5" name="events">
    SELECT     tbl_Events.id, tbl_Events.eventName, dbo.tbl_Events.eventType, tbl_Events.eventStartDate, tbl_Events.eventEndDate, tbl_Events.eventDateString, 
                      tbl_Events.eventDescription, tbl_Events.eventLocation, tbl_Events.eventWeb,tbl_Events.eventPublish,tbl_Events.eventImage,tbl_Events.centennial,
                    tbl_Events.displayOrder,tbl_Events.eventPostDate,tbl_Events.month,tbl_Events.monthEnd
FROM         tbl_Events
 where   tbl_Events.eventEndDate > dateadd(m,-14,GETDATE())

<cfif filter EQ "dateDown">
ORDER BY tbl_Events.eventStartDate ASC
<cfelseif filter EQ 'dateUP'>
ORDER BY tbl_Events.eventStartDate DESC
<cfelseif filter EQ 'locationUP'>
ORDER BY tbl_Events.eventLocation ASC
<cfelseif filter EQ 'locationDOWN'>
ORDER BY tbl_Events.eventLocation DESC
</cfif>
    </cfquery>
    <cfreturn events>
    </cffunction>
    
    
    
    

    
   
    
    <cffunction name="updateLicense" access="remote" returntype="any">
    <cfargument name="license" type="any" required="yes">
    <cfquery datasource="merce_5" name="updatedLicense">
		UPDATE dbo.tbl_Licenses
        SET  Licensee =  '#license.Licensee#',
          Dance = '#license.Dance#',
          stagerTeacher = '#license.stagerTeacher#' ,
          Rehearsals = '#license.Rehearsals#' ,
          Premiere = '#license.Premiere#',
          live = #license.live#,
          licType = #license.licType#
          where id = #license.id#
          select #license.id#    </cfquery>
    <cfreturn updatedLicense>
    </cffunction>
    
    <cffunction name="createLicense" access="remote" returntype="any">
    <cfargument name="license" type="any" required="yes">
    <cfquery datasource="merce_5" name="newLicense">
    INSERT INTO dbo.tbl_Licenses
        ( Licensee ,
          Dance ,
          stagerTeacher ,
          Rehearsals ,
          Premiere ,
          live ,
          licType
        )
VALUES  ( '#license.Licensee#' , -- Licensee - nvarchar(50)
          '#license.Dance#' , -- Dance - nvarchar(100)
         '#license.stagerTeacher#' , -- stagerTeacher - nvarchar(100)
          '#license.Rehearsals#', -- Rehearsals - nvarchar(100)
          '#license.Premiere#' , -- Premiere - nvarchar(50)
          #license.live#, -- live - int
          #license.licType# -- licType - int
        )
        select @@identity
    
    </cfquery>
    <cfreturn newLicense>
    </cffunction>
    
    
   
    
    
    
    
    <cffunction name="getPublishTypes" access="remote" returntype="query">
     <cfquery datasource="merce_5" name="publishTypes">
    SELECT     eventPublish AS data, eventPublishLabel AS label
	FROM         tbl_EventPublishTypes
    	</cfquery>
        <cfreturn publishTypes>
    </cffunction>
    
    
    
    <cffunction name="getEdLics" access="remote" returntype="query">
    <cfquery name="ed" datasource="merce_5">
    select * from tbl_Licenses
where licType = 1 and live = 1
    
    </cfquery>
    <cfreturn ed>
    </cffunction>
    
     <cffunction name="getAllLics" access="remote" returntype="query">
    <cfquery name="ed" datasource="merce_5">
    SELECT     tbl_Licenses.*
    FROM         tbl_Licenses
    </cfquery>
    <cfreturn ed>
    </cffunction>
    
     <cffunction name="getAllLiveLics" access="remote" returntype="query">
    <cfquery name="ed" datasource="merce_5">
        SELECT     tbl_Licenses.*
        FROM         tbl_Licenses
        WHERE live = 1
    </cfquery>
    <cfreturn ed>
    </cffunction>
    
     <cffunction name="getProfLics" access="remote" returntype="query">
    <cfquery name="prof" datasource="merce_5">
    select * from tbl_Licenses
where licType = 2 and live = 1
    
    </cfquery>
    <cfreturn prof>
    </cffunction>
    
     <cffunction name="getLicByID" access="remote" returntype="query">
     <cfargument name="id" type="numeric" required="yes">
    <cfquery name="prof" datasource="merce_5">
    select * from tbl_Licenses
where id = #id#
    
    </cfquery>
    <cfreturn prof>
    </cffunction>

    
    
    <Cffunction name="getMediaDances" access="remote" returntype="query" >
        <cfquery name="dances" datasource="merce_5">
        SELECT   distinct  tbl_Works.id AS data, tbl_Works.workTitle AS label
        FROM         tbl_Works INNER JOIN
                              tbl_MediaJunction ON tbl_Works.id = tbl_MediaJunction.junctionTarget
        WHERE     (tbl_MediaJunction.junctionType = 1)
        order by tbl_Works.workTitle
        
        </cfquery>
        <cfreturn dances>
        </Cffunction>
        
        <Cffunction name="getMediaDesigners" access="remote" returntype="query" >
        <cfquery name="designers" datasource="merce_5">
        SELECT     DISTINCT tbl_Decor.id as data, tbl_Decor.decor_FN, tbl_Decor.decor_LN, tbl_Decor.decor_LN + ', ' + tbl_Decor.decor_FN as label
        FROM         tbl_MediaJunction INNER JOIN
                              tbl_Decor ON tbl_MediaJunction.junctionTarget = tbl_Decor.id
        WHERE     (tbl_MediaJunction.junctionType = 3)
        order by label
        </cfquery>
        <cfreturn designers>
        
        </Cffunction>
        
        
        <Cffunction name="getMediaDancers" access="remote" returntype="query" >
        <cfquery name="dancers" datasource="merce_5">
        SELECT DISTINCT tbl_Dancers.id as data, tbl_Dancers.dancer_FN, tbl_Dancers.dancer_LN, tbl_Dancers.dancer_LN +', ' + tbl_Dancers.dancer_FN as label
        FROM         tbl_MediaJunction INNER JOIN
                              tbl_Dancers ON tbl_MediaJunction.junctionTarget = tbl_Dancers.id
        WHERE     (tbl_MediaJunction.junctionType = 2)
        order by label
        </cfquery>
        <cfreturn dancers>
     </Cffunction>
     
     <cffunction name="getMediaDetails" access="remote" returntype="query">
     <cfargument name="mediaID" type="numeric" required="yes">
     <cfquery name="mediaDetail" datasource="merce_5">
     SELECT     tbl_Media.*
        FROM         tbl_Media
        WHERE     (id = #mediaID#)
     </cfquery>
     <cfreturn mediaDetail>
     </cffunction>
     
       <cffunction name="getDancersForMediaID" access="remote" returntype="query">
     <cfargument name="mediaID" type="numeric" required="yes">
     <cfquery name="mediaDancers" datasource="merce_5">
        SELECT     tbl_Dancers.dancer_FN, tbl_Dancers.dancer_LN, viewMediaByDancers.mediaID, tbl_Dancers.dancer_LN +', ' + tbl_Dancers.dancer_FN as label
        FROM         viewMediaByDancers INNER JOIN
                              tbl_Dancers ON viewMediaByDancers.junctionTarget = tbl_Dancers.id
        WHERE     (viewMediaByDancers.junctionType = 2) AND (viewMediaByDancers.mediaID = #mediaID#)
     </cfquery>
     <cfreturn mediaDancers>
     </cffunction>  
     
     
       <cffunction name="getDancesForMediaID" access="remote" returntype="query">
     <cfargument name="mediaID" type="numeric" required="yes">
     <cfquery name="mediaDances" datasource="merce_5">
        SELECT     tbl_Works.workTitle, tbl_Works.workLengthString, viewMediaByDances.mediaID
        FROM         viewMediaByDances INNER JOIN
                              tbl_Works ON viewMediaByDances.junctionTarget = tbl_Works.id
        WHERE     (viewMediaByDances.junctionType = 1) AND (viewMediaByDances.mediaID = #mediaID#)
     </cfquery>
     <cfreturn mediaDances>
     </cffunction>  
     
      <cffunction name="getDesignersForMediaID" access="remote" returntype="query">
     <cfargument name="mediaID" type="numeric" required="yes">
     <cfquery name="mediaDesigners" datasource="merce_5">
        SELECT     tbl_Decor.decor_FN, tbl_Decor.decor_LN, tbl_Decor.decor_LN +', ' + tbl_Decor.decor_FN as label
        FROM         viewMediaByDesigner INNER JOIN
                              tbl_Decor ON viewMediaByDesigner.junctionTarget = tbl_Decor.id
        WHERE     (viewMediaByDesigner.junctionType = 3) AND (viewMediaByDesigner.mediaID = #mediaID#)
     </cfquery>
     <cfreturn mediaDesigners>
     </cffunction>  
     
     
	
    
    <cffunction name="getInitialWebLoad" access="remote" returntype="any" output="no">
    	<cfquery datasource="merce_5" name="dances">
        SELECT     id, workTitle, CAST(DATEPART(year,premiereDate) AS VARCHAR)AS premiereYear,premiereDate
        FROM         tbl_Works
        ORDER BY premiereDate
        </cfquery>
    <cfreturn dances>
    </cffunction>
    
    

    

    
   
    
    
    <cffunction name="createDance" access="remote" returntype="any">
    	<cfargument name="danceDetails" type="any" required="yes">
        <cfif danceDetails.premiereDate NEQ ''>
        <cfset danceDetails.premiereDate = #dateAdd('h',5,danceDetails.premiereDate)#>
        </cfif>
        <cfif danceDetails.revivalYear  NEQ ''>
        <cfset danceDetails.revivalYear = #dateAdd('h',5, danceDetails.revivalYear)#>
        </cfif>
        <cfif danceDetails.premiereDate  NEQ ''>
        <cfset premDate =  #dateFormat(danceDetails.premiereDate,"mmmm dd, yyyy")#>
         <cfelse>
            <cfset premDate = ''>
         </cfif>
        <cfif danceDetails.revivalYear  NEQ ''>
        <cfset revDate =  #dateFormat(danceDetails.revivalYear,"mmmm dd, yyyy")#>
            <cfelse>
            <cfset revDate = ''>
        </cfif>
        	<cfquery datasource="merce_5" name="insertDance">
            	INSERT INTO dbo.tbl_Works
        ( workTitle ,
          length ,
          workLengthString ,
          premiereDate ,
          premiereVenue ,
          premiereString ,
          premiereCity ,
          premiereCountry ,
          revivalYear ,
          revivalLocation ,
          revivalNotes,
          workImage,
          workImageNotes,
          capsuleURL,
          link,
            mediaLink
        )
		  VALUES  ( 
          '#danceDetails.workTitle#', 
          #danceDetails.length# , 
          '#danceDetails.workLengthString#' , 
          '#premDate#',
         '#danceDetails.premiereVenue#' ,
          '#danceDetails.premiereString#' ,
          '#danceDetails.premiereCity#' ,
          '#danceDetails.premiereCountry#', 
          '#revdate#',
          '#danceDetails.revivalLocation#' ,
          '#danceDetails.revivalNotes#',
          '#danceDetails.workImage#',
          '#danceDetails.workImageNotes#',
          '#danceDetails.capsuleURL#',
           '#danceDetails.link#',
            '#danceDetails.mediaLink#'
        )
        select @@identity
            </cfquery>
        <cfreturn insertDance>    
    </cffunction>
    
    
    <cffunction name="getDancers" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="dancers">
      SELECT     id AS data, dancer_LN, dancer_FN, label = dancer_LN + ', ' +dancer_FN
      FROM       tbl_Dancers
      order by label
        </cfquery> 
		<cfreturn dancers>
	</cffunction>
    
     <cffunction name="getDancerDetails" access="remote" returntype="query">
     <cfargument name="dancerID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="dancers">
                SELECT     id, dancer_FN, dancer_LN,org,years
                FROM         tbl_Dancers
                WHERE     (id = #dancerID#)
        </cfquery> 
		<cfreturn dancers>
	</cffunction>
    
      <cffunction name="insertNewDancer" access="remote" returntype="query">
     <cfargument name="dancer_FN" type="string">
     <cfargument name="dancer_LN" type="string">
          <cfargument name="org" type="string">
          <cfargument name="years" type="string">
          <cfquery datasource="merce_5" name="dancers">
               INSERT INTO dbo.tbl_Dancers
                        ( dancer_FN, dancer_LN, org,years )
                VALUES  ( '#dancer_FN#',
                          '#dancer_LN#',
                            '#org#',
                            '#years#'
                          )
                select @@identity
        </cfquery> 
		<cfreturn dancers>
	</cffunction>
    
     <cffunction name="updateDancerDetails" access="remote" returntype="query">
     <cfargument name="dancerID" type="numeric" required="yes">
     <cfargument name="dancer_FN" type="string">
     <cfargument name="dancer_LN" type="string">
         <cfargument name="org" type="string">
         <cfargument name="years" type="string">
		<cfquery datasource="merce_5" name="dancers">
                UPDATE dbo.tbl_Dancers
                SET dancer_FN = '#dancer_FN#',dancer_LN = '#dancer_LN#',org = '#org#',years='#years#'
                WHERE id = #dancerID#
                select 1
        </cfquery> 
		<cfreturn dancers>
	</cffunction>
    
    
   
    
     
    
    
    <cffunction name="getWorksForDancer" access="remote" returntype="query">
    <cfargument name="dancerID" type="numeric" required="yes">
    <cfquery datasource="merce_5" name="worksForDancer">
    			SELECT     tbl_Works.workTitle
				FROM         tbl_Dancers INNER JOIN
                      tbl_Work_Dancer ON tbl_Dancers.id = tbl_Work_Dancer.dancer INNER JOIN
                      tbl_Works ON tbl_Work_Dancer.[work] = tbl_Works.id
					WHERE     (tbl_Dancers.id = #dancerID#)
    </cfquery>
    <cfreturn worksForDancer>
    </cffunction>
    
    <cffunction name="deleteDancer" access="remote" returntype="any">
     <cfargument name="dancerID" type="numeric" required="yes">
    	<cfquery datasource="merce_5">
        	DELETE FROM dbo.tbl_Dancers
			WHERE id = #dancerID#
        </cfquery>
    </cffunction>
    
    
    
   
    
    
    
   
     
    <cffunction name="getCostumers" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="costumers">
     	SELECT     id AS data, costumer_FN , costumer_LN, label = costumer_LN + ', ' + costumer_FN
		FROM        dbo.tbl_Costumers
         order by label
        </cfquery> 
		<cfreturn costumers>
	</cffunction>
    

    

    
    <cffunction name="getWorksForCostumer" access="remote" returntype="query">
    <cfargument name="CostumerID" type="numeric" required="yes">
    <cfquery datasource="merce_5" name="worksForCostumer">
    			SELECT     tbl_Works.workTitle
				FROM         tbl_Costumers INNER JOIN
                      tbl_Work_Costumer ON tbl_Costumers.id = tbl_Work_Costumer.Costumer INNER JOIN
                      tbl_Works ON tbl_Work_Costumer.[work] = tbl_Works.id
					WHERE     (tbl_Costumers.id = #CostumerID#)
    </cfquery>
    <cfreturn worksForCostumer>
    </cffunction>
    
     <cffunction name="deleteCostumer" access="remote" returntype="any">
     <cfargument name="CostumerID" type="numeric" required="yes">
    	<cfquery datasource="merce_5">
        	DELETE FROM dbo.tbl_Costumers
			WHERE id = #CostumerID#
        </cfquery>
    </cffunction>
    
   

    
      
    
    <cffunction name="getAssociationCostumer" access="remote" returntype="any">
    	<cfargument name="id" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="associationReturn">
           SELECT     tbl_Work_Costumer.notes, tbl_Costumers.Costumer_FN, tbl_Costumers.Costumer_LN
            FROM         tbl_Work_Costumer INNER JOIN
                                  tbl_Costumers ON tbl_Work_Costumer.Costumer = tbl_Costumers.id
            WHERE     (tbl_Work_Costumer.id = #id#)
        </cfquery>
        <cfreturn associationReturn>
    </cffunction>
    
    <cffunction name="getCostumerDetails" access="remote" returntype="query">
     <cfargument name="costumerID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="costumers">
                SELECT     id, costumer_FN, costumer_LN
                FROM         tbl_Costumers
                WHERE     (id = #costumerID#)
        </cfquery> 
		<cfreturn costumers>
	</cffunction>
    
    <cffunction name="updatecostumerDetails" access="remote" returntype="query">
     <cfargument name="costumerID" type="numeric" required="yes">
     <cfargument name="costumer_FN" type="string">
     <cfargument name="costumer_LN" type="string">
		<cfquery datasource="merce_5" name="costumers">
                UPDATE dbo.tbl_costumers
                SET costumer_FN = '#costumer_FN#',costumer_LN = '#costumer_LN#'
                WHERE id = #costumerID#
                select 1
        </cfquery> 
		<cfreturn costumers>
	</cffunction>
    
     <cffunction name="insertNewcostumer" access="remote" returntype="query">
     <cfargument name="costumer_FN" type="string">
     <cfargument name="costumer_LN" type="string">
		<cfquery datasource="merce_5" name="costumers">
               INSERT INTO dbo.tbl_costumers
                        ( costumer_FN, costumer_LN )
                VALUES  ( '#costumer_FN#',
                          '#costumer_LN#'  
                          )
                select @@identity
        </cfquery> 
		<cfreturn costumers>
	</cffunction>
    
     <cffunction name="getDecor" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="decor">
        SELECT     id AS data, decor_FN , decor_LN, label =  decor_LN + ', ' + decor_FN
        FROM        dbo.tbl_Decor
         order by label
        </cfquery> 
		<cfreturn decor>
	</cffunction>
    
    <cffunction name="getDecorDetails" access="remote" returntype="query">
     <cfargument name="decorID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="decor">
                SELECT     id, decor_FN, decor_LN
                FROM         tbl_Decor
                WHERE     (id = #decorID#)
        </cfquery> 
		<cfreturn decor>
	</cffunction>
    
     <cffunction name="updatedecorDetails" access="remote" returntype="query">
     <cfargument name="decorID" type="numeric" required="yes">
     <cfargument name="decor_FN" type="string">
     <cfargument name="decor_LN" type="string">
		<cfquery datasource="merce_5" name="decor">
                UPDATE dbo.tbl_Decor
                SET decor_FN = '#decor_FN#',decor_LN = '#decor_LN#'
                WHERE id = #decorID#
                select 1
        </cfquery> 
		<cfreturn decor>
	</cffunction>
    

    
    
    
    
    
    <cffunction name="getWorksForDecor" access="remote" returntype="query">
    <cfargument name="decorID" type="numeric" required="yes">
    <cfquery datasource="merce_5" name="worksForDecor">
          SELECT     tbl_Works.workTitle
        FROM         tbl_Works INNER JOIN
                              tbl_Work_Decor ON tbl_Works.id = tbl_Work_Decor.[work]
        WHERE     (tbl_Work_Decor.decor = #decorID#)
    </cfquery>
    <cfreturn worksForDecor>
    </cffunction>
    
     <cffunction name="deleteDecor" access="remote" returntype="any">
     <cfargument name="decorID" type="numeric" required="yes">
    	<cfquery datasource="merce_5">
        	DELETE FROM dbo.tbl_Decor
			WHERE id = #decorID#
        </cfquery>
    </cffunction>
    
    <cffunction name="createAssocRecordForDecor" access="remote" returntype="any">
            <cfargument name="danceID" required="yes" type="numeric">
            <cfargument name="DecorID" required="yes" type="numeric">
            <cfargument name="notes" required="yes" type="string">
            <cfquery datasource="merce_5" name="addAssocRecord">
            	INSERT INTO dbo.tbl_Work_Decor
                ( work ,
                  Decor ,
                  notes

                )
      		  VALUES  ( 
              	  #danceID#,
                 #DecorID#,
                 '#notes#'  
                )
            </cfquery>
    </cffunction>
    

    

    
    
    
    
    <cffunction name="getLighting" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="lighting">
            SELECT     id AS data, lightingDesigner_FN , lightingDesigner_FN, label =  lightingDesigner_LN + ', ' + lightingDesigner_FN
            FROM        dbo.tbl_LightingDesigner
            order by label
        </cfquery> 
		<cfreturn lighting>
	</cffunction>
    

    
    <cffunction name="getWorksForLighting" access="remote" returntype="query">
    <cfargument name="lightingID" type="numeric" required="yes">
    <cfquery datasource="merce_5" name="worksForLighting">
                SELECT     tbl_Works.workTitle, tbl_Work_Lighting.lightingDesigner AS id
                FROM         tbl_Works INNER JOIN
                                      tbl_Work_Lighting ON tbl_Works.id = tbl_Work_Lighting.[work]
                WHERE     (tbl_Work_Lighting.lightingDesigner = #lightingID#)
    </cfquery>
    <cfreturn worksForLighting>
    </cffunction>
    
    <cffunction name="deleteLighing" access="remote" returntype="any">
     <cfargument name="lightingID" type="numeric" required="yes">
    	<cfquery datasource="merce_5">
                DELETE
                FROM dbo.tbl_LightingDesigner
                WHERE id = #lightingID#
        </cfquery>
    </cffunction>
    
    <cffunction name="createAssocRecordForLighting" access="remote" returntype="any">
            <cfargument name="danceID" required="yes" type="numeric">
            <cfargument name="LightingID" required="yes" type="numeric">
            <cfargument name="notes" required="yes" type="string">
            <cfquery datasource="merce_5" name="addAssocRecord">
            	INSERT INTO dbo.tbl_Work_Lighting
                ( work ,
                  lightingDesigner,
                  Notes 

                )
      		  VALUES  ( 
              	  #danceID#,
                 #LightingID# ,
                  '#notes#'
                )
            </cfquery>
    </cffunction>
    
    
     <cffunction name="updateLightingAssociation" access="remote" returntype="any">
    	<cfargument name="id" type="numeric" required="yes">
         <cfargument name="notes" required="yes" type="string">
        <cfquery datasource="merce_5" name="deleteReturn">
        	update dbo.tbl_Work_Lighting
            set notes = '#notes#'
			WHERE id = #id#
        </cfquery>
    </cffunction>
    
    
    
     <cffunction name="getComposers" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="composers">
        SELECT     id AS data, Composer_LN , Composer_FN, label =  Composer_LN + ', ' + Composer_FN
        FROM      dbo.tbl_Composers
         order by label
        </cfquery> 
		<cfreturn composers>
	</cffunction>
    
    <cffunction name="getComposerDetails" access="remote" returntype="query">
     <cfargument name="composerID" type="numeric" required="yes">
		<cfquery datasource="merce_5" name="composer">
                SELECT     id, composer_FN, composer_LN
                FROM         tbl_composers
                WHERE     (id = #composerID#)
        </cfquery> 
		<cfreturn composer>
	</cffunction>
    
    <cffunction name="updateComposerDetails" access="remote" returntype="query">
     <cfargument name="composerID" type="numeric" required="yes">
     <cfargument name="composer_FN" type="string">
     <cfargument name="composer_LN" type="string">
		<cfquery datasource="merce_5" name="composer">
                UPDATE dbo.tbl_composers
                SET composer_FN = '#composer_FN#',composer_LN = '#composer_LN#'
                WHERE id = #composerID#
                select 1
        </cfquery> 
		<cfreturn composer>
	</cffunction>
    
     <cffunction name="insertNewComposer" access="remote" returntype="query">
     <cfargument name="composer_FN" type="string">
     <cfargument name="composer_LN" type="string">
		<cfquery datasource="merce_5" name="composer">
               INSERT INTO dbo.tbl_composers
                        ( composer_FN, composer_LN )
                VALUES  ( '#composer_FN#',
                          '#composer_LN#'  
                          )
                select @@identity
        </cfquery> 
		<cfreturn composer>
	</cffunction>
    
    <cffunction name="getMusic" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="music">
            SELECT id AS DATA, Title AS label
            FROM dbo.tbl_Music
         order by label
        </cfquery> 
		<cfreturn music>
	</cffunction>
    
    <cffunction name="getWorksForComposer" access="remote" returntype="any">
    	<cfargument name="id" type="numeric">
    	<cfquery datasource="merce_5" name="music">
        	SELECT     tbl_Music.Title, tbl_Composers.Composer_FN, tbl_Composers.Composer_LN
                FROM         tbl_Composers INNER JOIN
                      tbl_Music ON tbl_Composers.id = tbl_Music.Composer
			WHERE     (tbl_Composers.id = #id#) 
        	</cfquery>
    	<cfreturn music>
    </cffunction>
    
    
    
    <cffunction name="getMusicAndComposers" access="remote" returntype="query">
		<cfquery datasource="merce_5" name="music">
            SELECT     tbl_Composers.id, tbl_Composers.Composer_FN, tbl_Composers.Composer_LN, tbl_Music.id AS musicID, tbl_Music.Title,
            label =  Composer_LN + ', ' + Composer_FN
            FROM         tbl_Composers INNER JOIN
                                  tbl_Music ON tbl_Composers.id = tbl_Music.Composer
        </cfquery> 
		<cfreturn music>
	</cffunction>
    
     <cffunction name="insertMusicComposer" access="remote" returntype="query">
          <cfargument name="title" type="string">
    	 <cfargument name="composer" type="numeric">
		<cfquery datasource="merce_5" name="music">
           INSERT INTO dbo.tbl_Music
        ( Title, Composer )
		VALUES  ( '#title#', 
          #composer#
          )
          select @@identity
        </cfquery> 
		<cfreturn music>
	</cffunction>

    <cffunction name="deleteMusicComposer" access="remote" returntype="query">

        <cfargument name="id" type="numeric">
        <cfquery datasource="merce_5" name="music">
          delete from tbl_Music
          where id = #id#
          select @@identity
        </cfquery>
        <cfreturn music>
    </cffunction>
   

    
    
   
   
   <cffunction name="createMediaElement" access="remote" returntype="any">
    	<cfargument name="mediaDetails" type="any" required="yes">
        	<cfquery datasource="merce_5" name="insertMedia">
            	INSERT dbo.tbl_Media
        ( title ,
          year ,
          lengthString ,
          length ,
          colorBW ,
          director ,
          producer ,
          distributor ,
          description ,
          link,
          musicians,
        videoLink,
                music,
                publish
        )
VALUES  ( '#mediaDetails.title#' , -- title - nvarchar(350)
          #mediaDetails.year# , -- year - datetime
          '#mediaDetails.lengthString#' , -- lengthString - nvarchar(50)
          #mediaDetails.length# , -- length - int
          '#mediaDetails.colorBW#', -- colorBW - nvarchar(10)
          '#mediaDetails.director#' , -- director - nvarchar(150)
          '#mediaDetails.producer#' , -- producer - nvarchar(150)
         '#mediaDetails.distributor#'	 , -- distributor - nvarchar(150)
          '#mediaDetails.description#' , -- description - ntext
          '#mediaDetails.link#',
          '#mediaDetails.musicians#',  -- link - nvarchar(350)
            '#mediaDetails.videoLink#' ,
               '#mediaDetails.music#',
               '#mediaDetails.publish#'
        )
        select @@identity
            </cfquery>
        <cfreturn insertMedia>    
    </cffunction>
    
    <cffunction name="updateMediaElement" access="remote" returntype="any">
    	<cfargument name="mediaDetails" type="any" required="yes">
        <cfquery datasource="merce_5" name="updateMedia">
        update tbl_Media
		set   title =     '#mediaDetails.title#' ,
          year = #mediaDetails.year# , 
          lengthString = '#mediaDetails.lengthString#' , 
          length = #mediaDetails.length# ,
          colorBW = '#mediaDetails.colorBW#', 
          director = '#mediaDetails.director#' ,
          producer = '#mediaDetails.producer#' , 
         distributor = '#mediaDetails.distributor#'	 , 
          description = '#mediaDetails.description#' , 
          link = '#mediaDetails.link#',
          musicians = '#mediaDetails.musicians#',
        videoLink = '#mediaDetails.videoLink#',
            music = '#mediaDetails.music#',
            publish = #mediaDetails.publish#
          where ID = #mediaDetails.id#
        </cfquery>
    
    </cffunction>
    
    <cffunction name="getMediaElement" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        <cfquery name="getMediaElement" datasource="merce_5">
        	SELECT  * FROM tbl_Media
			WHERE id = #mediaID#
        </cfquery>
    	<cfreturn getMediaElement>
    </cffunction>
    
    <cffunction name="getAllMedia" access="remote" returntype="query">
    	<cfquery name="allMedia" datasource="merce_5">
            SELECT     id AS data, title AS label, year, lengthString
            FROM         tbl_Media
            ORDER BY label
        </cfquery>
    	<cfreturn allMedia>
    </cffunction>
    
    
    <cffunction name="getAvailableDancersMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDancers">
            	SELECT     id AS data, dancer_FN, dancer_LN, dancer_LN + ', '+dancer_FN AS label
                FROM         tbl_Dancers
                
                WHERE ID NOT in (SELECT     junctionTarget
                FROM         tbl_MediaJunction
                WHERE     (junctionType = 2) AND (newMediaID = #mediaID#) )
                ORDER BY dancer_LN
            </cfquery>
        <cfreturn mediaDancers>
    </cffunction>
    
    
     <cffunction name="createDancerMediaAssoc" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        <cfargument name="juctionTarget" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDancers">
            	INSERT INTO dbo.tbl_MediaJunction
                    ( junctionType ,
                      newMediaID ,
                      junctionTarget
                    )
            VALUES  ( 2 , -- junctionType - int TYPE DANCER
                      #mediaID# , -- mediaID - int
                      #juctionTarget#  -- junctionTarget - int
                    )
            </cfquery>
    </cffunction>
    
    <cffunction name="getAssociatedDancersMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDancers">
                SELECT     tbl_Dancers.id AS data, tbl_Dancers.dancer_FN, tbl_Dancers.dancer_LN, tbl_Dancers.dancer_LN + ', ' + tbl_Dancers.dancer_FN AS label, 
                                      tbl_MediaJunction.junctionType
                FROM         tbl_Dancers INNER JOIN
                                      tbl_MediaJunction ON tbl_Dancers.id = tbl_MediaJunction.junctionTarget
                WHERE     (tbl_MediaJunction.newMediaID = #mediaID#) AND (tbl_MediaJunction.junctionType = 2)
                ORDER BY tbl_Dancers.dancer_LN
            </cfquery>
        <cfreturn mediaDancers>
    </cffunction>
   
	<cffunction name="dissassociateFromMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        <cfargument name="junctionType" type="numeric" required="yes">
        <cfargument name="junctionTarget" type="numeric" required="yes">
        <cfquery datasource="merce_5" name="deleteAssociation">
        DELETE FROM dbo.tbl_MediaJunction
		WHERE newMediaID = #mediaID# AND junctionType = #junctionType# AND junctionTarget = #junctionTarget#
        </cfquery>
    
    </cffunction> 
    
     <cffunction name="getAvailableDesignersMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDesigners">
            	SELECT     id AS data, Decor_FN, Decor_LN, Decor_LN + ', '+Decor_FN AS label
                FROM         tbl_Decor
                
                WHERE ID NOT in (SELECT     junctionTarget
                FROM         tbl_MediaJunction
                WHERE     (junctionType = 3) AND (newMediaID = #mediaID#) )
                ORDER BY Decor_LN
            </cfquery>
        <cfreturn mediaDesigners>
    </cffunction>
    
    
     <cffunction name="createDesignerMediaAssoc" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        <cfargument name="juctionTarget" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDesigners">
            	INSERT INTO dbo.tbl_MediaJunction
                    ( junctionType ,
                      newMediaID ,
                      junctionTarget
                    )
            VALUES  ( 3 , -- junctionType - int TYPE DECOR
                      #mediaID# , -- mediaID - int
                      #juctionTarget#  -- junctionTarget - int
                    )
            </cfquery>
    </cffunction>
    
    <cffunction name="getAssociatedDesignersMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDesigners">
                SELECT     tbl_Decor.id AS data, tbl_Decor.Decor_FN, tbl_Decor.Decor_LN, tbl_Decor.Decor_LN + ', ' + tbl_Decor.Decor_FN AS label, 
                                      tbl_MediaJunction.junctionType
                FROM         tbl_Decor INNER JOIN
                                      tbl_MediaJunction ON tbl_Decor.id = tbl_MediaJunction.junctionTarget
                WHERE     (tbl_MediaJunction.newMediaID = #mediaID#) AND (tbl_MediaJunction.junctionType = 3)
                ORDER BY tbl_Decor.Decor_LN
            </cfquery>
        <cfreturn mediaDesigners>
    </cffunction>
   
    <cffunction name="getAvailableDancesMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDances">
            	SELECT     id AS data, workTitle AS label
				FROM         tbl_Works
                
                WHERE ID NOT in (SELECT     junctionTarget
                FROM         tbl_MediaJunction
                WHERE     (junctionType = 1) AND (newMediaID = #mediaID#) )
                ORDER BY workTitle
            </cfquery>
        <cfreturn mediaDances>
    </cffunction>
	
   	 <cffunction name="getAssociatedDancesMedia" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDances">
                SELECT     tbl_Works.workTitle AS label, dbo.tbl_Works.id AS data
                FROM         tbl_Works INNER JOIN
                                      tbl_MediaJunction ON tbl_Works.id = tbl_MediaJunction.junctionTarget
                WHERE     (tbl_MediaJunction.junctionType = 1) AND (tbl_MediaJunction.newMediaID = #mediaID#)
                ORDER BY workTitle
            </cfquery>
        <cfreturn mediaDances>
    </cffunction>
    
    <cffunction name="createDanceMediaAssoc" access="remote" returntype="any">
    	<cfargument name="mediaID" type="numeric" required="yes">
        <cfargument name="juctionTarget" type="numeric" required="yes">
        	<cfquery datasource="merce_5" name="mediaDesigners">
            	INSERT INTO dbo.tbl_MediaJunction
                    ( junctionType ,
                      newMediaID ,
                      junctionTarget
                    )
            VALUES  ( 1 , -- junctionType - int TYPE DANCE
                      #mediaID# , -- mediaID - int
                      #juctionTarget#  -- junctionTarget - int
                    )
            </cfquery>
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