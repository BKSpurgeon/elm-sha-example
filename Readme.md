### Simple Reproducible Example

This Repository hopes to generate a reproducable example of a problem: 

* that a large file seems to be taking an abnormally long time to calculate SHA values.

* I am getting an a different SHA1 value produced: b1bfcc56a13423048e866f7bc4dd6a8f617d3ba8 when I am expecting it to be: 85a0cbc3fa0f4e7746a3033372626ade7cae761b according to other methods of deriving the Sha1 value. I am unable to pinpoint the sources of this discrepancy.

Firefox: seems to be taking an abnormally long time: over 20+ seconds. Optimising produces but marginal improvements.

Chromium: this is an order of magnitude faster. Around 11 or so seconds. But still a little too long than what it should take.

### Set-up
I am using elm-live. Please follow the installation instructions here: https://github.com/wking-io/elm-live#installation

Or alternatively, you can use an elm make with the optimised flag:

```
make src/Main.elm --optimize --output=elm.js
```

(I have not uglified that js.)

And then you can see the results if you open: index-optimised.html

### Run it!

Click on index-optimised.html or index.html and upload the file contained in the folder: `skypeforlinux-64.deb` - which is a file about 80 mb.

The calculated sha1 for this file is according to the commands on my terminal and other sources is: `85a0cbc3fa0f4e7746a3033372626ade7cae761b` but the Sha that is actually returned is something else: `b1bfcc56a13423048e866f7bc4dd6a8f617d3ba8`

Online SHA1 calculators: 

* https://md5file.com/calculator
* http://onlinemd5.com/

The above calculators suggest that the SHA1 is: `85a0cbc3fa0f4e7746a3033372626ade7cae761b`


### Ellie Examples

* https://ellie-app.com/99qN9FsPQv5a1

This Ellie adds time stamps but does not display SHAs: 

* https://ellie-app.com/99bBskZ3vDJa1





