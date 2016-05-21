//This file is designed to locate feedback values and insert them in
//script_loc.js.
//This script file takes two parameters:
//fileName: Path and name of the xml file to be parsed
//output: Path and name of the output text file
//
//Example usage:
//cscript getfeedback.js <path to usc file> <path to output text file>
//
//The format of the usc file:
//<item id="fb_alias">alias@microsoft.com</item>
//<item id="fb_product">product</item>
//<item id="fb_deliverable">release name</item>
//<item id="fb_docversion">doc version</item>
//
//The output text file format is:
//<alias>|<product>|<deliverable>|<doc version>

GetFeedback(WScript.Arguments(0),WScript.Arguments(1));
  
function GetFeedback(fileName, output)
  {
    WScript.Echo("Info: Getting feedback from: "+fileName+"...");

    var debugXml = new ActiveXObject("Msxml2.DOMDocument");

    try
    {
       debugXml.async = false;
       debugXml.load(fileName);
    }
    catch(e)
    {
      WScript.Echo("!!!!Error: "+e.description);
    }

    try
    {
	    var xpathAlias = "//userSharedContentDefinitions/item[@id='fb_alias']";
	    var valAlias = debugXml.selectSingleNode(xpathAlias).text;
	    var xpathProduct = "//userSharedContentDefinitions/item[@id='fb_product']";
	    var valproduct = debugXml.selectSingleNode(xpathProduct).text;
	    var xpathDeliverable = "//userSharedContentDefinitions/item[@id='fb_deliverable']";
	    var valDeliverable = debugXml.selectSingleNode(xpathDeliverable).text;
	    var xpathDocversion = "//userSharedContentDefinitions/item[@id='fb_docversion']";
	    var valDocversion = debugXml.selectSingleNode(xpathDocversion).text;

	    var fso = new ActiveXObject("Scripting.FileSystemObject");
            var ForReading = 1, ForWriting = 2, ForAppending = 8;
	    fso = new ActiveXObject("Scripting.FileSystemObject");
	    var outcsv = fso.CreateTextFile(output, ForWriting);
	    outcsv.WriteLine(valAlias + "|" + valproduct + "|" + valDeliverable + "|" + valDocversion);
	    outcsv.Save
    }
    catch(e)
    {
      WScript.Echo("Info: No feedback values found in: "+fileName);
    }  

  }