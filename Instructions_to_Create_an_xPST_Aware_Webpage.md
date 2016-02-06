Here's the procedure to create a webpage that is "xpst-aware", and also to build the sidebar content. The sample code provided is for the  ['NCBI Demo'](http://xpst.vrac.iastate.edu/WebxPST/ncbiblastmenu.html) application.


# Procedure #

1. Create the '.html' file that has the basic instructions for the student. The hyperlink to   the webpage for which tutoring is to provided is also to be mentioned in this file. The source code for this example given below is to be saved as 'ncbiblastmenu.html'.
Save this file in Root\apache-tomcat-6.0.18\webapps\WebxPST

```
<html>
	<body onload="startTask('ncbiblast')">
		<script src="tasklist.js" type="text/javascript"></script>
		<div>NCBI DEMO</div>
		<div>To start:</div>
		<ol>
			<li>Install the WebxPST extension if it isn't already installed, from <a href="https://its.clearsighted.org/webxpst/WebxPST.xpi">here</a></li>
			<li>Open the WebxPST sidebar (if it is not already open)</li>
			<li>Browse to <a href="http://www.ncbi.nlm.nih.gov/">NCBI</a></li>
		</ol> 
	</body>
</html>
```


2. Write the '.xPST' file for the task. The source code for this example given below is to be saved as 'ncbiblast.xpst'.
Save this file in Root\apache-tomcat-6.0.18\webapps\WebxPST\WEB-INF\tre

```
sequence
{
	(
		# goto blast home page
		(
			link-homepage-blast
		) then
		# goto the nucleotide blast search page
		(
			link-nucleotide-blast
		)
		
		then
		All-Done
	)
	and
	Error-Not-Done;
}

feedback
{
	link-homepage-blast
	{
		answer: "1";
		Hint: "Go to BLAST homepage by clicking the <strong>BLAST</strong> link.";
		Hint: "The <strong>BLAST</strong> link is in the menubar below the NCBI logo.";
		JIT: "<block/>To do a search using BLAST, you need to go to the BLAST Homepage";
	}
	
	link-nucleotide-blast
	{
		answer: "1";
		Hint: "Click on the <strong>Nucleotide blast</strong> link.";
		Hint: "The <strong>Nucleotide blast</strong> link is in the section subtitiled Basic Blast.";
		JIT: "<block/>To do a search using BLAST, you need to go to the BLAST Homepage";
	}

	All-Done
	{
		answer: 1;
		Hint: "You have successfully made the search using BLAST.";
	}
}

mappings
{
	[priority=2] contentDocument.childNodes-1.childNodes-7.childNodes-1.childNodes-0.childNodes-5.childNodes-0.childNodes-0:click => link-homepage-blast;
	[priority=2] homeBlastn:click => link-nucleotide-blast;
	[priority=2] TutorLink.Done => All-Done;
}
```

3. Write the '.properties' file. It has a single line of code, which mentions the name of the task and the xPST file. The source code for this example given below is to be saved as 'ncbiblast.properties'.
Save this file in Root\apache-tomcat-6.0.18\webapps\WebxPST\WEB-INF\tre

```
tre.task.ncbiblast.emfile=ncbiblast.xpst
```


4. Write the '.xml' file. The sidebar contents are to be mentioned here. The source code for this example, given below is to be saved as 'ncbiblast-scenario.xml'.
Save this file in Root\apache-tomcat-6.0.18\webapps\WebxPST\assets.

```
<?xml version="1.0" encoding="utf-8"?>
<message>
	<h3>NCBI Blast: How to search for a DNA Sequence using BLAST</h3>
	<p>This assignment is designed to familiarize you with the BLAST environment and to teach you how to search for a nucleotide or amino acid sequence using BLAST.</p>
	<p><strong>Problem Objective:</strong> LATER</p>
	<p>
		<strong>Software Tips:</strong> 
		<ul>
			<li>LATER</li>
		</ul>
	</p>
	<hr/>

	<h3>Detailed Instructions</h3>
	<p>LATER</p>

	<h3>LATER</h3>
	<p><strong>Test Your Problem:</strong> LATER</p>
	<p><strong>Finished?</strong><br/> 
	LATER</p>
</message>
```