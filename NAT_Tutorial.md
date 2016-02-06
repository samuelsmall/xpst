**Checktypes and Their Usage**

('str' refers to a sequence of 1 or more strings)
<br><br>Any(n1,n2)<br>
<br>Maches any sequence, with a minimum of n1 and maximum of n2 words<br>
<br><code>Eg: Any(0,5): This matches any sequence of 0 to 5 words.</code>
<br><br>Exact(str)<br>
<br>Checks for an exact match<br>
<br><code>Eg: Exact('project'): This looks for an exact match of the word 'project'</code>
<br><br>Almost(str)<br>
<br>Checks for a match after ignoring vowels<br>
<br><code>Eg: Almost('result', 'answer'): This looks for a match of either 'result' or 'answer', after ignoring the vowels.</code>
<br><br>Hamming(str, n)<br>
<br>Checks for a match with a word that is within n substitutions of str.<br>
<br><code>Eg: Hamming('project', 1): This looks for a 'Hamming match' of the word 'project'.</code>
<br><br>Levenshtein(str, n)<br>
<br>Checks for a match with a word that is within n edits of str.<br>
<br><code>Eg: Levenshtein('project'): This looks for a 'Levenshtein match' of the word 'project'.</code>
<br><br>Soundex(str)<br>
<br>Checks for a match with a word whose soundex code is the same as str<br>
<br><code>Eg: Soundex('project'): This looks for a 'Soundex match' of the word 'project'.</code>
<br><br>Stemmer(str)<br>
<br>Checks for a match with the stem of a word (uses PorterStemmer)<br>
<br> <code>Eg: Stemmer('fish') would return true for the words 'fish', 'fishing' and 'fished'.</code>
<br><br>Not(n, d, str)<br>
<br>Checks if the n words  in direction d are not equal to str<br>
<br><code>Eg: Not(3, '&lt;-', 'not', 'isnt') Exact('significant'): This checks if the three words appearing to the left of 'significant' are neither 'not' nor 'isnt' </code>
<br><code>Eg: Not(2, '-&gt;', 'not', 'isnt') Exact('result'): This checks if the two words appearing to the right of 'result' are neither 'not' nor 'isnt' </code>

<b>Example Code (WAT)<br></b><br><br>
# <code>Checking for answers that match the sentence "Reject the null hypothesis. There is a significant difference between rock music and no music", and its variants. Also making sure that the words 'reject'  and 'significant' are not preceded by 'not'.</code>
<br><code>answer: IsNLP("Any(0,4) Not('fail', 'not',5, '&lt;-') Levenshtein('reject') Any(0,3) Levenshtein('null') Levenshtein('hypothesis') Any(0,5) Not('no', 'not', 'isnt', 4, '&lt;-') Levenshtein('significant') Levenshtein('difference') Any(0,2) Levenshtein('between') Any(0,7)");</code>
<br><code># Checking for the absence of the word 'difference'</code>
<br><code>JIT { v == IsNotNLP("Any(0,20) Levenshtein('difference') Any(0,20)")} : "You did not mention if there is a difference between the 2 conditions." ;</code>
<br><code># Checking for the absence of the word 'reject'</code>
<br><code>JIT { v == IsNotNLP("Any(0,20) Levenshtein('reject') Any(0,20)")} : "You did not mention if we have to reject or accept the null hypothesis";</code>
<br><code># Checking for the presence of the phrase 'reject alternate' and its variants</code>
<br><code>JIT { v == IsNLP("Any(0,20) Levenshtein('reject') Any(0,3) Levenshtein('alternate') Any(0,20)")} : "Are you sure you want to reject the alternate hypothesis?";</code>
<br><code># Checking for the presence of the phrase 'fail to reject' and its variants</code>
<br><code>JIT { v == IsNLP("Any(0,20) Levenshtein('fail', 'not') Any(0,3) Levenshtein('reject') Any(0,3) Levenshtein('null') Any(0,20)")} : "Are you sure you do not want to reject the null hypothesis?";</code>
<br><code># Checking for the presence of the phrase 'no significant difference' and its variants</code>
<br><code>JIT { v == IsNLP("Any(0,20) Exact('no', 'not', 'isnt') Any(0,3) Levenshtein('significant') Any(0,3) Levenshtein('difference') Any(0, 20)")} : "Are you sure that the difference is not significant? ";</code>
<br><code>Hint: "Reject the hypothesis.";</code>

<b>Example Code (NAT/ConceptGrid)<br></b><br><br>
<code>Checktype: "Any(0,4) Not('fail', 'not',5, '&lt;-') Levenshtein('reject') Any(0,3) Levenshtein('null') Levenshtein('hypothesis') Any(0,5) Not('no', 'not', 'isnt', 4, '&lt;-') Levenshtein('significant') Levenshtein('difference') Any(0,2) Levenshtein('between') Any(0,7)"</code>
<br><code>Response: Reject the null hypothesis. There is a significant difference between rock music and no music.</code>

<b>Tips</b>

1. First, test your templates on sample responses, using the NAT for ConceptGrids.<br>
2. Use Levenshtein for matching words of length greater than 5. For shorter words, use 'Almost', unless you want an exact match.<br>
3. Be liberal while setting the upper limit for 'Any' at the begining and end of the template. At other positions, try to use set limits that are neither too high nor too small.<br>
4. Avoid punctuations in checktypes, though they are ignored by the NAT.<br>
5. While writing JITs, try to match the presence of wrong phrases, and the absence of key phrases, rather than matching entire answer.<br>