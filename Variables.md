**{answer}** - Refers to the correct answer of the current goal node.<br>
Hint: "Answer is {answer}";<br>
JIT : "Answer is {answer}";<br><br>
<b>{v}</b> - Refers to answer entered by the student for the current goal node.<br>
This variable can only be used in JITs and not in Hints.<br>
It can be used both inside the JIT message as well as the condition.<br>
JIT : "{v} is not the answer.";     #default JIT <br>
JIT {v < "-2"}: "Too small";<br>
JIT {v < Subtract("a","b") }: "Too small";<br>
JIT {v == Sum("a","b")}: “Answer is not the sum”;<br>
JIT {v == Ans("a")}: "Cannot be the same.";