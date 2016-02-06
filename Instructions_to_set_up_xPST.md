# Details #

1. Download the xPST plugin from [http://xpst.vrac.iastate.edu/WebxPSTPlugin/WebxPST.xpi](http://xpst.vrac.iastate.edu/WebxPSTPlugin/WebxPST.xpi). (Note that this plugin works only with Mozilla Firefox 3.0 or above.)

2. Download the Root folder from [http://xpst.vrac.iastate.edu/WebxPSTPlugin/Root.rar](http://xpst.vrac.iastate.edu/WebxPSTPlugin/Root.rar). Extract this to any location on your computer. This has the Tomcat server.

3. Download the .war file from [http://xpst.vrac.iastate.edu/WebxPSTPlugin/WebxPST.war](http://xpst.vrac.iastate.edu/WebxPSTPlugin/WebxPST.war). Copy this file to Root\apache-tomcat-6.0.18\webapps. Rename it to WebxPST.war (Remove the .zip extension)

4. Start Tomcat by opening Root\apache-tomcat-6.0.18\bin\startup.bat

5. Once you have written all the files for your tutor (See [Instructions\_to\_Create\_an\_xPST\_Aware\_Webpage](http://code.google.com/p/xpst/wiki/Instructions_to_Create_an_xPST_Aware_Webpage)), you can run your tutor by opening the following link: `http://localhost:8080/WebxPST/tutorname.html`