# GodotMultipleResolution2DTutorial
Brief Overview of Handling Different Screen Resolutions, Content Scale Size, Stretch, and Screen Selection at Runtime

Code is MIT licensed
The Image of George Carlin is from Wikimedia and I believe free for non-commercial use
The Resolution Image is CC-BY license (okay to use freely with attribution for my hard work making colored rectangles...There is also an Aseprite file if you wish to add your own additional testing resolutions using aseprite that is similarly CC-BY licensed)

The big takeaway is using get_tree().root to obtain the root window and set sizes. The DisplayServer singleton is also helpful for obtaining screen information.
