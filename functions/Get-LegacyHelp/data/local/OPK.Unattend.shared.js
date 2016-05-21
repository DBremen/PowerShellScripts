// Filename: shared.js
// Version shared.js for windows.net
// version for b3

//************************************************ Shared components path setting *****************************************
//*******************************************************************************************************************
//    Date   11/07/01
//  

set_path = "" + document.URL
ntshared = set_path.indexOf("::/")

if (ntshared == -1) {
	var moniker= "ms-its:";                  
    var sSharedCHM = moniker+"unattend.chm::/";
	}													
else
	{
	path = set_path.substring(0,ntshared)
	path = path.toLowerCase()
	ntshared = path.lastIndexOf("\\")
	var moniker = path.substring(0,ntshared)+ "\\";
	//var ntshared = moniker.lastIndexOf("\\")
	//var moniker = moniker.substring(0,ntshared) + "\\";
	var sSharedCHM= moniker+"unattend.chm::/";
	}




//************************************************ EVENT HANDLING ********************************************
//*******************************************************************************************************************
//  re-directs to the proper event-driven functions.

// window.onload = load_object;
window.onload = loadPage;
document.onclick= onclickTriage;
document.onmouseover= gettingHot;
document.onmouseout= gettingCold;
window.onunload=saveChecklistState;
window.onresize= resizeDiv;

window.onbeforeprint = set_to_print;
window.onafterprint = reset_form;
		
//********************************************  USER-DEFINED GLOBAL VARIABLES  ************************************
//********************************************************************************************************************
//  The images listed below can all be changed by the user.
var isIE5 = (navigator.appVersion.indexOf("MSIE 5")>0) || (navigator.appVersion.indexOf("MSIE")>0 && parseInt(navigator.appVersion)> 4);
var isIE55 = (navigator.appVersion.indexOf("MSIE 5.5")>0);
if (isIE5 && isIE55) isIE5 = false;
var isIE6 = (navigator.appVersion.indexOf("MSIE 6")>0);
var isIE4 = (navigator.appVersion.indexOf("MSIE 4")>0);

if (isIE4){
	var moniker= "ms-its:";                                         // moniker= ""; for flat files
	var sSharedCHM= moniker+"unattend.chm::/";
}


if (!isIE5 && !isIE55 && !isIE4 && !isIE6) {
	isIE6 = true;
	}


var sShortcutTip= "";

var gifwithin = false;



if(!isIE4){
	xmldoc = new ActiveXObject("microsoft.XMLDOM");
    xmldoc.async = false;
	xmldoc.load(sSharedCHM + "local/alttext.xml");

	var Alt_sPreviousTip= xmldoc.getElementsByTagName("sPreviousTip")
	var Alt_sNextTip= xmldoc.getElementsByTagName("sNextTip")
	var Alt_sExpandTip= xmldoc.getElementsByTagName("sExpandTip")
	var Alt_sPopupTip= xmldoc.getElementsByTagName("sPopupTip")
	var hld_path2reuse= xmldoc.getElementsByTagName("path2reuse")
	var hld_path2glossary= xmldoc.getElementsByTagName("path2glossary")
	var hld_rel_gif = xmldoc.getElementsByTagName("reltopgif")
	var hld_chmName = xmldoc.getElementsByTagName("chmName")
	var hld_emailer = xmldoc.getElementsByTagName("emailer")
	var hld_sendtext = xmldoc.getElementsByTagName("sendtext")
	var hld_sendto = xmldoc.getElementsByTagName("sendto")
	
	//<SMARTHELP>

   var defaultStartMode;
   var defaultCPanelMode;
   var smartErrorTextNode;
   var smartErrorText;
   var xmldocSKUSettings;

   // Grab the ALTTEXT.XML enteries for smart span classes.
   // Get SKU specific defaults.
   var defaultSKUSettingsURL = xmldoc.documentElement.selectSingleNode("smartreusabletext");
   if (defaultSKUSettingsURL != null) {
      if (defaultSKUSettingsURL.text == sSharedCHM + "local/alttext.xml") {
          xmldocSKUSettings = xmldoc;
      } else {
         xmldocSKUSettings = new ActiveXObject("microsoft.XMLDOM");
         xmldocSKUSettings.async = false;
		 xmldocSKUSettings.load(moniker + defaultSKUSettingsURL.text);
      }
      if (xmldocSKUSettings.documentElement != null) {
         defaultStartMode = xmldocSKUSettings.documentElement.selectSingleNode("smartstartdefault");
         defaultCPanelMode = xmldocSKUSettings.documentElement.selectSingleNode("smartcpaneldefault");
         smartErrorTextNode = xmldocSKUSettings.documentElement.selectSingleNode("smarterrortext");
         smartErrorText = smartErrorTextNode ? smartErrorTextNode.text : "XOXOX";
      }
   } // (defaultSKUSettingsURL != NULL)

//</SMARTHELP>

	
	var sPreviousTip="" + Alt_sPreviousTip.item(0).nodeTypedValue
	var sNextTip="" + Alt_sNextTip.item(0).nodeTypedValue
	var sExpandTip="" + Alt_sExpandTip.item(0).nodeTypedValue
	var sPopupTip="" + Alt_sPopupTip.item(0).nodeTypedValue
	var path2reuse="" + hld_path2reuse.item(0).nodeTypedValue
	var path2glossary="" + hld_path2glossary.item(0).nodeTypedValue
	var rel_gif="" + hld_rel_gif.item(0).nodeTypedValue
	var chmName="" + hld_chmName.item(0).nodeTypedValue+"::/"
	var emailer="" + hld_emailer.item(0).nodeTypedValue
	var sendtext="" + hld_sendtext.item(0).nodeTypedValue
	var sendto="" + hld_sendto.item(0).nodeTypedValue
	
var xmldom = new ActiveXObject("microsoft.XMLDOM");
	xmldom.async = false;
	
//if (!xmlLoaded) {

            xmldoc = new ActiveXObject("microsoft.XMLDOM");

            // Init Properties
            xmldoc.async = false;
            xmldoc.validateOnParse = false; // improve perf
            xmldoc.resolveExternals = false;
            xmldoc.preserveWhiteSpace = false;

            // Load Document
            xmldoc.load(moniker + path2reuse + "reusable.xml");
            // if (xmldoc == null || xmldoc.documentElement == null) return; 	// couldn't open reusable.xml
            xmlLoaded = true;
//         }

} // skip all this because ie4 doesn't support xml.
else
{
var sPreviousTip="" 
	var sNextTip=""
	var sExpandTip=""
	var sPopupTip=""
	var rel_gif="no"
}

var closed = sSharedCHM + "plusCold.gif";			//image used for collapsed item in callExpand()
var closedHot = sSharedCHM + "plusHot.gif";			//hot image used for collapsed item in callExpand()
var expand = sSharedCHM + "minusCold.gif";			//image used for expanded item in callExpand()
var expandHot = sSharedCHM + "minusHot.gif";		//hot image used for expanded item in callExpand()

var previousCold= sSharedCHM + "previousCold.gif";
var previousHot= sSharedCHM + "previousHot.gif"; 
var nextCold= sSharedCHM + "nextCold.gif";
var nextHot= sSharedCHM + "nextHot.gif"; 

var shortcutCold= sSharedCHM + "shortcutCold.gif";
var shortcutHot= sSharedCHM + "shortcutHot.gif";

var popupCold= sSharedCHM + "popupCold.gif";
var popupHot= sSharedCHM + "popupHot.gif";

var emptyImg= sSharedCHM + "empty.gif";		//image used for empty expand
var noteImg= sSharedCHM + "note.gif";			//image used for notes
var tipImg= sSharedCHM + "tip.gif";			//image used for tips
var warningImg= sSharedCHM + "warning.gif";		//image used for warnings
var cautionImg= sSharedCHM + "caution.gif";		//image used for cautions
var importantImg= sSharedCHM + "important.gif";		//image used for important notice
var relTopicsImg= sSharedCHM + "rel_top.gif";		//image used for important notice

var branchImg= sSharedCHM + "elle.gif";
var branchImg_RTL= sSharedCHM + "elle_rtl.gif";


//********************************************  GLOBAL VARIABLES  ******************************************
//********************************************************************************************************

var joejoe = false;
var printing = false;
var single = "FALSE";
var scroller = "FALSE";
var valet = "FALSE";
var isRTL= (document.dir=="rtl");
var imgStyleRTL= ""; 
      if (isRTL) imgStyleRTL=" style='filter:flipH' ";

var sActX_TDC= "CLASSID='CLSID:333C7BC4-460F-11D0-BC04-0080C7055A83'";		//Tabular Data Control  for  reusable text data
var sSharedReusableTextFile= sSharedCHM + "reusable.xml";										// common reusable text file
var sSharedReusableTextFileRecord= "para";														//reusable text record

var numbers= /\d/g;				//javascript regular expression
var spaces= /\s/g;				//javascript regular expression
var semicolon= /;/g;			//javascript regular expression

var isPersistent= false;



	
//********************************************  INITIALIZATION  *************************************************
//******************************************************************************************************************
function list_them(){
		
	var envelope = sSharedCHM +'envelope.gif';
	var server = "<DIV Class='FeedbackBar'><SPAN Class='webOnly'><IMG  SRC=" + envelope + " ALT='' BORDER='0'></SPAN><SPAN Class='webOnly' Style='position:relative; top:-1; left:1; color:#333333;'>&nbsp;" + sendtext + "&nbsp;"; 
	server += "<a href='mailto:" + sendto + "?subject=HELP: ";
	server += document.title + "'";
	server += ">" + sendto + "</a></SPAN></DIV>";
	
	var i;

	for (i=0; i < document.all.length; i++){
		if ((document.all[i].tagName == "P") ||
			(document.all[i].tagName == "H1")||
			(document.all[i].tagName == "H6")){
			document.all[i].outerHTML = server + document.all[i].outerHTML;
			i = document.all.length;
			}
		}
}
//*** loadPage **********************************************************************************************
//  Adds the default image tags and re-usable text to the HTML page.

function loadPage(){
if (printing == true) return;

if (emailer == "yes" ) list_them();

isPersistent= (document.all.item("checklist")!=null) && ((isIE5) || (isIE55) ||(isIE6));

  setPreviousNext();
  
  resizeDiv();
  if (isPersistent) getChecklistState();
   
 	load_object();
	addReusableText();
	
	insertImages();
}

//****** setPreviousNext  ************************************************************************ ********************************************************************************************* 
// insert previous/next navbar
// called by: <div id="nav">@@HTMLsequenceFile.txt or .lst@@</div>

function setPreviousNext(){

  var oNav = document.all.item("nav");
        if (oNav == null ) return;
  
  var sPreviousALT= sPreviousTip;
  var sNextALT= sNextTip;
  var sHTMLfile= oNav.innerHTML;

  var imgPrev= "<IMG SRC='"+previousCold+"' BORDER=0 ALT='"+ sPreviousALT +"' ALIGN='top' "+ imgStyleRTL +">";
  var imgNext= "<IMG SRC='"+nextCold+"' BORDER=0 ALT='"+ sNextALT  + "' ALIGN='top' "+ imgStyleRTL +">";
  
  var previousNextObject= "<OBJECT ID='HTMlist' WIDTH=100 HEIGHT=51 " + sActX_TDC +"><param name='DataURL' value='"
		+sHTMLfile +"'><param name='UseHeader' value=True></OBJECT>";
	  
        oNav.innerHTML= "<TABLE WIDTH='100%' STYLE='margin-top:0;' cellspacing=0>"
		+ "<TR><TD style='text-align=left; background-color:transparent'><A ID='previousLink' HREF='#' REL='previous' CLASS='navbar'>"
        +imgPrev + "</A></TD><TD width='100%' align='center'></td><TD style='text-align=right; background-color:transparent'><A ID='nextLink' HREF='#' REL='next' CLASS='navbar'>"
		+imgNext+ "</A></TD></TR></TABLE>";
					
	  document.body.innerHTML= document.body.innerHTML +  previousNextObject;
	  findPageSeq();
	  if (printing == true) return;
      var  thisLoc= document.location.href +"#";

	  if (previousLink.href== thisLoc) previousLink.style.display="none";
	  else  previousLink.style.display="block";

	  if (nextLink.href== thisLoc) nextLink.style.display="none";
	  else  nextLink.style.display="block";
	  
}

function findPageSeq() {

var rs= HTMlist.recordset;
var thisLoc= document.location.href;
var iLoc= thisLoc.lastIndexOf("/");

    if (iLoc > 0) thisLoc= thisLoc.substring(iLoc+1, thisLoc.length);
	
	
	if (nav.style == "[object]") {
				nav.style.visibility="hidden";
				printing = false;
				}
		else
			{
				printing = true;
				return;
			}
	
   	
    rs.moveFirst();
	   
	while (!rs.EOF) {
	      if (thisLoc == rs.fields("HTMfiles").value){
		      nav.style.visibility="visible"; 
  	          rs.MoveNext();
			  break;
		  }
		  previousLink.href=rs.fields("HTMfiles").value;	  
		  rs.moveNext();
     }
				
	  if (!rs.EOF) nextLink.href=rs.fields("HTMfiles").value;
}
	
//******Re-usable text ********************************************************************************************* 
// Inserts the Tabular Data Control (TDC) object at the end of the page 
// Inserts "re-usable text" from the txt file at: <span id="@@CHM_name@@@@index#@@" class="reuse"></span>
// e.g.<span id="printing4" class="reuse"></span> for record#4 in the printing.txt in printing.chm.

// <SMARTREUSABLETEXT>

// addReusableText() - called during document load to find all references
// render time bound <SPAN> contents.  Extracts content resources from reusable.xml.
//
// "class" names bound (reuse, smart)
// "reuse" static lookup of commonly referred to text.
// "smart" dynamic lookup of navigation text relevent 
//         to the shell presentation of the start menu 
//         and the control panel, (simple and classic), for the logged on user.
//         Requires inserting custom <OBJECT> supported by Help and Support Services viewer.
//         Currently not available from HTML Help control. 2000/01/12.
//
function smarthelperror(){
	// alert("error - error")
	addReusableText();
	
	insertImages();
	return true;
	// alert("error - error")
	}

//var obj = window.document.createElement("OBJECT");
	
function load_object(){
			if(!isIE6) return;
			
			//window.onerror = smarthelperror;
		try{
			var obj = window.document.createElement("OBJECT");
			var sActX_PCHealth = "CLSID:FC7D9E02-3F9E-11d3-93C0-00C04F72DAF7";
           objLoaded = true;    
           obj.width = 1;
           obj.height = 1;
		
           obj = document.body.insertAdjacentElement("beforeEnd", obj)
           obj.id = "pchealth";
           obj.classid = sActX_PCHealth;
	      // alert("success")
		  }
	    catch(e){}
       }

function addReusableText(){
	if (isIE4) return;    // no reusable text for IE4
   var coll = document.all.tags("SPAN");
   var xmlLoaded = false;
   var control = null;
   var thisID;
   var strKey;
   var text;

   // original error text
   text = "OXO";

   //<SMARTREUSABLETEXT>
   //queried state of shell presentation for start menu and control panel.
   var menuSimple = false;
   var controlSimple = false;

   // holds calculated lookup suffixes for smart class items.
   var strSuffixStartMenuOnly = "";
   var strSuffixStartMenuAndControlPanel = "";

   // smart class UserSettings Interface classid
   var sActX_PCHealth = "CLSID:FC7D9E02-3F9E-11d3-93C0-00C04F72DAF7";

   // smart class lookup suffixes per shell presentation mode.
   // TODO: Findout where these constants are best documented.
   var strMenuClassic =   "_smclassic";
   var strMenuSimple =    "_smsimple";
   var strCPanelClassic = "_cpclassic";
   var strCPanelSimple =  "_cpsimple";

   // only attempt to query once per rendering
   var bPresentationModeQueried = false;
   //</SMARTREUSABLETEXT>
	span_count = coll.length;
   // Check every span in the document.
   for (var i=0; i< span_count; i++) {
	
      var thisSpan = coll[i];
      var spanClass = thisSpan.className.toLowerCase();
      if (spanClass == "reuse" || spanClass == "smart") {
         if (isRTL) thisSpan.dir = "rtl";
         if (thisSpan.id == null) break;

         // strKey is the key we'll use to look up the replaceable text in the XML file
         strKey = thisSpan.id.toLowerCase();
		 
        
		   
         // skip smart tags when defaults are not present
         if ((defaultSKUSettingsURL != null) && (xmldocSKUSettings.documentElement != null)) {
            if (spanClass == "smart") {
			 
               // Query Presentation Mode once per rendering.
               if (!bPresentationModeQueried) {
				
                  bPresentationModeQueried=true;

                  // Set To Defaults
                  if (defaultStartMode != null) {
                     menuSimple = (defaultStartMode.text == strMenuSimple);
                  } else {
                     menuSimple = true;
                  }

                  if (defaultCPanelMode != null) {
                     controlSimple = (defaultCPanelMode.text == strCPanelSimple);
                  } else {
                     controlSimple = true;
                  }
           			
                  
                    
                 // alert("inside of reuse")

                  // Get the current user's presentation settings
                  // Attempt to read smart help values from system
                  var test = window.document.all("pchealth");
				  
                  if (test != null) {
				  	
                     if (test.UserSettings != null) {                        
                          
                   
							menuSimple = test.UserSettings.IsStartPanelOn;
					
							controlSimple = test.UserSettings.IsWebViewBarricadeOn;
												
                        
                     }
					 else
					 {
					 	menuSimple = (defaultStartMode.text == strMenuSimple)
						controlSimple = (defaultCPanelMode.text == strCPanelSimple);
					}
					         
                         
                    
						
                 }// (test != null)

              }// (!bPresentationModeQueried)

              // get the error text to display
              text = smartErrorText;

              // Build key suffixes. One for start menu only and one for start menu and control panel.
              strSuffixStartMenuOnly = (menuSimple ? strMenuSimple : strMenuClassic);
              strSuffixStartMenuAndControlPanel = strSuffixStartMenuOnly + (controlSimple ? strCPanelSimple : strCPanelClassic);

              // The actual key could have either strSuffixStartMenuOnly or strSuffixStartMenuAndControlPanel suffixes.
              // strSuffixStartMenuAndControlPanel has precedence over strSuffixStartMenuOnly
              strKey = strKey + strSuffixStartMenuAndControlPanel;
				//alert(strKey)
            }//if (spanClass == "smart")

         }// ((defaultSKUSettingsURL != null) && (xmldocSKUSettings.documentElement != null))

         // Lookup XML node containing reference

         var strNodeSelector = "glossSection/entry[@entryID='" + strKey + "']/scopeDef/def";
         var node = xmldoc.documentElement.selectSingleNode(strNodeSelector);

         // if we haven't found the node yet, try the other suffix if this is a smart span
         if (node == null && spanClass == "smart" && (defaultSKUSettingsURL != null) && (xmldocSKUSettings.documentElement != null)) {
            // one more try--use the other suffix
            strKey = thisSpan.id.toLowerCase() + strSuffixStartMenuOnly;
            strNodeSelector = "glossSection/entry[@entryID='" + strKey + "']/scopeDef/def";
            node = xmldoc.documentElement.selectSingleNode(strNodeSelector);
         }

		// okay, we found the node, get the text
		 // alert(coll.length)
         if (node != null) {
            // replace the span's contents with the reusable text
			thisSpan.insertAdjacentHTML("BeforeBegin",node.text);
			// var coll = document.all.tags("SPAN");
			thisSpan.className = "anything"
			thisSpan.innerHTML = "";
			//alert(node.text)
             //thisSpan.innerHTML = node.text;
         } else {
		 		// error shown by this  OXO
               thisSpan.innerHTML = text;
         }
		
      } // if (spanClass == "reuse" || spanClass == "smart")
   }// for

}// addReusableText()
// <SMARTREUSABLETEXT>


//****** insertImages ********************************************************************************************* 
//  Inserts shared images in User-Defined Variables section and thumbnails.
var booking = false;
function insertImages(){

if (printing == false) booking = true;
if (printing == true && booking == true ) {
	booking = false;
	return;
	}
// insert alert icons
  var collP = document.all.tags("P");
  
  for (var i=0; i<collP.length; i++) {
       if (collP[i].className.toLowerCase()=="note")            collP[i].innerHTML ="<img class='alert' src='"+noteImg+"' "+ imgStyleRTL +"> " +     collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="warning")    collP[i].innerHTML ="<img class='alert' src='"+warningImg+"'> " +  collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="caution")    collP[i].innerHTML ="<img class='alert' src='"+cautionImg+"'> " +  collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="tip")        collP[i].innerHTML ="<img class='alert' src='"+tipImg+"'> " +      collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="important")  collP[i].innerHTML ="<img class='alert' src='"+importantImg+"'> " + collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="empty")      collP[i].innerHTML ="<img class='alert' src='"+emptyImg+"'> " +    collP[i].innerHTML;
	   if (collP[i].className.toLowerCase()=="reltopics" && rel_gif == "yes")  {
			collP[i].outerHTML ="<img class='relTopics' src='"+relTopicsImg+"'> " + collP[i].outerHTML;
			}   
  		}
  
//alert(printing)
//alert(isIE55)
//indents for Navigation Tree 
var collUL = document.all.tags("UL");
if (!printing) {
for (var i=0; i<collUL.length; i++) {
       var indent= 0;
       if (collUL[i].className.toLowerCase()=="navtree"){
	       if (isRTL) collUL[i].style.listStyleImage= "url('" + branchImg_RTL + "')";
		   else collUL[i].style.listStyleImage= "url('" + branchImg + "')";
  		   for (var j = 0; j < collUL[i].children.length; j++)
				if (collUL[i].children[j].className.toLowerCase()=="branch"){
					if (isRTL) collUL[i].children[j].style.marginRight= (indent +'em');
					else   collUL[i].children[j].style.marginLeft= (indent +'em');
					indent= indent + 0.75;
				}
	  }
}
}
   
  for (var i=0; i < document.anchors.length; i++){
         var imgInsert="";  
		 var imgStyle= "";
		 var imgSpace= "<span class='space'></span>";      
		 var oBefore=document.anchors[i].parentElement.tagName;
		 var oAnchor= document.anchors[i].id.toLowerCase();
         
// insert RELTOPICS icons
	if (rel_gif == "yes"){
       if (oAnchor=="reltopics")
	   		if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "reltopics")
			        imgInsert= "";    // not to re-insert when persistent
			else  imgInsert= "<img class='relTopics' src='"+relTopicsImg+"'>" + imgSpace;
		}
		
// insert SHORTCUT icons
       if (oAnchor=="shortcut") {    
 	       document.anchors[i].title= sShortcutTip;     
		    if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "shortcut")
			        imgInsert= "";    // not to re-insert when persistent
			else  imgInsert= "<img class='shortcut' src='"+shortcutCold+"' "+ imgStyleRTL+ ">" + imgSpace;
		}	
		   		   
// insert POPUP icons
       else if (oAnchor=="wpopup" || oAnchor=="wpopupweb") document.anchors[i].title= sPopupTip;
       else if (document.anchors[i].className.toLowerCase()=="popupicon")
		    if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "popup")
			       imgInsert= "";    // not to re-insert when persistent
	        else imgInsert= "<img class='popup' src='"+popupCold+"'>" + imgSpace;

// insert EXPAND icons 
       else if (oAnchor=="expand") {
	          document.anchors[i].title= sExpandTip;
              if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "expand")
		          imgInsert= ""; 	// not to re-insert when persistent	  
              else{ 
			      if (document.anchors[i].parentElement.offsetLeft == document.anchors[i].offsetLeft) {
				      imgSpace= "<span class='space' style='width:0'></span>";     
				      if (isRTL){ document.anchors[i].parentElement.style.marginRight= "1.5em";  imgStyle=" style=margin-right:'-1.5em'";}
					  else { document.anchors[i].parentElement.style.marginLeft= "1.5em";  imgStyle=" style=margin-left:'-1.5em'";}
				  }	  
			      imgInsert= "<img class='expand' src='"+ closed +"' "+imgStyle+">" +imgSpace;
	          }
       }



// insert thumbnail images	   
       else if (oAnchor=="thumbnail"  || oAnchor=="thumbnailweb"){ 
            var sAltText = document.anchors[i].innerHTML;
			gifwithin = true;
		    var sThumbnailText = document.anchors[i].title; 
            var oImg = document.anchors[i].href.toLowerCase();
		          if (oAnchor=="thumbnail") 
				         var sThumbnailImg= moniker + getURL(oImg);
				  else var sThumbnailImg = document.anchors[i].href.toLowerCase();
				  
				 found = sAltText.indexOf("BACKGROUND-COLOR:")
			if (found != -1) {
				stop_p = sAltText.indexOf(">");
				sAltText = sAltText.substring(stop_p + 1, sAltText.length);
				stop_p = sAltText.indexOf("</FONT>");
				Highlighted = sAltText.substring(0,stop_p)
				sAltText = Highlighted + sAltText.substring(stop_p + 7, sAltText.length);
				}

				  
                document.anchors[i].outerHTML = "<DIV id='thumbDiv' class='thumbnail'>"+document.anchors[i].outerHTML+"</div>";
                document.anchors[i].innerHTML = "<img class='thumbnail' src='" + sThumbnailImg + "' alt= ' " + sAltText + "'><p>" +sThumbnailText+"</p>";
				
		          if (isRTL) thumbDiv.style.styleFloat= "right";
		   }
		   
		
		
 	   document.anchors[i].innerHTML = imgInsert + document.anchors[i].innerHTML;
	   if (isRTL) document.anchors[i].dir="rtl";
   }
}



//***** onclickTriage ****************************************************************************************
// redirects to the appropriate function based on the ID of the clicked <A> tag.

function onclickTriage(){
var e= window.event.srcElement;

//  if the innerHTML in the <a> tag is encapsulated by a style tag or hightlighted in the word seach,
//  the parentElement is called.

	if ((isIE55 || isIE6) && printing == true) {
		printing = false;
		reset_form();
		}
		
    for (var i=0; i < 5; i++)
           if (e.tagName!="A" && e.parentElement!=null) e= e.parentElement;
    eID= e.id.toLowerCase();
				
    if (popupOpen) closePopup();
	
// expand image in a new window
    if (eID=="thumbnail" || eID=="pophtm") popNewWindow(e);
    else if (eID=="thumbnailweb") callThumbnailWeb(e);
    else if (eID=="wpopup")    callPopup(e);
    else if (eID=="wpopupweb") callPopupWeb(e);
    else if (eID=="shortcut")  callShortcut(e);
    else if (eID=="reltopics") callRelatedTopics(e);
    else if (eID=="altloc")    callAltLocation(e);
    else if (eID=="expand")    callExpand(e);
// added to support Randy's Quad method code
	else QuadDocumentClick()
// ******************************
}


//*** gettingHot ****************************************************************************************
// Makes all the required changes for mouseover.

function gettingHot() {
var e = window.event.srcElement;
	


  if (e.id.toLowerCase()=="cold")  e.id ="hot";
  else if (e.src== previousCold)  e.src = previousHot;
  else if (e.className.toLowerCase()=="navbar" && e.children.tags("IMG")(0).src== previousCold)  e.children.tags("IMG")(0).src= previousHot;
  else if (e.src== nextCold)  e.src = nextHot;
  else if (e.className.toLowerCase()=="navbar" && e.children.tags("IMG")(0).src== nextCold)  e.children.tags("IMG")(0).src= nextHot;
  
  else if (e.className.toLowerCase()=="shortcut" && e.tagName=="IMG")  e.src = shortcutHot;		    //<img> tags have a class
  else if (e.id.toLowerCase()=="shortcut")  e.children.tags("IMG")(0).src = shortcutHot;			//<a> tags have an ID
  
  else if (e.className.toLowerCase()=="popup" && e.tagName=="IMG")  e.src = popupHot;		    //<img> tags have a class
  else if (e.className.toLowerCase()=="popupicon")  e.children.tags("IMG")(0).src = popupHot;			//<a> tags have an ID
  
  else if ((e.className.toLowerCase()=="expand" && e.tagName=="IMG") ||( e.id.toLowerCase()=="expand")) expandGoesHot(e);
 
 // Added to support Quad Method   **************************
	if (e != null && e.firstChild != null && 
		e.firstChild.tagName != null &&
	    e.firstChild.tagName.toLowerCase() == "input" && 
	    e.firstChild.type.toLowerCase() == "radio" && 
	    e.parentElement.className != "indentGray"){
			QuadDocumentMouseOver()
			}

// *****************************
}

//*** gettingCold **************************************************************************************
// Initial state for mouseout.

function gettingCold() {
var e = window.event.srcElement;



  if (e.id.toLowerCase()=="hot")  e.id ="cold";
  else if (e.src== previousHot)  e.src = previousCold;
  else if (e.className.toLowerCase()=="navbar" && e.children.tags("IMG")(0).src== previousHot)  e.children.tags("IMG")(0).src= previousCold;
  else if (e.src== nextHot)  e.src = nextCold;
  else if (e.className.toLowerCase()=="navbar" && e.children.tags("IMG")(0).src== nextHot)  e.children.tags("IMG")(0).src= nextCold;
  
  else if (e.className.toLowerCase()=="shortcut" && e.tagName=="IMG")   e.src = shortcutCold;		//<img> tags have a class
  else if (e.id.toLowerCase()=="shortcut")  e.children.tags("IMG")(0).src= shortcutCold;		 	//<a> tags have an ID
  
  else if (e.className.toLowerCase()=="popup" && e.tagName=="IMG")   e.src = popupCold;		//<img> tags have a class
  else if (e.className.toLowerCase()=="popupicon")  e.children.tags("IMG")(0).src= popupCold;		 	//<a> tags have an ID
  
  else if ((e.className.toLowerCase()=="expand" && e.tagName=="IMG") ||( e.id.toLowerCase()=="expand")) expandGoesCold(e);
  
  // Added to support Quad Method   **************************
	if (e != null && e.firstChild != null && 
		e.firstChild.tagName != null &&
	    e.firstChild.tagName.toLowerCase() == "input" && 
	    e.firstChild.type.toLowerCase() == "radio" && 
	    e.parentElement.className != "indentGray"){
			QuadDocumentMouseOver()
			}

// *****************************
}

//****************************************** OBJECT CONSTRUCTION **************************************
//*****************************************************************************************************
//  Uses an A tag to pass parameters between an HTML page and this script.
//  Creates an ActiveX Object from these parameters, appends the Object to the end of the page,
//  and clicks it. These objects relate to HTMLHelp environment and information about them can be found on the http://HTMLHelp site.

//  Object construction variables *********************************************************************

var sParamCHM,sParamFILE, sParamEXEC, sParamMETA,iEND;
var sActX_HH= " type='application/x-oleobject' classid='clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11' ";


//*** callPopup ***************************************************************************************
// creates an object from an <A> tag HREF, the object inserts a winhelp popup
// called by: <A ID="wPopup" HREF="HELP=@@file_name.hlp@@ TOPIC=@@topic#@@">@@Popup text@@</A>

var joker = false;
var blague = true;

function callPopup(eventSrc) {
if (popupOpen) closePopup();
var ntsharedAdded= false;					// make sure the object is only added once
var CHMspecificAdded= false;				// make sure the object is only added once
var coll = document.all.tags("SPAN");
var sIndex,sText=" ",sFile,sFileID,dataBindingObject;

	 var e= eventSrc;
	 var eH= unescape(e);
	 eH = eH.toLowerCase();
	 var eH_= eH.toLowerCase();
	 
	 if(event){
	 	event.returnValue = false;
		}
	 found = false;
												   	
  	 var iTOPIC = eH.lastIndexOf("topic=");
     if (iTOPIC==-1) return;
	 sParamTOPIC = eH.substring((iTOPIC+6),eH.length);
	 if (!isIE4){
	 if (!joejoe){
		xmldom.load(moniker + path2glossary + "local/glossary.xml");
		joejoe = true;
		}
	 	
		var o=0;
		var node = "";	
		node = xmldom.selectSingleNode("glossary/glossSection/entry[@entryID='" + sParamTOPIC + "']");
					
		if(node!=null)
			{
			
			found = true;
			var ralf = "";
			ralf = node.getElementsByTagName("term")
			sText = "<DIV CLASS='PopTerm'>" + ralf.item(0).nodeTypedValue + "</DIV>";
			ralf = node.getElementsByTagName("para")
			
			if (ralf.length != 0){
				sText = sText + "<DIV CLASS='PopDef'>" + ralf.item(0).nodeTypedValue;
				sText = sText + "</DIV>";
				}
			seealsos = node.getElementsByTagName("seeAlso");
			var o=0;
			
			look_at = xmldom.getElementsByTagName("glossary/locSection/locItem[@locItemID = 'SeeAlso']");
						
			while (o < seealsos.length){
		    	sIndex = seealsos.item(o).getAttribute("seeAlsoTermID");
				node = xmldom.selectSingleNode("glossary/glossSection/entry[@entryID='" + sIndex + "']");
				ralf = node.getElementsByTagName("term");
				sTerm = ralf.item(0).nodeTypedValue;
				if (o == 0) {
					sText = sText + "<DIV CLASS='PopSeeAlso'>" + look_at.item(0).nodeTypedValue + "&nbsp;"
					// sIndex = "<Input type=submit tabindex=1 value=hhhh onclick='jscript:alert(oPopup.sIndex.innerHTML)'>"
					sIndex = "<A ID='wPopup' HREF='HELP=glossary.hlp TOPIC=" + sIndex + "' bite_me='1'>" + sTerm + "</a>"
					}
				else
					{
					sIndex = ", <A ID='wPopup' HREF='HELP=glossary.hlp TOPIC=" + sIndex + "' bite_me='1'>" + sTerm + "</a>"
					}
				o++;
				sText = sText + sIndex 
				}
					
			definition = xmldom.getElementsByTagName("glossary/locSection/locItem[@locItemID = 'See']");		
			
			seeentrys = node.getElementsByTagName("seeEntry");
							
			while (o < seeentrys.length){
		    	sIndex = seeentrys.item(o).getAttribute("seeTermID");
				node = xmldom.selectSingleNode("glossary/glossSection/entry[@entryID='" + sIndex + "']");
				ralf = node.getElementsByTagName("term");
				sTerm = ralf.item(0).nodeTypedValue;
				if (o == 0) {
					sText = sText + "<DIV CLASS='PopSeeAlso'>" + definition.item(0).nodeTypedValue + "&nbsp;"
					// sIndex = "<Input type=submit tabindex=1 value=hhhh onclick='jscript:alert(oPopup.sIndex.innerHTML)'>"
					sIndex = "<A ID='wPopup' HREF='HELP=glossary.hlp TOPIC=" + sIndex + "' bite_me='1'>" + sTerm + "</a>"
					}
				else
					{
					sIndex = ", <A ID='wPopup' HREF='HELP=glossary.hlp TOPIC=" + sIndex + "' bite_me='1'>" + sTerm + "</a>"
					}
				o++;
				sText = sText + sIndex 
				}
			}
			
			if (o != 0) sText = sText + "</DIV>" 
			 
			if ((isIE55 || isIE6) && found){
				var oPopup = false
				var oPopup = window.createPopup();
 				var strScript = "<script language='JScript'> function clickPopup(){if (event.srcElement.tagName.toLowerCase() == 'a') parent.callPopup(event.srcElement.href); window.PopObject.hide(); return false;}</script>";
  				var strDoc = oPopup.document.body.outerHTML.toLowerCase()
				
 			 	oPopup.document.write(strDoc.replace("></body>", " onclick=\"clickPopup()\">" + strScript + "</body>"));
				//oPopup.document.write(strDoc.replace("></body>", " onclick=\"clickPopup()\, onkeypress=\"process_closePopup()\">" + strScript + "</body>"));
   		 		oPopup.document.createStyleSheet(sSharedCHM + "local/Classic.css");	// Apply the stylesheet.
				var oPopBody = oPopup.document.body;
				
				//oPopBody.style.backgroundColor = '#FFFFCC';
				
  			    // oPopBody.style.border = "solid black 1px";
  			    oPopBody.style.margin = "0 0 0 0";
				if (isRTL) oPopBody.innerHTML = "<SPAN DIR='RTL' class='XMLPopup'>" + sText + "</SPAN>"   		// need to add the style class here.
				else oPopBody.innerHTML = "<SPAN class='XMLPopup'>" + sText + "</SPAN>"
					// alert(oPopBody.innerHTML)				
				if (window.event){
					joker = window.event.srcElement;
					}
				oPopup.show(0, 0, 400, 8, joker);	// Show the popup at an arbitrary size.
				var textSize = oPopBody.createTextRange();
		        var wPop = textSize.boundingWidth + oPopBody.offsetWidth - oPopBody.clientWidth;	// Get the size of the text.
				var hPop = oPopBody.scrollHeight;
		        oPopup.hide();
				oPopup.document.parentWindow.PopParent = window;
			  	oPopup.document.parentWindow.PopObject = oPopup;
				
		  	    oPopup.show(0, 1, wPop , hPop, joker);
				//oPopup.document.focus(oPopup.document.body.JOKER);	
				return;
				}
			
			if (found){
				if (blague){
				document.body.insertAdjacentHTML("beforeEnd", "<DIV id='wPopupWeb' CLASS='popup'>" + sText + "</DIV>");
				blague = false;
				}
				window.wPopupWeb.innerHTML = sText;
			    callPopupWeb(e);
				return;
				}
			} // for support of IE4 disable xml popups
				  
   var iTOPIC = eH_.lastIndexOf("topic=");
        if (iTOPIC==-1) return;
        sParamTOPIC = eH.substring((iTOPIC+6),eH.length);  		// extracts the topic for item2
		
  var iHELP = eH_.lastIndexOf("help=");
        if (iHELP==-1) return;
        sParamHELP = eH.substring(iHELP+5,iTOPIC);			// extracts the help file for item1
		
        if (document.hhPopup) document.hhPopup.outerHTML = "";	// if hhPopup object exists, clears it


 var  h= "<object id='hhPopup'"+ sActX_HH + "STYLE='display:none'><param name='Command' value='WinHelp, Popup'>";
      h= h + "<param name='Item1' value='" + sParamHELP + "'><param name='Item2' value='" + sParamTOPIC + "'></object>";
		
        document.body.insertAdjacentHTML("beforeEnd", h);     
        document.hhPopup.hhclick();
}


//*** callAltLocation******************************************************************************
// creates an object from an <A> tag HREF, the object will navigate to the alternate location if the first location is not found.
// called from: <A ID="altLoc" HREF="CHM=@@1st_chm_name.chm;Alt_chm_name.chm@@  FILE=@@1st_file_name.htm;Alt_file_name.htm@@">@@Link text here@@</A>
   

function callAltLocation(eventSrc) {
var e= eventSrc;
var eH= unescape(e.href);
var eH_= eH.toLowerCase();
var sFILEarray,sCHMarray;
     event.returnValue = false;
	 
// var sParamTXT= e.innerHTML;
//      sParamTXT= sParamTXT.replace(semicolon,"");
      
   var sParamTXT= "";
		   							
  var iFILE = eH_.lastIndexOf("file=");
        if (iFILE==-1) return;
        sParamFILE= eH.substring((iFILE+5),eH.length);  			    // extracts the 2 HTM files
		sParamFILE= sParamFILE.replace(spaces,"");
		iSPLIT= sParamFILE.match(semicolon);
		if (iSPLIT)
  		    sFILEarray = sParamFILE.split(";");										// separates the 2 HTM files
		else return;
  		
  var iCHM  = eH_.lastIndexOf("chm=");
        if(iCHM==-1) return;
        else         sParamCHM = eH.substring(iCHM+4,iFILE);			// extracts the 2 CHM's
		sParamCHM= sParamCHM.replace(spaces,"");
		iSPLIT= sParamCHM.match(semicolon);
		if (iSPLIT)
		    sCHMarray= sParamCHM.split(";");									// separates the 2 CHM's
		else return;
		
		sParamFILE= moniker + sCHMarray[0]+ "::/" + sFILEarray[0] + ";" + moniker + sCHMarray[1]+ "::/" + sFILEarray[1];
				
        if (document.hhAlt) document.hhAlt.outerHTML = "";			    // if hhAlt object exists, clears it

 
  var h= "<object id='hhAlt'"+ sActX_HH + "STYLE='display:none'><PARAM NAME='Command' VALUE='Related Topics'>";
      h= h + "<param name='Item1' value='" + sParamTXT +";" + sParamFILE + "'></object>";
	
        document.body.insertAdjacentHTML("beforeEnd", h); 
        document.hhAlt.hhclick();
}


//*** callRelatedTopics******************************************************************************
// creates an object from an <A> tag HREF, the object inserts a popup of the related topics to select
// called from: <A ID="relTopics" HREF="CHM=@@chm_name1.chm;chm_name2.chm@@ META=@@a_filename1;a_filename2@@">Related Topics</A>
   

function callRelatedTopics(eventSrc) {
var e= eventSrc;
var eH= unescape(e.href);
var eH_= eH.toLowerCase();
     event.returnValue = false;
		   							
  var iMETA = eH_.lastIndexOf("meta=");
        if (iMETA==-1) return;
        sParamMETA = eH.substring((iMETA+5),eH.length);  			// extracts the META keywords for item2
		
  var iCHM  = eH_.lastIndexOf("chm=");
        if(iCHM==-1) sParamCHM = "";
        else         sParamCHM = eH.substring(iCHM+4,iMETA);			// extracts the CHM files for item1
	
        if (document.hhRel) document.hhRel.outerHTML = "";			// if hhRel object exists, clears it

 
  var h= "<object id='hhRel'"+ sActX_HH + "STYLE='display:none'><param name='Command' value='ALink,MENU'>";
      h= h + "<param name='Item1' value='" + sParamCHM + "'><param name='Item2' value='" + sParamMETA + "'></object>";
	
        document.body.insertAdjacentHTML("beforeEnd", h);     
        document.hhRel.hhclick();
}

//*** popNewWindow***************************************************************************************
// creates an object from an <A> tag HREF, the object then opens a new window from the image URL found in the HREF
// called from: <a id="thumbnail" title="Enlarge figure" href="CHM=NTArt.chm FILE=@@image_name.gif@@">@@alt text here@@</A>
// the thumbnail image is loaded by loadPage();


function popNewWindow(eventSrc) {
var eH= eventSrc.href;
      event.returnValue = false;
	  
 // extracts the thumbnail image URL from the <a> tag HREF
    sParamFILE =  getURL(eH);
    if (sParamFILE=="") return;
	
	// sParamFILE = moniker + sParamFILE; 
	// sParamFILE = moniker + sParamFILE; 
	//alert(sParamFILE)
	// callThumbnailWeb(sParamFFILE)
	
	   
 // if the hhWindow object exists, clears it
    if (document.hhWindow) document.hhWindow.outerHTML = "";		
		
var  h =  "<object id='hhWindow'"+ sActX_HH +" STYLE='display:none'><param name='Command' value='Related Topics'>";
     h = h + "<param name='Window' value='$global_largeart'><param name='Item1' value='$global_largeart;" + moniker + sParamFILE+ "'> </object>";
	
     document.body.insertAdjacentHTML("beforeEnd", h);
     document.hhWindow.hhclick();
}

//*** callShortcut ***************************************************************************************
// creates an object from an <A> tag, the object then calls the executable code
// called from: <A ID="shortcut" HREF="EXEC=@@executable_name.exe@@ CHM=ntshared.chm FILE=@@error_file_name.htm@@">@@Shortcut text@@</A>
// the shortcut image is loaded by loadInitialImg();

function callShortcut(eventSrc) {
var e= eventSrc;
var eH= unescape(e.href);
var eH_= eH.toLowerCase();

	

    event.returnValue = false;
	   	   
 // extracts the error file URL from the <a> tag HREF
	iEND= eH.length;
    sParamFILE =  getURL(eH);
	
var iEXEC = eH_.lastIndexOf("exec="); 
        if (iEXEC==-1) return;
        else sParamEXEC = eH.substring(iEXEC+5,iEND);				// extracts the executable for item1
		
        if (document.hhShortcut) document.hhShortcut.outerHTML = "";			// if the hhShortcut object exists, clears it
	
var  h =  "<object id='hhShortcut'"+ sActX_HH +" STYLE='display:none'> <param name='Command' value='ShortCut'>";
     if(sParamFILE != "") h = h + "<param name='Window' value='" + moniker + sParamFILE+ "'>";
     h = h + "<param name='Item1' value='" + sParamEXEC + "'><param name='Item2' value='msg,1,1'></object>";

        document.body.insertAdjacentHTML("beforeEnd", h);
        document.hhShortcut.hhclick();
}

//****************************************  EXPAND FUNCTIONS *********************************************************
//********************************************************************************************************************

//**  callExpand **************************************************************************************************
//  This expands & collapses (based on current state) "expandable" nodes as they are clicked.
//  Called by: <A ID="expand" href="#">@@Hot text@@</A>
//  Followed by:  <div class="expand">

function callExpand(eventSrc) {

var e= eventSrc;
    event.returnValue = false;					// prevents navigating for <A> tag
	
var oExpandable = getExpandable(e); 
var oImg = getImage(e);

     if (oExpandable.style.display == "block")
	      doCollapse(oExpandable, oImg);
     else doExpand(oExpandable, oImg);
}

//** expandGoesHot *********************************************************************************************
// Returns expand image to hot. 

function expandGoesHot(eventSrc){
var e= eventSrc;
//alert(e.outerHTML);
var oExpandable = getExpandable(e);
  
var oImg = getImage(e);
//alert (oImg.src)
if (oExpandable == false){
	plus_or_minus = oImg.src.indexOf("minus")
	if (plus_or_minus == -1){
		//alert(plus_or_minus)
		oImg.src = closedHot
		}
	else
		{
		oImg.src = expandHot;
		//alert(plus_or_minus)
		}
	 return;
	}

if (!isIE4){
   if (oExpandable.style.display == "block"){
   		 oImg.src = expandHot;
		 //alert(oImg.src)
		 }
   else oImg.src = closedHot;
}
}


//** expandGoesCold *********************************************************************************************
// Returns expand image to cold.

function expandGoesCold(eventSrc){
var e= eventSrc;

var oExpandable = getExpandable(e);
var oImg = getImage(e);
// alert (oImg.src)

if (oExpandable == false){
	plus_or_minus = oImg.src.indexOf("minus")
	
	if (plus_or_minus == -1){
		//alert(plus_or_minus)
		oImg.src = closed
		}
	else
		{
		oImg.src = expand;
		//alert(plus_or_minus)
		}
	 return;
	}

 
if (!isIE4){
 if (oExpandable.style.display == "block") oImg.src = expand;
  else oImg.src = closed;
}  
}


//** getExpandable *****************************[used by callExpand, expandGoesHot, expandGoesCold]*******
//  Determine if the element is an expandable node or a child of one.  

function getExpandable(eventSrc){
var  e = eventSrc;
var iNextTag, oExpandable;
	
       for (var i=1;i<4; i++){
               iNextTag=    e.sourceIndex+e.children.length+i;
              oExpandable= document.all(iNextTag);
              if (oExpandable.className.toLowerCase()=="expand" || iNextTag == document.all.length)
			  	return oExpandable
                   break;
       }
       return false;
	   
}

//**  getImage ***********************************[used by callExpand, expandGoesHot, expandGoesCold]*******
//  Find the first image in the children of the current srcElement.   
// (allows the  image to be placed anywhere inside the <A HREF> tag)

function getImage(header) {
var oImg = header;

       if(oImg.tagName != "IMG") oImg=oImg.children.tags("IMG")(0);
       return oImg;
}


//****  expandAll *******************************************************************************************************
//  Will expand or collapse all "expandable" nodes when clicked. [calls closeAll()]
//  called by: <A HREF="#" onclick="expandAll();">expand all</A>

var stateExpand = false;    //applies to the page 

//**** ****************************************************************************************************************

function expandAll() {
var oExpandToggle, oImg;
var expandAllMsg = "expand all";					//message returned when CloseAll() is invoked
var closeAllMsg = "close all";						//message returned when ExpandAll() is invoked
var e= window.event.srcElement;
       event.returnValue = false;

       for (var i=0; i< document.anchors.length; i++){
               oExpandToggle = document.anchors[i];
		 
                if (oExpandToggle.id.toLowerCase() == "expand"){ 
                     oExpandable = getExpandable(oExpandToggle);  
                     oImg = getImage(oExpandToggle);
			 
                     if (stateExpand == true) doCollapse(oExpandable, oImg);
                     else                     doExpand(oExpandable, oImg);
                }
       }
       if (stateExpand == true) {
            stateExpand = false;
            e.innerText= expandAllMsg;
       }
       else {
            stateExpand = true;
            e.innerText= closeAllMsg;
       }
}


//****  doExpand *******************************************************************************************************
//  Expands expandable block & changes image
	
var redo = false;	
function doExpand(oToExpand, oToChange) {
var oExpandable= oToExpand;
var oImg= oToChange;

//	if (printing == "TRUE") return;

	oImg.src = expand;
	oExpandable.style.display = "block";
	
	if (!redo && isIE4) {
		// alert("what")
		redo = true;
    	// focus(oToExpand);
		doExpand(oToExpand, oToChange);
		}
	}


//****  doCollapse *****************************************************************************************************
//  Collapses expandable block & changes image
	
function doCollapse(oToCollapse, oToChange) {
// if (printing == "TRUE") return;
var oExpandable= oToCollapse;
var oImg= oToChange;

    oExpandable.style.display = "none";
    oImg.src = closed;
}

//*******************************************************************************************************
//******* WEB  FUNCTIONS **************************************************************************
//*******************************************************************************************************

//**** callThumbnailWeb **************************************************************************************

function callThumbnailWeb(eventSrc) {
var e= eventSrc;
       event.returnValue = false;
	   	   	  
var thumbnailWin= window.open (e.href, "height=450, width=600, left=10, top=10, dependent=yes, resizable=yes, status=no, directories=no, titlebar=no, toolbar=yes, menubar=no, location=no","true");

thumbnailWin.document.write ("<html><head><title>Windows 2000</title></head><body><img src='"+e.href+"'></body></html>");

return;
}

//*********************************************************************************************************
//*********************************************************************************************************
								
var popupOpen= false;				//state of popups
var posX, posY;						//coordinates of popups
var oPopup;							//object to be used as popup content

//**** callPopupWeb **************************************************************************************
// the web popups have been converted from the object winHelp popup for the web.
// called by: <A ID="wPopupWeb" HREF="#">@@Popup text@@</A>
// followed by: <div class="popup">Popup content</div>


function callPopupWeb(eventSrc) {
var e= eventSrc;
  
  // find the popup <div> that follows <a id="wPopupWeb"></a>
  findPopup(e);
  if (!e.bite_me) positionPopup(e)

  oPopup.style.visibility = "visible";
  // document.focus(e)
  popupOpen = true;

  return;
}

//**** findPopup ****************************************************************************************

function findPopup(oX){
var e= oX;
var iNextTag;
	
    for (var i=1;i<document.all.length; i++){
         iNextTag=    e.sourceIndex + i;
         oPopup= document.all(iNextTag);
         if (oPopup.className.toLowerCase()=="popup" || iNextTag == document.all.length)
             break;
    }
	
    if (iNextTag != document.all.length) {
        posX = window.event.clientX; 
        posY = window.event.clientY + document.body.scrollTop+10;
	}
	if (popupOpen) closePopup();
}


//****  positionPopup ************************************************************************************
// Set size and position of popup.
// If it is off the page, move up, but not past the very top of the page.

function positionPopup(oX){
var e= oX;	
var popupOffsetWidth = oPopup.offsetWidth;

//determine if popup will be offscreen to right
var rightlimit = posX + popupOffsetWidth;
 
  if (rightlimit >= document.body.clientWidth) 
      posX -= (rightlimit - document.body.clientWidth);
  if (posX < 0) posX = 0;
	
//position popup
  oPopup.style.top = posY;
  oPopup.style.left = posX;

var pageBottom = document.body.scrollTop + document.body.clientHeight;
var popupHeight = oPopup.offsetHeight;
  
  if (popupHeight + posY >= pageBottom) {
      if (popupHeight <= document.body.clientHeight)
          oPopup.style.top = pageBottom - popupHeight;
      else
           oPopup.style.top = document.body.scrollTop;
  }
}

//**** closePopup ****************************************************************************************
// Close Popup
function closePopup() {

  oPopup.style.visibility = "hidden";
  popupOpen = false;
  return;
}


//*********************************************  GENERAL FUNCTIONS ************************************************
//**************************************************************************************************************************

//***ajustImg *************************************************************************************************************
// expands an image to the with of the window or shrinks it to 90px

function ajustImg(eventSrc) {
var e= eventSrc;
var fullWidth= document.body.offsetWidth;

    fullWidth = fullWidth - 50;
    if (e.style.pixelWidth==90)
         e.style.pixelWidth=fullWidth;
    else e.style.pixelWidth=90;
}


//**  getURL **************************************[used in callShortcut, popNewWindow& loadPage]********
// extracts the file location (CHM::/HTM) URL 

function getURL(sHREF) {
var spaces= /\s/g
var eH = unescape(sHREF);
	eH = eH.replace(spaces,""); 

var eH_= eH.toLowerCase();
var sParamFILE= "";
var sParamCHM= "";

var iFILE= eH_.lastIndexOf("file=");
    if (iFILE!=-1){
	    iEND= iFILE +1;
        sParamFILE = eH.substring(iFILE+5,eH.length);
    }

var iCHM  = eH_.lastIndexOf("chm=");

gifwithin = false; 
if (gifwithin){
	gifwithin = false;
	var con_mmc;
	var doc_mmc;
	doc_mmc = " " + document.location;
	doc_mmc = doc_mmc.toLowerCase();
	if (iCHM!=-1){
        iEND  = iCHM +1; 							// iEND used by callShortcut
        sParamCHM = eH.substring(iCHM+4, iFILE);
		con_mmc = doc_mmc.indexOf(sParamCHM);
			if (con_mmc != -1){
				sParamCHM = "";
				iCHM = -1;
			sParamFILE= sParamCHM+sParamFILE;	
			}
		}
	}

	 if (iCHM!=-1){
        iEND  = iCHM +1; 							// iEND used by callShortcut
        sParamCHM = eH.substring(iCHM+4, iFILE);
		sParamFILE= sParamCHM+"::/"+sParamFILE;	
    	}	
	return sParamFILE;
}
//****************************************************************************************************************************
//********************************************  IE5 PERSISTENCE  *************************************************************
//****************************************************************************************************************************

var oTD,iTD;         // persistence

//****** Persistence for userData ********************************************************************************************* 

function getChecklistState(){ 
 
 var pageID= addID();

	if (checklist.all== "[object]") {
	oTD=checklist.all.tags("INPUT");
	iTD= oTD.length;
		}
	else
		{
		printing = true;
		isPersistent = false;
		return;
		}

	if (iTD == 0){
		printing = true;
		isPersistent = false;
		return;
		}
	
// routine added to fix a bug in the ocx 06/14/99	
     lct = document.location + ".";
	 xax = 10;
	 xax = lct.indexOf("mk:@MSITStore");
	 if (xax != -1) {
	 	lct = "ms-its:" + lct.substring(14,lct.length-1);
		// alert("before reload : " + document.location);
		// alert("replace with : " + lct);
		isPersistent = false;
		document.location.replace(lct);
		isPersistent = true;
		// alert("after reload : " + document.location);
		}	 
	 else
	 	{ 	 
     	checklist.load("oXMLStore");
		}
// routine added to fix a bug in the ocx 06/14/99
    if (checklist.getAttribute("sPersist"+pageID+"0"))	
    for (i=0; i<iTD; i++){

         if (oTD[i].type =="checkbox" || oTD[i].type =="radio"){
	     checkboxValue= checklist.getAttribute("sPersist"+pageID+i);
		
	     if (checkboxValue=="yes") oTD[i].checked=true;
		 else oTD[i].checked=false;
		 }// if
		 if (oTD[i].type =="text") 		     
 	         oTD[i].value= checklist.getAttribute("sPersist"+pageID+i);
     }// for
} // end persistence

//**  saveChecklistState *************************************************************************************************************
function saveChecklistState(){
var pageID= addID(); 

        if (!isPersistent) return; 
 		//  you will need this           document.location
        for (i=0; i<iTD; i++){

       	     if (oTD[i].type =="checkbox" || oTD[i].type =="radio"){
	             if (oTD[i].checked) checkboxValue="yes";
		         else checkboxValue="no";
				 
	             checklist.setAttribute("sPersist"+pageID+i, checkboxValue);
	         }// if
			
 		     if (oTD[i].type =="text") 
			     checklist.setAttribute("sPersist"+pageID+i, oTD[i].value);
		 }	// for

 // routine added to fix a bug in the ocx 06/14/99	
     lct = document.location + ".";
	 xax = 10;
	 xax = lct.indexOf("mk:@MSITStore");
	 if (xax != -1) {
	 	lct = "ms-its:" + lct.substring(14,lct.length-1);
		// alert("before reload : " + document.location);
		// alert("replace with : " + lct);
		isPersistent = false;
		document.location.replace(lct);
		isPersistent = true;
		// alert("after reload : " + document.location);
		}	 
	 else
	 	{ 	 
     	checklist.save("oXMLStore");
		}
// routine added to fix a bug in the ocx 06/14/99
	 
}//end function

//**  resizeDiv *******************************[used with callPopupWeb, setPreviousNext}****************************************************
//  resize the page when the <div class=nav></div> && <div class=text></div> are found
function resizeDiv(){
if (printing == true) return;
var oNav = document.all.item("nav");
var oText= document.all.item("text");

    if (popupOpen) closePopup();
	if (oText == null) return;
    if (oNav != null){
        document.all.nav.style.width= document.body.offsetWidth;
	    document.all.text.style.width= document.body.offsetWidth-4;
	    document.all.text.style.top= document.all.nav.offsetHeight;
	    if (document.body.offsetHeight > document.all.nav.offsetHeight)
	        document.all.text.style.height= document.body.offsetHeight - document.all.nav.offsetHeight;
 	    else document.all.text.style.height=0; 
  }
}
//**  addID *************************************************************************************************************
function addID(){

var locID = document.location.href; 
var iHTM = locID.lastIndexOf(".htm");
var iName=locID.lastIndexOf("/");
      locID = locID.substring(iName+1,iHTM);
	
	return locID;
}	
//** set_to_print ***************
function set_to_print(){
	// alert(printing)
	if (printing == true) return
	var i;
	

var isIE5 = (navigator.appVersion.indexOf("MSIE 5")>0) || (navigator.appVersion.indexOf("MSIE")>0 && parseInt(navigator.appVersion)> 4);
var isIE55 = (navigator.appVersion.indexOf("MSIE 5.5")>0);
if (isIE5 && isIE55) isIE5 = false;
var isIE6 = (navigator.appVersion.indexOf("MSIE 6")>0);
var isIE4 = (navigator.appVersion.indexOf("MSIE 4")>0);

if (!isIE5 && !isIE55 && !isIE4 && !isIE6) {
	isIE6 = true;
	}


// trying	
 
printing = true;
 
 if (isIE55){
 	addReusableText();
 	insertImages_4_print();
	 }
if (isIE6){
	addReusableText();
 	insertImages_4_print();
	}
 
// to fix printing



isPersistent= (document.all.item("checklist")!=null) && ((isIE5) || (isIE6) || (isIE55));
 setPreviousNext();
 resizeDiv();
// if (isPersistent) getChecklistState();
 

	if (window.text) {
		if (!window.text.style){
			scroller = "FALSE";
			}
		else
			{
			document.all.text.style.height = "auto";
			scroller = "TRUE";
			}
		}
	
var thisLoc= document.location.href;
	thisLoc = thisLoc.indexOf("glossary.htm")
	if (thisLoc != -1){
		return;
		}
	// alert("in print")
	
	// alert(isIE6)
	for (i=0; i < document.all.length; i++){
		if (document.all[i].id == "expand") {
			// callExpand(document.all[i]);         // no longer needed since the coua_print.css does this now.
			single = "TRUE";
			}
		if (document.all[i].tagName == "BODY") {
			document.all[i].scroll = "auto";
			}
		if (document.all[i].tagName == "A" && scroller != "TRUE") {
			joe = " " + document.all[i].outerHTML
			joe = joe.toLowerCase();
			joe = joe.indexOf("href=")
			if(joe == -1){
				document.all[i].outerHTML = "<A NAME=''>" + document.all[i].innerHTML + "</a>";
				}
			else
				{
				document.all[i].outerHTML = "<A HREF=''>" + document.all[i].innerHTML + "</a>";
				}
			}
		}
		
// reset_form();
	
}
//** used to reset a page if needed ********************
function reset_form(){
	printing = false;
	document.location.reload();
}

	
//** on error routine *********************************
function errorHandler() {
 //  alert("Error Handled");
  return true;
}

// ******************************* this function is to help ie55 and ie6 to print these images  ******
booking = false;
function insertImages_4_print(){

window.onerror = errorHandler
// if (isIE6) return
// if (isIE55) return
if (!printing) booking = true;
if (printing == true && booking == true ) {
	booking = false;
	return;
	}


 var collP = document.all.tags("P");
  
  for (var i=0; i<collP.length; i++) {
       if (collP[i].className.toLowerCase()=="note")            collP[i].innerHTML ="<img class='alert' src='"+noteImg+"' "+ imgStyleRTL +"> " +     collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="warning")    collP[i].innerHTML ="<img class='alert' src='"+warningImg+"'> " +  collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="caution")    collP[i].innerHTML ="<img class='alert' src='"+cautionImg+"'> " +  collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="tip")        collP[i].innerHTML ="<img class='alert' src='"+tipImg+"'> " +      collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="important")  collP[i].innerHTML ="<img class='alert' src='"+importantImg+"'> " + collP[i].innerHTML;
       else if (collP[i].className.toLowerCase()=="empty")      collP[i].innerHTML ="<img class='alert' src='"+emptyImg+"'> " +    collP[i].innerHTML;
	   if (collP[i].className.toLowerCase()=="reltopics" && rel_gif == "yes")  {
			collP[i].outerHTML ="<img class='relTopics' src='"+relTopicsImg+"'> " + collP[i].outerHTML;
			}   
  		}
  
//alert(printing)
//alert(isIE55)
//indents for Navigation Tree 
var collUL = document.all.tags("UL");
if (!printing) {
for (var i=0; i<collUL.length; i++) {
       var indent= 0;
       if (collUL[i].className.toLowerCase()=="navtree"){
	       if (isRTL) collUL[i].style.listStyleImage= "url('" + branchImg_RTL + "')";
		   else collUL[i].style.listStyleImage= "url('" + branchImg + "')";
  		   for (var j = 0; j < collUL[i].children.length; j++)
				if (collUL[i].children[j].className.toLowerCase()=="branch"){
					if (isRTL) collUL[i].children[j].style.marginRight= (indent +'em');
					else   collUL[i].children[j].style.marginLeft= (indent +'em');
					indent= indent + 0.75;
				}
	  }
}
}
   
  for (var i=0; i < document.anchors.length; i++){
         var imgInsert="";  
		 var imgStyle= "";
		 var imgSpace= "<span class='space'></span>";      
		 var oBefore=document.anchors[i].parentElement.tagName;
		 var oAnchor= document.anchors[i].id.toLowerCase();
         
// insert RELTOPICS icons
	if (rel_gif == "yes"){
       if (oAnchor=="reltopics")
	   		if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "reltopics")
			        imgInsert= "";    // not to re-insert when persistent
			else  imgInsert= "<img class='relTopics' src='"+relTopicsImg+"'>" + imgSpace;
		}
		
// insert SHORTCUT icons
       if (oAnchor=="shortcut") {    
 	       document.anchors[i].title= sShortcutTip;     
		    if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "shortcut")
			        imgInsert= "";    // not to re-insert when persistent
			else  imgInsert= "<img class='shortcut' src='"+shortcutCold+"' "+ imgStyleRTL+ ">" + imgSpace;
		}	
		   		   
// insert POPUP icons
       else if (oAnchor=="wpopup" || oAnchor=="wpopupweb") document.anchors[i].title= sPopupTip;
       else if (document.anchors[i].className.toLowerCase()=="popupicon")
		    if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "popup")
			       imgInsert= "";    // not to re-insert when persistent
	        else imgInsert= "<img class='popup' src='"+popupCold+"'>" + imgSpace;

// insert EXPAND icons 
       else if (oAnchor=="expand") {
	          document.anchors[i].title= sExpandTip;
              if (document.anchors[i].children.tags("IMG")(0) && document.anchors[i].children.tags("IMG")(0).className.toLowerCase() == "expand")
		          imgInsert= ""; 	// not to re-insert when persistent	  
              else{ 
			      if (document.anchors[i].parentElement.offsetLeft == document.anchors[i].offsetLeft) {
				      imgSpace= "<span class='space' style='width:0'></span>";     
				      if (isRTL){ document.anchors[i].parentElement.style.marginRight= "1.5em";  imgStyle=" style=margin-right:'-1.5em'";}
					  else { document.anchors[i].parentElement.style.marginLeft= "1.5em";  imgStyle=" style=margin-left:'-1.5em'";}
				  }	  
			      imgInsert= "<img class='expand' src='"+ closed +"' "+imgStyle+">" +imgSpace;
	          }
       }



// insert thumbnail images	   
       else if (oAnchor=="thumbnail"  || oAnchor=="thumbnailweb"){ 
            var sAltText = document.anchors[i].innerHTML;
			gifwithin = true;
		    var sThumbnailText = document.anchors[i].title; 
            var oImg = document.anchors[i].href.toLowerCase();
		          if (oAnchor=="thumbnail") 
				         var sThumbnailImg= moniker + getURL(oImg);
				  else var sThumbnailImg = document.anchors[i].href.toLowerCase();
				  
				 found = sAltText.indexOf("BACKGROUND-COLOR:")
			if (found != -1) {
				stop_p = sAltText.indexOf(">");
				sAltText = sAltText.substring(stop_p + 1, sAltText.length);
				stop_p = sAltText.indexOf("</FONT>");
				Highlighted = sAltText.substring(0,stop_p)
				sAltText = Highlighted + sAltText.substring(stop_p + 7, sAltText.length);
				}

				  
                document.anchors[i].outerHTML = "<DIV id='thumbDiv' class='thumbnail'>"+document.anchors[i].outerHTML+"</div>";
                document.anchors[i].innerHTML = "<img class='thumbnail' src='" + sThumbnailImg + "' alt= ' " + sAltText + "'><p>" +sThumbnailText+"</p>";
				
		          if (isRTL) thumbDiv.style.styleFloat= "right";
		   }
		   
		
		
 	   document.anchors[i].innerHTML = imgInsert + document.anchors[i].innerHTML;
	   if (isRTL) document.anchors[i].dir="rtl";
   }
}

//** quad method code --  Witten by Randy Feinger, morphed to work inside of shared.js
function QuadDocumentMouseOver()
{
	var elem = event.srcElement;
	
	// If the first childe of the source element is a radio button and 
	// the parent element isn't grayed, change the cursor to a hand
	// or back to the original as appropriate.
	if (elem != null && elem.firstChild != null && 
		elem.firstChild.tagName != null &&
	    elem.firstChild.tagName.toLowerCase() == "input" && 
	    elem.firstChild.type.toLowerCase() == "radio" && 
	    elem.parentElement.className != "indentGray")
	{
		if (elem.style.cursor == "hand")
			elem.style.cursor = "auto";
		else
			elem.style.cursor = "hand";
	}
}

function QuadDocumentClick()
{
	// Don't process clicks on grayed text.
	if (event.srcElement.parentElement.className == "indentGray")
		return;
	
	// INPUT elements should be wrapped by another element such as a SPAN, DIV, or P.
	var elem = event.srcElement.firstChild;
	
	// If this is a radio button...
	if (elem != null && elem.tagName != null && elem.tagName.toLowerCase() == "input" && elem.type == "radio")
	{
		// check it.
		elem.checked = true;
	}
	else
	{	
		// Otherwise, set elem to the event's source element.
		elem = event.srcElement;
	}
	
	// Call OnElementClick() and pass in the source element, and the name token
	// used to mark a top-level clickable element such as a radio button.
	OnElementClick(elem, "row1");
}



function OnElementClick(srcElem, token)
{
	var elemTagName = srcElem.tagName;						// Tag name of the source element.
	var collElements1 = document.all.item(srcElem.name);	// Collection of elements with the same name property as the source element.
	var n = srcElem.sourceIndex;							// The source index of the source element.
	var elemGroup = srcElem.group;							// The (dynamic) group property for the source element.
	var elemID = srcElem.id;								// The source element's ID.
	var i, j, k;											// Loop variables.
	
	// If there are no elements with the same name as the source element, or
	// if the source element isn't part of a group, exit the function.
	if (collElements1 == null || elemGroup == null || collElements1.length == null)
		return;
	
	// Make sure the source element's name contains the designated token
	// so we know it's top-level element that should be processed.
	if (srcElem.name.toLowerCase().indexOf(token) != -1)
	{
		// Loop through the collection of 
		for (i = 0; i < collElements1.length; i++)
		{
			// Go up one level and then down a level in the element hierarchy to find
			// the container (parent) element for the clickable sub-elements (radio buttons).
			var oNextElement = collElements1(i).parentElement.nextSibling;
			
			// If there is no such element, get the next element in the collection.
			if (oNextElement == null || oNextElement.tagName == null)
				continue;
			
			// Get the collection of all the elements within the container element that 
			// have the same tag name as the source element.
			var collElements2 = oNextElement.all.tags(elemTagName);
			
			// Make sure the collection is valid.
			if (collElements2 == null || collElements2.length == 0)
				continue;

			// Loop through the collection of sub-elements within the container element.
			for (j = 0; j < collElements2.length; j++)
			{
				// If the current element in the collection is not the
				// source element, disable it and make the text gray.
				if (collElements1(i).sourceIndex != n)
				{
					oNextElement.className = "indentGray"
					collElements2(j).disabled = true;
				}
				else	// Otherwise, enable the element and make the text black.
				{
					oNextElement.className = "indentBlack"
					collElements2(j).disabled = false;
					
					// Set the ID for the checked (selected) element for use below.
					if (collElements2(j).tagName.toLowerCase() == "input" && 
					    collElements2(j).type.toLowerCase() == "radio" && 
					    collElements2(j).checked == true)
					{
						elemID = collElements2(j).id;
					}
				}
			}
		}
	}
	
	// Get the collection of all of the elements with the same tag name as that
	// of the source element.
	var collElements2 = document.all.tags(elemTagName);
		
	// Make sure the collection is valid.
	if (collElements2 == null || collElements2.length == 0)
		return;
		
	// Loop through the collection of elements.
	for (i = 0; i < collElements2.length; i++)
	{
		// Get the collection of all elements with the same ID as the
		// current item in the collection.
		var collAssocElems = document.all(collElements2(i).id);
				
		// Make sure the collection is valid.
		if (collAssocElems == null || collAssocElems.length == 0)
			continue;
			
		// Loop through the collection of same-named elements.
		for (j = 0; j < collAssocElems.length; j++)
		{
			// If the tag name for the current element is different than that for the source element,
			// and the current element is part of the same group as the source element, 
			// hide or display the element as appropriate.
			if (collAssocElems(j).tagName != elemTagName && collAssocElems(j).group == elemGroup)
			{
				// Hide the element unless the current element's ID matches the ID of the element
				// that has been checked (selected).
				collAssocElems(j).style.display = ((collAssocElems(j).id == elemID) ? "block" : "none")
			}
		}
	}
}
