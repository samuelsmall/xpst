<!--
Copyright (c) Clearsighted 2006-08 stephen@clearsighted.net

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
-->

<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<title>AppNode test</title>
	<style>
		.flagged { color: red }
		.approved { color: limegreen }
		
	</style>
	<script type="text/javascript" src="jquery/jquery.js"></script>
	<script type="text/javascript" src="dormin.js"></script>
	<script type="text/javascript">
var task = window.location.search.substring(6);
var trename = null;
var tutorName = null;
var gotInitialAppNodes = false;
var appNodeToNum = {}, numToAppNode = {}, appNodeToGoalNode = {};

function gotSubmitResponse(data)
{
	var lines = data.split('\n');
	for (var i in lines)
	{
		var line = lines[i];
		if (line.length != 0)
		{
			var dm = DorminMsgFromString(line);
			var addr = dm.DorminAddr.ToDottedString();
			var verb = dm.strVerb;
			var appn = appNodeToNum[addr];
			if (verb == 'APPROVE')
			{
				document.getElementById('appnname' + appn).className = 'approved';
				document.getElementById('appncomp' + appn).checked=true;
				document.getElementById('appnjit' + appn).value = '';
			}
			else if (verb == 'FLAG')
			{
				document.getElementById('appnname' + appn).className = 'flagged';
				document.getElementById('appncomp' + appn).checked = false;
				document.getElementById('appnjit' + appn).value = '';
			}
			else if (verb == 'JITMESSAGE')
			{
				document.getElementById('appnjit' + appn).disabled=false;
				document.getElementById('appnjit' + appn).style.color="green";
				document.getElementById('appnjit' + appn).value = dm.arrParameters[0].objValue.value[0].value;
			}
			else if (verb == 'HINTMESSAGE')
			{
				var hints = dm.arrParameters[0].objValue.value;
				var val = '';
				for (var i in hints)
				{
					var hint = hints[i];
					if (val.length > 0)
						val += '----\n';
					val += hint.value;
				}
				document.getElementById('hint').value = val;
			}
		}
	}
	getAppNodes();
}

function submitEmpty()
{
	$.ajax(
		{
			url: 'WebxPST/' + trename,
			type: 'POST',
			data: '',
			success: gotSubmitResponse
		}
	);
}

function submit(appn)
{
	var msg;
	var addr = numToAppNode[appn];
	var dmsg = new DorminMessage(addr, 'NOTEVALUESET', document.getElementById('appnval' + appn).value);
	msg = dmsg.MakeString();
	
	$.ajax(
		{
			url: 'WebxPST/' + trename,
			type: 'POST',
			data: msg,
			success: gotSubmitResponse
		}
	);
}

function gotRepresentativeValue(appn, data)
{
	document.getElementById('appnval' + appn).value = data;
	submit(appn);
}

function complete(appn)
{
	var gn = appNodeToGoalNode[numToAppNode[appn]];
	$.post('WebxPST', {'trename': trename, 'command': 'getrepresentativevalue', 'goalnode': gn},
		function(data)
		{
			gotRepresentativeValue(appn, data);
		}
	);
}

function gotTutorName(data)
{
	tutorName = data;
}

function gotAppNodes(data)
{
	var table = $('#gntable > tbody');
	if (!gotInitialAppNodes)
	{
		gotInitialAppNodes = true;
		var i = 0;
		$(data).find('appnode').each(
			function()
			{
				var appn = $(this).attr('name');
				var rappn = appn;
				var idx = rappn.indexOf(':');
				if (idx != -1)
					rappn = rappn.substring(0, idx);
				appNodeToNum[rappn] = i;
				numToAppNode[i] = appn;
				var gn = $(this).attr('goalnodename');
				appNodeToGoalNode[rappn] = gn;
				if (gn == null)
					gn = '';
				var tr = $('<tr></tr>');
				$(tr).append($('<td id="appnname' + i + '"></td>').text(appn));
				$(tr).append($('<td id="appngn' + i + '"></td>').text(gn));
				$(tr).append($('<td><input id="appncomp' + i + '" type="checkbox" disabled="true"></td>'));
				$(tr).append($('<td><input id="appnval' + i + '" type="text"/></td>'));
				$(tr).append($('<td><input type="button" onclick="submit(' + i + ')" value="submit"/></td>'));
				$(tr).append($('<td><input type="button" onclick="complete(' + i + ')" value="complete"/></td>'));
				$(tr).append($('<td><input id="appnjit' + i + '" type="text" disabled="true"/></td>'));
				$(table).append(tr);
				i++;
			}
		);
		$("#gntable").tablesorter({sortList:[[0,0],[2,1]], widgets: ['zebra']});
	}
	
	else
	{
		var i = 0;
		$(data).find('appnode').each(
			function()
			{
				var appn = $(this).attr('name');
				var gn = $(this).attr('goalnodename');
				appNodeToGoalNode[appn] = gn;
				if (gn == null)
					gn = '';
				$('#appngn' + i).text(gn);
				i++;
			}
		);
	}
}

function getAppNodes()
{
	$.get('WebxPST/' + trename + '/appnodes', gotAppNodes);
}

function startedTask(data)
{
	trename = data;
	if (window.console)
		console.log("started '" + trename + "'");
	getAppNodes();
	$.get('WebxPST/' + trename + '/tutorname', gotTutorName);
	submitEmpty();
}

function getHint()
{
	var msg;
	var dmsg = new DorminMessage('', 'GETHINT', null);
	msg = dmsg.MakeString();
	
	$.ajax(
		{
			url: 'WebxPST/' + trename,
			type: 'POST',
			data: msg,
			success: gotSubmitResponse
		}
	);
}

function testArbAppNode()
{
	var msg;
	var addr = document.getElementById('arbappnname').value;
	var dmsg = new DorminMessage(addr, 'NOTEVALUESET', 1);
	msg = dmsg.MakeString();
	
	$.ajax(
		{
			url: 'WebxPST/' + trename,
			type: 'POST',
			data: msg,
			success: gotSubmitResponse
		}
	);
}

function log()
{
	$.post('WebxPST', {'trename': trename, 'command': 'log', 'msg': 'this is a log message'});
}

$(document).ready(
	function()
	{
		$.post('WebxPST', {'command': 'starttre', 'task': task}, startedTask);
	}
);
	</script>
</head>

<body>
	<center><b><u><H3>APPNODE TESTER</center></b></u></i>
<link rel="stylesheet" href="http://dev.jquery.com/view/trunk/themes/flora/flora.all.css" type="text/css" media="screen" title="Flora (Default)">
<script src="http://tablesorter.com/jquery-latest.js"></script>
<script src="http://tablesorter.com/jquery.tablesorter.js"></script>
<link rel="stylesheet" href="http://tablesorter.com/themes/blue/style.css" type="text/css" media="print, projection, screen" />

	<table id="gntable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th>AppNode</th>
				<th>GoalNode</th>
				<th>Completed</th>
				<th>Value</th>
				<th></th>
				<th></th>
				<th>JIT</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

<hr>
Enter an AppNode in the textbox and Click on Hint Button to get the hint.<br>
<textarea id="hint" rows="5" cols="80"></textarea>
<input type="button" onclick="getHint()" value="Get Hint"/><hr>
Click on the View Log button to view the log.
<input type="button" onclick="log()" value="View Log"/><hr>
<i>Debug Section:</i><br>
<input id="arbappnname" type="text"/>
<input type="button" onclick="testArbAppNode()" value="Test ARB"/>

</body>
</html>