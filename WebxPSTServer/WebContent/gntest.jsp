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
	<title>GoalNode test</title>
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

function gotSubmitResponse(data)
{
	var lines = data.split('\n');
	for (var i in lines)
	{
		var line = lines[i];
		if (line.length != 0)
		{
			var dm = DorminMsgFromString(line);
			var names = dm.DorminAddr.strArrNames;
			var verb = dm.strVerb;
			var gn = names[names.length - 1];
			if (verb == 'APPROVE')
			{
				document.getElementById('gnname' + gn).className = 'approved';
				document.getElementById('gncomp' + gn).firstChild.nodeValue = 'true';
				document.getElementById('gnjit' + gn).value = '';
			}
			else if (verb == 'FLAG')
			{
				document.getElementById('gnname' + gn).className = 'flagged';
				document.getElementById('gncomp' + gn).firstChild.nodeValue = 'false';
				document.getElementById('gnjit' + gn).value = '';
			}
			else if (verb == 'JITMESSAGE')
				document.getElementById('gnjit' + gn).value = dm.arrParameters[0].objValue.value[0].value;
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

function submit(gn)
{
	var msg;
	var dmsg = new DorminMessage('tutor.' + tutorName + '.' + gn, 'NOTEVALUESET', document.getElementById('gnval' + gn).value);
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

function gotRepresentativeValue(gn, data)
{
	document.getElementById('gnval' + gn).value = data;
	submit(gn);
}

function complete(gn)
{
	$.post('WebxPST', {'trename': trename, 'command': 'getrepresentativevalue', 'goalnode': gn},
		function(data)
		{
			gotRepresentativeValue(gn, data);
		}
	);
}

function gotTutorName(data)
{
	tutorName = data;
}

function gotGoalNodes(data)
{
	var table = $('#gntable > tbody');
	$(data).find('goalnode').each(
		function()
		{
			var gn = $(this).attr('name');
			var tr = $('<tr></tr>');
			$(tr).append($('<td id="gnname' + gn + '"></td>').text(gn));
			$(tr).append($('<td id="gncomp' + gn + '">false</td>'));
			$(tr).append($('<td><input id="gnval' + gn + '" type="text"/></td>'));
			$(tr).append($('<td><input type="button" onclick="submit(\'' + gn + '\')" value="submit"/></td>'));
			$(tr).append($('<td><input type="button" onclick="complete(\'' + gn + '\')" value="complete"/></td>'));
			$(tr).append($('<td><input id="gnjit' + gn + '" type="text"/></td>'));
			$(table).append(tr);
		}
	);
}

function startedTask(data)
{
	trename = data;
	if (window.console)
		console.log("started '" + trename + "'");
	$.get('WebxPST/' + trename + '/goalnodes', gotGoalNodes);
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

$(document).ready(
	function()
	{
		$.post('WebxPST', {'command': 'starttre', 'task': task, 'nullem': 1}, startedTask);
	}
);
	</script>
</head>
<body>
	<table id="gntable">
		<tr><th>goalnode</th><th>completed</th><th>value</th><th></th><th></th><th>JIT</th></tr>
	</table>
	<input type="button" onclick="getHint()" value="hint"/>
	<textarea id="hint" rows="5" cols="80"></textarea>
</body>
</html>