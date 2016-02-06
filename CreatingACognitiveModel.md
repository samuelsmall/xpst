# Introduction #

Read the [xPST\_System](xPST_System.md) page first.

In order to create an intelligent tutor using xPST, you must create a cognitive model.  In our task-based ITS, the model represents the procedural knowledge necessary to correctly complete the steps of the task. It must consider the many potential actions of the user during all the different possible states of the application being tutored.  The model must also contain appropriate hints and feedback on incorrect steps taken.

To handle all this, we have created the **.xpst file format** to contain the cognitive model in three pieces.  The first piece is the **sequence**, which identifies a path the user takes through the problem space to achieve the goal specified in the task.  Following the sequence is the **mappings** section, which maps GUI identifiers to steps the user takes.  Finally, the **feedback** section provides hints and JITs, or just-in-time messages that guide a user back on track if they make a mistake.

# File structure #

Each .xpst file must have a sequence section, a mappings section, and a feedback section, though there may optionally be more than one of each of these types of sections.
Order generally doesn't matter.

## Example file ##

```
sequence
{
	Text-ProblemName then
	Text-Attempts then
	Click-Update;
}

mappings
{
	#Problem-creation
	[priority=2]ProblemName=>Text-ProblemName;
	[priority=2]ProblemAttempts=>Text-Attempts;
	[priority=2]ProblemEditControls.childNodes-3:click=>Click-Update;
}

feedback 
{
	Text-ProblemName {
		answer: "AddSubtract";
		Hint: "Provide a name for this problem, which is used to refer to this problem in the authoring tool.";
		Hint: "Change the Problem Name to 'AddSubtract' in the <strong>Name</strong> field in the Problems panel.";
	}

	Text-Attempts {
		answer: "2";
		Hint: "Set the number of attempts for this problem. This means that the students will have two opportunities to try out this problem and enter the correct answer.";
		Hint: "Set the <strong>Attempts</strong> field for this problem to '{answer}'.";
	}

	Click-Update {
		answer: 1;
		Hint: "To save the details of the problem, click the <strong>Update</strong> button.";
	}
}

```

## Comments ##

Comments may be single lines preceded by # or C-style multi-line comments like this:
```
/*  This is
a comment */
```

## Includes ##

A line like:
```
include "sample.xpst";
```
will include the contents of the file sample.xpst (location is relative to current .xpst file). The entire contents of the file are included pretty much as if they were typed into the file.

This is not quite the same as the #include facility in C, because the include file itself must be syntactically correct as if it were a standalone .xpst file (for example, if you have mappings, you must include the 'mappings {...}' around them.) This helps preserve the general property of .xpst files that ordering doesn't matter.

# Sequence #

The steps a user makes in order to complete a task are called goal nodes (GNs). GNs can vary in granularity, e.g. if I'm editing a spreadsheet, is the GN "Make a graph" (general), "Graph columns A and B" (more specific) or "Select columns A and B and click the graph button in the top toolbar" (very specific).  Generally, the right level of granularity is one level above the UI controls and button clicks, i.e. in this case probably "Graph columns A and B" or perhaps "Graph the first two columns."

The sequence is a set of words that describe the steps (GNs) that the user should follow. Multiple paths to the goal are fine; the sequence accepts AND, OR, and other operators.

The EventMapper uses a sequence notation to determine which GNs are "listening" to user behavior at any given time. If a GN is listening, we say it's **mapped**. E.g. if one GN is mapped, then the mapping (explained below) between a UI control and a GN is valid. If the GN is unmapped, then the mapping specified below in the mapping section doesn't apply. It's like the GN is no longer listening. This is a little like an old telephone switchboard operator; events from the user are coming in, but if your GN is not mapped, it won't hear them. (And you can only give tutoring feedback if you hear them.)

List the GN names separated by various operators. Operators are:

  * then (e.g. A then B) - "then" will map B after A is completed, and unmap A
  * or (e.g. A or B) - both A and B will be mapped so that either can be done, and after one is done, the other is unmapped
  * and (e.g. A and B) - both A and B will be mapped, and they must both be completed, but can be done in any order
  * until (e.g. A until B) - A will remain mapped even after it's completed until B is completed
  * ( ) (e.g. you can group GNs)

Finish your sequence with a semicolon. Don't use uppercase, like "OR".

If any goalnodes are not mentioned in the sequence, but are mentioned in the mappings, they are treated as if they were 'and'ed into the sequence.



# Event mapping #

Event mapping maps events from the user interface to goalnodes, or steps taken along the way to achieving the goal. You need to map all GUI controls that you care about, e.g. not only GN controls but also all JIT-related controls.

You can group mappings that should all go to the same GN, e.g. if your GN is "Flip-Horizontal," but you have JITs related to rotating, you'll want to group the answer mapping and the JIT mappings inside a group for Flip-Horizontal.

Sometimes you can do a one-to-one mapping with GUI control name on the left and GN name on the right, e.g.

```
	Resize.okButton => Click-OK;
```

but other times you want to map not the entire control to a goalnode, but just the mouse clicks on it, e.g. for a menu item or a checkbox. Unlike for a combobox, where you want to know the value (e.g. 42), for controls that have no substantive internal value, like menus and checkboxes, you just need to know they've been clicked. To do this, you map the click onto a semantically useful string for the tutor. The switch function allows this.

```
	switch
	{
		mainMenu._3._1.click="Image:Resize..."
	} => Open-Resize;
```

The switch function also allows many-to-one mappings. This is useful for JITs. Inside a switch, include all the mappings you want and separate them with commas, e.g.

```
	switch
	{
		# answer
		mainMenu._3._4._0.click="Image:Flip:Horizontal",
		# for JITs
		mainMenu._3._4._1.click="Image:Flip:Vertical",
		mainMenu._3._5._0.click="Image:Rotate:90 CW", 
		mainMenu._3._5._1.click="Image:Rotate:180 CW", 
		mainMenu._3._5._2.click="Image:Rotate:270 CW", 
		mainMenu._3._5._4.click="Image:Rotate:90 CCW", 
		mainMenu._3._5._5.click="Image:Rotate:180 CCW", 
		mainMenu._3._5._6.click="Image:Rotate:270 CCW", 
	} => Flip-Horizontal;
```

The above code says to the EventMapper, "For messages from any of the following GUI controls (e.g. mainMenu._3._4._0.click), send them to the following GN (Flip-Horizontal), and use these friendlier name values (e.g. Image:Flip:Horizontal) to tell the GN where the messages came from."_

Note that the EventMapper automatically does a reverse mapping for you, so that in the above example, if you're trying to accomplish goalnode Flip-Horizontal but you do an Image Rotate 90CW, the tutor will send a FLAG message ("wrong!") back to the EventMapper, and the Event Mapper will tell the Presentation Manager to flag the appropriate control visually.

To view GUI control names (also known as appnode names), turn on the 'Authoring mode' checkbox in the WebxPST Tutor plugin in Firefox. To turn this on, go to Tools->Add-ons->Extensions->WebxPST->Preferences in Firefox, click the 'Authoring mode on' checkbox, then OK. When this mode is on, you should see a "Recent events" section in the tutor sidebar (you may need to restart the WebxPST Tutor plugin to see this). Each line in this textbox shows one GUI event, with the appnode name, an '=' sign, and the value sent for the appnode. You can cut and paste appnode names from this box into your .xpst file.

# Feedback #

The feedback section is structured with the goalnode name followed by the details for that goalnode including feedback following in curly brackets.  These details may include:
  * The "answer" or value that is correct to proceed in the sequence
  * One or more hints
  * One or more JITs, with specific conditions specified if desired
  * Variables and their values

Hints and JITs may refer to variables by using the variable name, or they may refer to the value entered by the student by using {v}.

Here is are some examples of ways that goalnodes might be used in the feedback section, including examples of goalnodes with different answer types like integer, regular expression, string, and file path.

```
	int
	{
		answer: 3;
		JIT {v > 3}: "too big";
		JIT {v < 3}: "too small";
		Hint: "a: 3";
	}
	
	filepath
	{
		answer: FilePath("foo.jpg");
		Hint: "b: file path ending in foo.jpg";
		Hint: "another hint";
	}
	
	string
	{
		answer: "hi";
		JIT {v == "bye"}: "bye to you";
		JIT: "hi, not {v}";
		Hint: "c: {answer}";
	}

	float
	{
		answer: 5.5;
		JIT {v > answer}: "too big";
		JIT {v < answer}: "too small";
		Hint: "d: 5.5";
	}
	
	regex
	{
		answer: RegEx("what(,what)*");
		Hint: "Type something that starts with 'what' and has as many other what's as you want.";
	}
	
	mixedint
	{
		answer: 3;
		Hint: "3";
		JIT {v == "text"}: "shouldn't be text";
		JIT {v > 10}: "way too big";
	}

	mixedfloat
	{
		answer: 3.3;
		Hint: "3.3";
		JIT {v == "text"}: "shouldn't be text";
		JIT {v > 11.1}: "even more way too big";
		JIT {v > 10}: "way too big";
	}
```

# JITs for going off path #

Once you have a basic cognitive model built for the correct paths, you may want to consider more carefully what happens when the user does something wrong.

## Priorities ##

Each mapping may have a priority specified with it.  This indicates to the event mapper which of the mappings should be used if more than one goalnode is indicated with a particular mapping.  JITs for going off path have a lower priority number, allowing us to specify “off path” goalnodes as fallbacks for when a mapping is not currently mapped as part of the primary sequence.


## Examples of off path goalnodes ##

Let’s illustrate with a few examples.

In the VaNTH tutor, a large number of GUI interactions are identified as being generally off path by a switch in the mappings section:
```
	switch
	{
		AttemptUp:click="moved the attempt up",
		...
		ItemKind="selected the wrong kind for this object"
	} => Error-Offpath;
```

Then, in the feedback section, the answer doesn’t matter (though it’s best to put something anyway, such as “foo”) and the JIT will include the text that was paired with the mapping for the student input, {v}.
The feedback for Error-Offpath in our example:
```
	Error-Offpath {
		answer: "foo";
		JIT: "<block/>You {v}. That's not something you need to do right now.  Request a hint if you'd like to know what to do next.";
	}
```
The sequence is probably the least intuitive part of creating off path goalnodes.  To have the goalnode always mapped, it must be added to the end of the sequence with an and, e.g. (This-goalnode then That-Goalnode) and Error-Offpath.

In some cases, you may want a more specific JIT message to appear for a subset of the incorrect actions possible.  In the VaNTH authoring tool, there are sometimes multiple buttons of the same name visible at one time, and a user may click the wrong one.  Here is what we did to map all of the “Edit” buttons to a single off path goalnode:
```
	[priority=1]
	switch
	{
		ProblemEdit:click="Problems",
		QuestionEdit:click="Questions",
		EditCase:click="Case Details",
		AttemptEdit:click="Attempt Details and Feedback",
		EditItem:click="Items details"
	} => Error-Wrong-Edit;
```
Again in the feedback section, any value is OK for the answer, and the JIT can refer to the string provided in the mapping:
```
	Error-Wrong-Edit {
		answer: "foo";
		JIT: "<block/>You clicked the wrong Edit button.  That edit button is used to edit {v}.  Please click on other Edit button.  Ask for a hint if you need help.";
	}
```
In this case, we only want the Error-Wrong-Edit JIT to display if the user is at a point in the sequence where the correct step is to click an Edit button but he clicks the wrong one.  Thus, in the sequence, wherever we have an Edit button, we OR the correct goalnode with the Error-Wrong-Edit goalnode.  That way, the JIT will happen every time they click the wrong Edit button until they finally click the correct one.  (The Error-Wrong-Edit goalnode will never be “completed” because the student input will never match the answer, “foo.”)

Not all off path mappings necessarily require multiple items mapped to the same goalnode.  For instance, in the resource view, one should never edit the Name field for the resource, so when the user clicks on it, a JIT appears.  There will never be a mapping with a higher priority, so doing the action associated with this mapping will always result in a JIT.
[priority=1]ItemName.childNodes-0:click => Error-Item-Name;