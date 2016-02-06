# The Extensible Problem-Specific Tutor (xPST) System #

Our design for the Extensible Problem-Specific Tutor System is comprised of three main components:
  1. the xPST Engine,
  1. the Presentation Manager, and
  1. the Graphical Tutor Editor.

![http://xpst.googlecode.com/svn/trunk/design/xPST_architecture.png](http://xpst.googlecode.com/svn/trunk/design/xPST_architecture.png)
> _**Figure 1:** The architecture of xPST. The xPST Engine "eavesdrops" on the software interface or website that needs tutoring. The Presentation Manager gives visual feedback on the software interface. The xPST File provides the feedback and goal structure needed for each task within the tutor. The Graphical Tutor Editor enables teachers to create the xPST File without programming skills._

Figure 1 shows the relationship between these components and the to-be-tutored interface. The xPST File contains the tutoring information data—what to do when as the student interacts with the interface. This information includes:
  1. how to map interface widgets from the tutored software or website onto more meaningful names and constructs for the various learning goals,
  1. the sequence in which students are supposed to interact and complete these learning goals,
  1. the correct answer for each learning goal, and
  1. hints and just-in-time error messages for each learning goal.

The xPST Engine observes the student’s interaction in the interface. Using the xPST File, the xPST Engine knows the correct tutoring response when the student does either the right or wrong thing in the interface, and knows which hint or just-in-time message to display at the appropriate time.

When the xPST Engine decides that information needs to be conveyed back to the student (e.g., a wrong answer needs to be flagged or a hint message needs to be displayed), that information is relayed to the Presentation Manager. The Presentation Manager knows how to display that information to the student given the current interface. For example, a wrong answer may need to be shown in red text, a radio button highlighted, or a tooltip with appropriate text may need to appear. The Presentation Manager handles the communication between the xPST Engine and the interface.

## Authoring xPSTs ##
Obviously the creation of the xPST File is a critical piece, as it contains all of the tutoring information that the xPST Engine uses to guide and provide information to the student. The Graphical Tutor Editor enables an author to easily create a new xPST File or adapt an existing xPST File to a new situation. Corresponding to the four main pieces of an xPST File, the Graphical Tutor Editor allows the author to:
  1. map interface widget names to learning goal names,
  1. sequence learning goals using a drag-and-drop interface,
  1. indicate the correct answer(s) for a learning goal and the manner in which it should be checked, and
  1. enter hint and just-in-time messages.

Mapping interface widgets to more meaningful names allows the author to more easily build a tutor. Entering text into a particular text entry field might be communicated as "`textField._1._6_:main`" to the xPST Engine, but that is meaningless. With both the Graphical Tutor Editor and the interface running, the author can interact with an interface widget, and see what kind of message is generated. The author can then easily providing a mapping from whatever the interface produces naturally to something more meaningful for the author (perhaps "GeneSequence1Text").

Once the mapping has been specified for all the relevant widgets and all the learning goals have been defined, it may be necessary to provide an ordering for these learning goals. Certain goals may be necessary to perform first, and the ordering will notate this. This ordering will then affect the later tutoring. We have devised a simple ordering language, but it can provide for optional and alternative paths, plus situations where the goal order must be in a specific order versus cases where order does not matter. If an ordering is desired, the tool assists the author in creating the order by providing a simple-to-use, graphical drag-and-drop method with which to define the order.

In order to complete each learning goal, the student will need to provide an answer. A learning goal may have a single specific correct answer, multiple specific answers, or a range of answers. Regardless, the Graphical Tutor Editor provides a way for the author to indicate the answer, and also to indicate how that answer should be checked. For example, for numeric answers, "4" might be the right answer, but the tutor should perhaps also accept the answer if the student enters "2+2." For text answers, case may or may not be an issue. The author will need to indicate how the answer should be checked, choosing from the different ways in which such an answer could be checked. Additional answer types can easily be added via a plug-in architecture (e.g., the learning goal might have a student indicate a color choice, and the answer will need to be checked via some color answer type, perhaps based on RGB values).

Lastly, the Graphical Tutor Editor allows the author to specify which hints to give on a particular learning goal, given where it is at in the ordering, and to specify the just-in-time messages that the tutor displays given certain wrong responses by the student. Hints can be specified in a multi-step sequence, from more general hints to more specific hints. This allows for the information to be presented more gradually, if desired, so that the student might be able to figure out the answer before it is given away. Just-in-time messages are responses by the tutor to specific wrong answers. For example, if the answer is "-4" but the student type just "4," the author may want to alert the student to the sign of the answer. As such, authors will need to provide a set of answers with accompanying answer types that will trigger the just-in-time-message. Hints and just-in-time messages are specified using an html-like editor, allowing for some mark-up and simple variable use (e.g., to echo back the wrong answer that the student gave) within the hint or just-in-time message.

## Why the xPST Authoring System? ##
As noted previously, prior authoring environments have resulted in dramatic reductions in the time needed to produce intelligent tutoring systems. However, users of our previous authoring tool effort produced better tutors when they had a programming background (Blessing & Gilbert, 2008). Having teachers undergo some kind of programming mini-boot camp seems unreasonable. Instead, we investigated ways to reduce or eliminate the even rudimentary programming aspects of the previous system. In order to use our previous system, authors had to create an object hierarchy of learning goals and produce simple predicates to assist in figuring out which hint or just-in-time message to give. The advantage here is that it makes it easy for multiple problems to use the same underlying representation. However, creating that representation in a useful manner apparently is at least assisted by programming knowledge.

In designing the xPST System, we want to eliminate that assist of programming knowledge, so that a wider range of people can participate in creating intelligent tutors. By eliminating the object hierarchy and predicates, the resulting "tutors" are specific to a particular problem (or perhaps a narrow range of problems). However, it relieves the need of having to produce those more "programmy" aspects (trees and predicates) in order to provide tutoring. If the author is interested in creating just a simple tutor for a small number of situations, then the xPST System is more ideal than previous efforts. Indeed, even in our own work (e.g., Hategekimana et al, 2008), we would have been well-served by this more streamlined, though not as generalizable, way of creating a cognitive model.

## What Exists and What Needs to be Built ##
Various pieces of the xPST System exist in varying degrees of completeness. Earlier iterations of the xPST Engine and the Presentation Manager exist. However, the xPST Engine needs to be augmented with the ability to provide the tutoring itself (in the past the tutoring, checking answers and providing hint messages, was provided by a third-party application). Some of the abilities of the Graphical Tutor Editor exist in different tools. The ability to observe a running interface and inspect what widgets are being used exists. Another tool exists that allows the simple ordering of learning goals.

In short, required steps for us to create a fully functioning xPST System for the Year 1 Design Prototype:
  * Augment xPST Engine to check answers and provide the appropriate hint message upon student request
  * Create unified Graphical Tutor Editor
    * Integrate existing mapping tool
    * Integrate existing learning goal ordering tool
    * Add graphical capability to attach answers, hints, and just-in-time messages to learning goals

Once the first version of the system is in place, we can then start having teachers produce tutors. We will assess both student learning using these tutors and also the effectiveness of the authoring process. The results of these observations will be used to further refine the system.