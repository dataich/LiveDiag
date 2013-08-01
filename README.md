LiveDiag
========

Live Preview App for Markdown+blockdiag(+seqdiag +actdiag +nwdiag)

![image](Sample/blockdiag.png)
![image](Sample/seqdiag.png)
![image](Sample/actdiag.png)
![image](Sample/nwdiag.png)

all block code from [blockdiag.com](http://blockdiag.com/). Thanks!!

## Platform

- Mac OS 10.8+

## Requirement

- [blockdiag](http://blockdiag.com/ja/blockdiag/introduction.html#id2) (add path to `/usr/bin/blockdiag`)
- [seqdiag](http://blockdiag.com/ja/seqdiag/introduction.html#setup) (add path to `/usr/bin/seqdiag`)
- [actdiag](http://blockdiag.com/ja/actdiag/introduction.html#setup) (add path to `/usr/bin/actdiag`)
- [nwdiag](http://blockdiag.com/ja/nwdiag/introduction.html#setup) (add path to `/usr/bin/nwdiag`)

	**at this time cannot load user $PATH. I'm trying to improve it.**

## Installation
1. Install [blockdiag](http://blockdiag.com/ja/blockdiag/introduction.html#macosx-macports), [seqdiag](http://blockdiag.com/ja/seqdiag/introduction.html#setup), [actdiag](http://blockdiag.com/ja/actdiag/introduction.html#setup) and [nwdiag](http://blockdiag.com/ja/nwdiag/introduction.html#setup)

2. add path to /usr/bin

	```
	$ sudo ln -s {blockdiag path} /usr/bin/blockdiag
	$ sudo ln -s {seqdiag path} /usr/bin/seqdiag
	$ sudo ln -s {actdiag path} /usr/bin/actdiag
	$ sudo ln -s {nwdiag path} /usr/bin/nwdiag
	```

3. Download LiveDiag.app and place it to /Applications

## Release

[1.0.0](https://github.com/dataich/LiveDiag/releases/tag/1.0.0)

## Feature

- live preview for following content
	- Markdown
	- blockdiag
	- seqdiag
	- actdiag
	- nwdiag
- printing

## Give me your feedback

If you have any suggestion and find bugs, please let me know.

- Contact to [@dataich](https://twitter.com/dataich)
- Post to [Github Issues](https://github.com/dataich/LiveDiag/issues)