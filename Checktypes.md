**Ans("a") -**
Refers to the answer of another goal node.<br>
eg: <code>JIT {v == Ans("a")}: "Cannot be the same";</code><br><br>
<b>Abs("a") -</b>
Checks if the absolute value of the entered answer equals "a".<br>
eg: <code>JIT {v == Abs("1")}: "Cannot be the +/-1";</code><br><br>
<b>RegEx("a") -</b>
Checks if the entered answer is equivalent to the regular expression mentioned inside the double quotes.<br>
eg: <code>answer:  RegEx("[0-9]")</code>;<br><br>
<b>Round("a") -</b>
Checks if the rounded entered answer euqals "a".<br>
eg: <code>answer:  Round("a");</code><br><br>
<b>Floor("a") -</b>
Checks if the floor of the entered answer euqals "a".<br>
eg: <code>answer:  Floor("a");</code><br><br>
<b>Ceil("a") -</b>
Checks if the ceiling of the entered answer euqals "a".<br>
eg: <code>answer:  Ceil("a");</code><br><br>
<b>IsRange("[<a href='.md'>.md</a>]","a","b") -</b>
Checks if the entered answer is inside the interval ["a","b"]. The other variants of this checktype are Range("()", "a", "b"), Range("[)", "a", "b") and Range("(]", "a", "b").<br>
eg: <code>answer:  IsRange("[)","a","b");</code><br><br>
<b>IsNotRange("[<a href='.md'>.md</a>]","a","b") -</b>
Checks if the entered answer is outside the interval ["a","b"]. The other variants of this checktype are Range("()", "a", "b"), Range("[)", "a", "b") and Range("(]", "a", "b").<br>
eg: <code>answer:  IsNotRange("()","a","b");</code><br><br>
<b>IsAbsRange("[<a href='.md'>.md</a>]","a","b") -</b>
Checks if the absolute value of the entered answer is inside the interval ["a","b"]. The other variants of this checktype are IsAbsRange("()", "a", "b"), IsAbsRange("[)", "a", "b") and IsAbsRange("(]", "a", "b").<br>
eg: <code>answer:  IsRange("[)","a","b");</code><br><br>
<b>IsNotAbsRange("[<a href='.md'>.md</a>]","a","b") -</b>
Checks if the absolute value of the entered answer is outside the interval ["a","b"]. The other variants of this checktype are IsNotAbsRange("()", "a", "b"), IsNotAbsRange("[)", "a", "b") and IsNotAbsRange("(]", "a", "b").<br>
eg: <code>answer:  IsNotRange("()","a","b");</code><br><br>
<b>Sum("a","b") -</b>
Checks if the entered answer is the sum of "a" and "b".<br>
eg: <code>answer:  Sum("a","b");</code><br><br>
<b>Subtract("a","b") -</b>
Checks if the entered answer is the difference of "a" and "b".<br>
eg: <code>answer:  Subtract("a","b");</code><br><br>
<b>Multiply("a","b") -</b>
Checks if the entered answer is the product of "a" and "b".<br>
eg: <code>answer: Multiply("a","b");</code><br><br>
<b>Divide("a","b") -</b>
Checks if the entered answer is the quotient of "a" and "b".<br>
eg: <code>answer: Divide("a","b");</code><br><br>
<b>Lcm("a","b") -</b>
Checks if the entered answer is the Least Common Multiple of "a" and "b".<br>
eg: <code>answer: Lcm("a","b");</code><br><br>
<b>IsMultiple("a") -</b>
Checks if the entered answer is a multiple of "a".<br>
eg: <code>answer: IsMultiple("a");</code><br><br>
<b>IsNotMultiple("a") -</b>
Checks if the entered answer is not a multiple of "a".<br>
eg: <code>answer: IsNotMultiple("a");</code><br><br>
<b>NumSum("a","b","c","d") -</b>
Checks if the entered answer equals the numerator of the sum of the fractions "a"/"b" and "c"/"d".<br>
eg: <code>answer: NumSum("a","b","c","d");</code><br><br>
<b>DenomSum("a","b","c","d") -</b>
Checks if the entered answer equals the denominator of the sum of the fractions "a"/"b" and "c"/"d".<br>
eg: <code>answer: DenomSum("a","b","c","d");</code>