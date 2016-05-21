window.onload=LoadPage;
window.onunload=Window_Unload;
window.onresize=ResizeWindow;
window.onbeforeprint = set_to_print;
window.onafterprint = reset_form;

var vbDeclaration;
var vbUsage;
var csLang;
var cLang;
var jsharpLang;
var jsLang;

var scrollPos = 0;

var inheritedMembers;
var protectedMembers;
var netcfMembersOnly;


/*	
**********
**********   Begin
**********
*/

function LoadPage()
{

	if(IsEvilUrl())
	{
		ReloadEvilUrlAsGoodUrl();
		return;	// in just a moment, page will reload.
	}
	
	
	// show correct language
	LoadLanguages();
	LoadMembersOptions();
	
	Set_up_checkboxes();
	
	DisplayLanguages();
	
	if(inheritedMembers=="off")
		DisplayInheritedMembers();
	if(protectedMembers=="off")
		DisplayProtectedMembers();
	if(netcfMembersOnly=="on")
		DisplayNETCFMembers();
		
	ChangeMembersOptionsFilterLabel();
	
	LoadSections();

	ResizeWindow();
	
	// vs70.js did this to allow up/down arrow scrolling, I think
	try { mainSection.setActive(); } catch(e) { }

	// make body visible, now that we're ready to render
	document.body.style.display = "";
	
	//set the scroll position
	try{mainSection.scrollTop = scrollPos;}
	catch(e){}

	//call to function to populate feedback links with page title
	populateFbLink();
}

function Window_Unload()
{
	if(IsGoodUrl())
	{
		// save persistable data (except when unloading from a "bad url")
		SaveLanguages();
		SaveMembersOptions();
		SaveSections();
	}
}


// populateFbLink
// populate feedback links with page title
function populateFbLink(){
	allObjs = document.all;
	for(i=0;i<allObjs.length;i++){
		if(allObjs[i].id == "fbLink"){
			allObjs[i].href = allObjs[i].href+"?subject=Topic: "+document.title;
		}
	}
}


function ResizeWindow()
{
/*
	if (document.body.clientWidth==0) return;
	var header = document.all.item("header");
	var mainSection = document.all.item("mainSection");
	if (mainSection == null) return;
	
	
	document.body.scroll = "no"
	mainSection.style.overflow= "auto";
	header.style.width= document.body.offsetWidth - 2;
	//mainSection.style.paddingRight = "20px"; // Width issue code
	mainSection.style.width= document.body.offsetWidth - 4;
	mainSection.style.top=0;  
	if (document.body.offsetHeight > header.offsetHeight + 10)
		mainSection.style.height= document.body.offsetHeight - (header.offsetHeight + 10);
	else
		mainSection.style.height=0;
	
	try
	{
		mainSection.setActive();
	}
	catch(e)
	{
	}
*/
}

function Load(key)
{
	userDataCache.load("docSettings");
	var value = userDataCache.getAttribute(key);
	return value;
}

function Save(key, value)
{
	userDataCache.setAttribute(key, value);
	userDataCache.save("docSettings");
}

function RemoveAttribute(key)
{
	userDataCache.removeAttribute(key);
	userDataCache.save("docSettings");
}

function set_to_print()
{
	//breaks out of divs to print
	var i;

	if (window.text)document.all.text.style.height = "auto";
			
	for (i=0; i < document.all.length; i++)
	{
		if (document.all[i].tagName == "body")
		{
			document.all[i].scroll = "yes";
		}
		if (document.all[i].id == "header")
		{
			document.all[i].style.margin = "0px 0px 0px 0px";
			document.all[i].style.width = "100%";
		}
		if (document.all[i].id == "mainSection")
		{
			document.all[i].style.overflow = "visible";
			document.all[i].style.top = "5px";
			document.all[i].style.width = "100%";
			document.all[i].style.padding = "0px 10px 0px 30px";
		}
	}
}

function reset_form()
{
	//returns to the div nonscrolling region after print
	 document.location.reload();
}

function IsEvilUrl()
{
	var url = "" + document.location + ".";
	var r = url.indexOf("mk:@MSITStore") != -1;
	return r;
}

function IsGoodUrl()
{
	return !IsEvilUrl();
}

function ReloadEvilUrlAsGoodUrl()
{
	var url = "" + document.location + ".";
	var i = url.indexOf("mk:@MSITStore");
	if(i != -1)
	{
		url = "ms-its:" + url.substring(14, url.length - 1);
		document.location.replace(url);
	}
}

function Set_up_checkboxes()
{
	var checkbox;
	
	checkbox = document.getElementById("vbDeclarationCheckbox");
	if(checkbox != null)
	{
		if(vbDeclaration == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
	
	checkbox = document.getElementById("vbUsageCheckbox");
	if(checkbox != null)
	{
		if(vbUsage == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
		
	checkbox = document.getElementById("csCheckbox");
	if(checkbox != null)
	{
		if(csLang == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
		
	checkbox = document.getElementById("cCheckbox");
	if(checkbox != null)
	{
		if(cLang == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
	
	checkbox = document.getElementById("jsharpCheckbox");
	if(checkbox != null)
	{
		if(jsharpLang == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
		
	checkbox = document.getElementById("jsCheckbox");
	if(checkbox != null)
	{
		if(jsLang == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
	
	checkbox = document.getElementById("inheritedCheckbox");
	if(checkbox != null)
	{
		if(inheritedMembers == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
	
	checkbox = document.getElementById("protectedCheckbox");
	if(checkbox != null)
	{
		if(protectedMembers == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
	
	checkbox = document.getElementById("netcfCheckbox");
	if(checkbox != null)
	{
		if(netcfMembersOnly == "on")
			checkbox.checked = true;
		else
			checkbox.checked = false;
	}
}

/*	
**********
**********   End
**********
*/


/*	
**********
**********   Begin Language Filtering
**********
*/

function SetLanguage(key)
{
	var i = 0;
	if(vbDeclaration == "on")
		i++;
	if(vbUsage == "on")
		i++;
	if(csLang == "on")
		i++;
	if(cLang == "on")
		i++;
	if(jsharpLang == "on")
		i++;
	if(jsLang == "on")
		i++;
	
	if(key.id == "vbDeclarationCheckbox")
	{
		if(vbDeclaration == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
				
			vbDeclaration = "off";
		}
		else
			vbDeclaration = "on";
	}
	if(key.id == "vbUsageCheckbox")
	{
		if(vbUsage == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
				
			vbUsage = "off";
		}
		else
			vbUsage = "on";
	}
	if(key.id == "csCheckbox")
	{
		if(csLang == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
			
			csLang = "off";
		}
		else
			csLang = "on";
	}
	if(key.id == "cCheckbox")
	{
		if(cLang == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
				
			cLang = "off";
		}
		else
			cLang = "on";
	}
	if(key.id == "jsharpCheckbox")
	{
		if(jsharpLang == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
				
			jsharpLang = "off";
		}
		else
			jsharpLang = "on";
	}
	if(key.id == "jsCheckbox")
	{
		if(jsLang == "on")
		{
			if(i == 1)
			{
				key.checked = true;
				return;
			}
				
			jsLang = "off";
		}
		else
			jsLang = "on";
	}
	
	DisplayLanguages();
}

function DisplayLanguages()
{
	var spanElements = document.all.tags("span");
	
	var x = 0;
	if(vbDeclaration == "on")
		x++;
	if(vbUsage == "on")
		x++;
	if(csLang == "on")
		x++;
	if(cLang == "on")
		x++;
	if(jsharpLang == "on")
		x++;
	if(jsLang == "on")
		x++;
	
	var i;
	for(i = 0; i < spanElements.length; ++i)
	{
		if(spanElements[i].codeLanguage != null)
		{
			if(spanElements[i].codeLanguage == "VisualBasic")
			{
				if(vbDeclaration == "on" || vbUsage == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "VisualBasicDeclaration")
			{
				if(vbDeclaration == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "VisualBasicUsage")
			{
				if(vbUsage == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "CSharp")
			{
				if(csLang == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "ManagedCPlusPlus")
			{
				if(cLang == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "JSharp")
			{
				if(jsharpLang == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			if(spanElements[i].codeLanguage == "JScript")
			{
				if(jsLang == "on")
					spanElements[i].style.display = "";
				else
					spanElements[i].style.display = "none";
			}
			
			if(spanElements[i].codeLanguage == "NotVisualBasicUsage")
			{
				if((x == 1) && (vbUsage == "on"))
				{
					spanElements[i].style.display = "none";
				}
				else
				{
					spanElements[i].style.display = "";
				}
			}
		}
	}
	ChangeLanguageFilterLabel();
}

function ChangeLanguageFilterLabel()
{	
	var i = 0;
	if(vbDeclaration == "on")
		i++;
	if(vbUsage == "on")
		i++;
	if(csLang == "on")
		i++;
	if(cLang == "on")
		i++;
	if(jsharpLang == "on")
		i++;
	if(jsLang == "on")
		i++;
		
	var labelElement;
	
	labelElement = document.getElementById("showAllLabel");
	
	if(labelElement == null)
		return;
		
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("multipleLabel");
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("vbLabel");
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("csLabel");
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("cLabel");
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("jsharpLabel");
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("jsLabel");
	labelElement.style.display = "none";
	
	if(i == 6)
	{
		labelElement = document.getElementById("showAllLabel");
		labelElement.style.display = "inline";
	}
	else if ((i > 1) && (i < 6))
	{
		if((i == 2) && ((vbDeclaration == "on") && (vbUsage == "on")))
		{
			labelElement = document.getElementById("vbLabel");
			labelElement.style.display = "inline";
		}
		else
		{
			labelElement = document.getElementById("multipleLabel");
			labelElement.style.display = "inline";
		}
	}
	else if (i == 1)
	{
		if(vbDeclaration == "on" || vbUsage == "on")
		{
			labelElement = document.getElementById("vbLabel");
			labelElement.style.display = "inline";
		}
		if(csLang == "on")
		{
			labelElement = document.getElementById("csLabel");
			labelElement.style.display = "inline";
		}
		if(cLang == "on")
		{
			labelElement = document.getElementById("cLabel");
			labelElement.style.display = "inline";
		}
		if(jsharpLang == "on")
		{
			labelElement = document.getElementById("jsharpLabel");
			labelElement.style.display = "inline";
		}
		if(jsLang == "on")
		{
			labelElement = document.getElementById("jsLabel");
			labelElement.style.display = "inline";
		}
	}
}

function LoadLanguages()
{
	var value;
	value = Load("vbDeclaration");
	if(value == null)
		vbDeclaration = "on";
	else
		vbDeclaration = value;
		
	value = Load("vbUsage");
	if(value == null)
		vbUsage = "on";
	else
		vbUsage = value;
		
	value = Load("csLang");
	if(value == null)
		csLang = "on";
	else
		csLang = value;
		
	value = Load("cLang");
	if(value == null)
		cLang = "on";
	else
		cLang = value;
	
	value = Load("jsharpLang");
	if(value == null)
		jsharpLang = "on";
	else
		jsharpLang = value;
			
	value = Load("jsLang");
	if(value == null)
		jsLang = "on";
	else
		jsLang = value;
}

function SaveLanguages()
{
	Save("vbDeclaration", vbDeclaration);
	Save("vbUsage", vbUsage);
	Save("csLang", csLang);
	Save("cLang", cLang);
	Save("jsharpLang", jsharpLang);
	Save("jsLang", jsLang);
}

/*	
**********
**********   End Language Filtering
**********
*/

/*	
**********
**********   Begin Members Options Filtering
**********
*/

function SetMembersOptions(key)
{
	if(key.id == "inheritedCheckbox")
	{
		if(key.checked == true)
			inheritedMembers = "on";
		else
			inheritedMembers = "off";
		
		DisplayInheritedMembers();
	}
	if(key.id == "protectedCheckbox")
	{
		if(key.checked == true)
			protectedMembers = "on";
		else
			protectedMembers = "off";
		
		DisplayProtectedMembers();
	}
	if(key.id == "netcfCheckbox")
	{
		if(key.checked == true)
			netcfMembersOnly = "on";
		else
			netcfMembersOnly = "off";
	
		DisplayNETCFMembers();
	}
	
	ChangeMembersOptionsFilterLabel();
}

function DisplayInheritedMembers()
{
	var iMembers = document.all.tags("tr");
	var i;
	
	if(inheritedMembers == "off")
	{	
		for(i = 0; i < iMembers.length; ++i)
		{
			if(iMembers[i].name == "inheritedMember")
				iMembers[i].style.display = "none";
		}
	}
	else
	{
		for(i = 0; i < iMembers.length; ++i)
		{
			if(iMembers[i].name == "inheritedMember")
			{
				if(netcfMembersOnly == "on")
				{
					if(iMembers[i].notSupportedOn == "netcf")
					{
						iMembers[i].style.display = "none";
					}
					else
					{
						iMembers[i].style.display = "";
					}
				}
				else
					iMembers[i].style.display = "";
			}
		}
	}
}

function DisplayProtectedMembers()
{
	var imgElements = document.getElementsByName("toggleSwitch");
	var i;
	
	if(protectedMembers == "off")
	{
		for(i = 0; i < imgElements.length; ++i)
		{
			if(imgElements[i].id.indexOf("Family", 0) == 0)
			{
				if(ItemCollapsed(imgElements[i].id) == false)
				{
					ExpandCollapse(imgElements[i]);
				}
			}
		}
	}
	else
	{
		for(i = 0; i < imgElements.length; ++i)
		{
			if(imgElements[i].id.indexOf("Family", 0) == 0)
			{
				if(ItemCollapsed(imgElements[i].id) == true)
				{
					ExpandCollapse(imgElements[i]);
				}
			}
		}
	}
		
}

function DisplayNETCFMembers()
{
	var netcfMembers = document.all.tags("tr");
	var i;
	
	if(netcfMembersOnly == "off")
	{	
		for(i = 0; i < netcfMembers.length; ++i)
		{
			if(netcfMembers[i].notSupportedOn == "netcf")
			{
				netcfMembers[i].style.display = "";
			}
		}
		DisplayInheritedMembers();
	}
	else
	{
		for(i = 0; i < netcfMembers.length; ++i)
		{
			if(netcfMembers[i].notSupportedOn == "netcf")
			{
				netcfMembers[i].style.display = "none";
			}
		}
	}
}

function ChangeMembersOptionsFilterLabel()
{	

	var filtered = false;
	
	if((inheritedMembers=="off") || (protectedMembers=="off") || (netcfMembersOnly=="on"))
		filtered = true;
		
	var labelElement;
	
	labelElement = document.getElementById("showAllMembersLabel");
	
	if(labelElement == null)
		return;
		
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("filteredMembersLabel");
	labelElement.style.display = "none";
	
	if(filtered)
	{
		labelElement = document.getElementById("filteredMembersLabel");
		labelElement.style.display = "inline";
	}
	else
	{
		labelElement = document.getElementById("showAllMembersLabel");
		labelElement.style.display = "inline";
	}
}

function LoadMembersOptions()
{
	var value;
	value = Load("inheritedMembers");
	if(value == null)
		inheritedMembers = "on";
	else
		inheritedMembers = value;
		
	value = Load("protectedMembers");
	if(value == null)
		protectedMembers = "on";
	else
		protectedMembers = value;
		
	value = Load("netcfMembersOnly");
	if(value == null)
		netcfMembersOnly = "off";
	else
		netcfMembersOnly = value;
}

function SaveMembersOptions()
{
	Save("inheritedMembers", inheritedMembers);
	Save("protectedMembers", protectedMembers);
	Save("netcfMembersOnly", netcfMembersOnly);
}

/*	
**********
**********   End Members Options Filtering
**********
*/


/*	
**********
**********   Begin Expand/Collapse
**********
*/

var collapsedItems = new Array();

function ExpandCollapse(imageItem)
{
	if(ItemCollapsed(imageItem.id) == true)
	{
		imageItem.src = collapseImage.src;
		ExpandSection(imageItem);
		RemoveCollapsedItem(imageItem.id);
		
		if(imageItem.id.indexOf("Family", 0) == 0)
		{
			protectedMembers = "on";
			Set_up_checkboxes();
			ChangeMembersOptionsFilterLabel();
		}
	}
	else
	{
		imageItem.src = expandImage.src;
		CollapseSection(imageItem);
		AddCollapsedItem(imageItem.id);
	}
	
	SetCollapseAll();
}

function ExpandCollapseAll(imageItem)
{
	var imgElements = document.getElementsByName("toggleSwitch");
	var i;
	
	if(ItemCollapsed(imageItem.id) == true)
	{
		imageItem.src = collapseAllImage.src;
		RemoveCollapsedItem(imageItem.id);
		for(i = 0; i < imgElements.length; ++i)
		{
			imgElements[i].src = collapseImage.src;
			ExpandSection(imgElements[i]);
			RemoveCollapsedItem(imgElements[i].id);
			
			if(imgElements[i].id.indexOf("Family", 0) == 0)
				protectedMembers = "on";
		}
		SetToggleAllLabel(false);
	}
	else
	{
		imageItem.src = expandAllImage.src;
		AddCollapsedItem(imageItem.id);
		for(i = 0; i < imgElements.length; ++i)
		{
			imgElements[i].src = expandImage.src;
			CollapseSection(imgElements[i]);
			AddCollapsedItem(imgElements[i].id);
		}
		SetToggleAllLabel(true);
	}
}

function ExpandCollapse_CheckKey(imageItem)
{
	if(window.event.keyCode == 13)
		ExpandCollapse(imageItem);
}

function ExpandCollapseAll_CheckKey(imageItem)
{
	if(window.event.keyCode == 13)
		ExpandCollapseAll(imageItem);
}

function ExpandSection(imageItem)
{
	imageItem.parentElement.parentElement.nextSibling.style.display	= "";
}

function CollapseSection(imageItem)
{
	imageItem.parentElement.parentElement.nextSibling.style.display	= "none";
}

function SetCollapseAll()
{
	var imageElement = document.getElementById("toggleAllImage");
	
	if(imageElement == null)
		return;
		
	var imgElements = document.getElementsByName("toggleSwitch");
	var allCollapsed = true;
	var i;
		
	for(i = 0; i < imgElements.length; ++i)
	{
		allCollapsed = allCollapsed && ItemCollapsed(imgElements[i].id)
	}
	
	if(allCollapsed)
	{
		imageElement.src = expandAllImage.src;
		AddCollapsedItem(imageElement.id);
	}
	else
	{
		imageElement.src = collapseAllImage.src;
		RemoveCollapsedItem(imageElement.id);
	}
	
	SetToggleAllLabel(allCollapsed);
}

function SetToggleAllLabel(allCollapsed)
{
	var labelElement;
	labelElement = document.getElementById("collapseAllLabel");
	
	if(labelElement == null)
		return;
		
	labelElement.style.display = "none";
	
	labelElement = document.getElementById("expandAllLabel");
	labelElement.style.display = "none";
	
	if(allCollapsed)
	{
		labelElement = document.getElementById("expandAllLabel");
		labelElement.style.display = "inline";
	}
	else
	{
		labelElement = document.getElementById("collapseAllLabel");
		labelElement.style.display = "inline";
	}
}

function ItemCollapsed(imageId)
{
	var i;
	
	for(i = 0; i < collapsedItems.length; ++i)
	{
		if(imageId == collapsedItems[i])
			return true;
	}
	
	return false;
}

function AddCollapsedItem(imageId)
{	
	if(ItemCollapsed(imageId) == false)
		collapsedItems[collapsedItems.length] = imageId;
}

function RemoveCollapsedItem(imageId)
{
	var i;
	
	for(i = 0; i < collapsedItems.length; ++i)
	{
		if(imageId == collapsedItems[i])
			collapsedItems.splice(i, 1);
	}
}

function SaveSections()
{
	var i;
	var x = 0;
	
	CleanUserDataStore();
	
	for(i = 0; i < collapsedItems.length; ++i)
	{
		if(ShouldSave(collapsedItems[i]) == true)
		{
			Save("imageValue" + x, collapsedItems[i]);
			x++;
		}
	}
}

function LoadSections()
{
	var i = 0;
	var imageId = Load("imageValue" + i);
	
	while(imageId != null)
	{
		var imageItem = document.getElementById(imageId);
		
		if(imageItem != null)
		{
			if(imageItem.id.indexOf("Family", 0) == 0)
			{
				if(protectedMembers == "on")
				{
					ExpandCollapse(imageItem);
				}
			}
			else
				ExpandCollapse(imageItem);
		}
		else
		{
			AddCollapsedItem(imageId);
		}
	
		i++;
		imageId = Load("imageValue" + i);
	}
	
	SetCollapseAll();
}

function CleanUserDataStore()
{
	var i = 0;
	var imageId = Load("imageValue" + i);
	
	while(imageId != null)
	{
		RemoveAttribute("imageValue" + i);
		i++;
		imageId = Load("imageValue" + i);
	}
}

function ShouldSave(imageId)
{
	var toggleName;
	
	if(imageId == "toggleAllImage")
		return false;
	
	toggleName = "procedureToggle";
	if(imageId.indexOf(toggleName, 0) == 0)
		return false;
		
	toggleName = "sectionToggle";
	if(imageId.indexOf(toggleName, 0) == 0)
		return false;
	
	return true;
}

function OpenSection(imageItem)
{
	if(ItemCollapsed(imageItem.id) == true)
		ExpandCollapse(imageItem);
}

/*	
**********
**********   End Expand/Collapse
**********
*/



/*	
**********
**********   Begin Copy Code
**********
*/

function CopyCode(key)
{
	var trElements = document.all.tags("tr");
	var i;
	for(i = 0; i < trElements.length; ++i)
	{
		if(key.parentElement.parentElement.parentElement == trElements[i].parentElement)
		{
			window.clipboardData.setData("Text", trElements[i].innerText);
		}
	}
}

function ChangeCopyCodeIcon(key)
{
	var i;
	var imageElements = document.getElementsByName("ccImage")
	for(i=0; i<imageElements.length; ++i)
	{
		if(imageElements[i].parentElement == key)
		{
			if(imageElements[i].src == copyImage.src)
				imageElements[i].src = copyHoverImage.src;
			else
				imageElements[i].src = copyImage.src;
		}
	}
}

function CopyCode_CheckKey(key)
{
	if(window.event.keyCode == 13)
		CopyCode(key);
}

/*	
**********
**********   End Copy Code
**********
*/


/*	
**********
**********   Begin Maintain Scroll Position
**********
*/

function loadAll(){
	try 
	{
		scrollPos = allHistory.getAttribute("Scroll");
	}
	catch(e){}
}

function saveAll(){
	try
	{
		allHistory.setAttribute("Scroll", mainSection.scrollTop);
	}
	catch(e){}
}

/*	
**********
**********   End Maintain Scroll Position
**********
*/


/*	
**********
**********   Begin Send Mail
**********
*/

function formatMailToLink(anchor)
{
	var release = "Release: " + anchor.doc_Release;
	var topicId = "Topic ID: " + anchor.doc_TopicID;
	var topicTitle = "Topic Title: " + anchor.doc_TopicTitle;
	var url = "URL: " + document.URL;
	var browser = "Browser: " + window.navigator.userAgent;

	var crlf = "%0d%0a"; 
	var body = release + crlf + topicId + crlf + topicTitle + crlf + url + crlf + browser + crlf + crlf + "Comments:" + crlf + crlf;
	
	anchor.href = anchor.href + "&body=" + body;
}

/*	
**********
**********   End Send Mail
**********
*/



