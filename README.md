# Script Runner

This package will run various script files inside of Atom.
It currently supports JavaScript, CoffeeScript, Ruby, Python, and Go. You
can add more.

![Example](http://github.com/ioquatix/script-runner/raw/master/resources/screenshot-1.png)

## Usage

* Hit Alt+R to launch the runner for the active window.
* Hit Ctrl+C to kill a currently running process.

## Configuring

This package uses the following default configuration:

```cson
'runner':
  'scopes':
    'coffee': 'coffee'
    'js': 'node'
    'ruby': 'ruby'
    'python': 'python'
    'go': 'go run'
  'extensions':
    'spec.coffee': 'jasmine-node --coffee'
```

You can add more commands for a given language scope, or add commands by
extension instead (if multiple extensions use the same syntax). Extensions
are searched before scopes (syntaxes).

To do so, add the configuration to `~/.atom/config.cson` in the format provided
above.

The mapping is `SCOPE|EXT => EXECUTABLE`, so to run JavaScript files through
phantom, you would do:

```cson
'runner':
  'scopes':
    'js': 'phantom'
```

Note that the `source.` prefix is ignored for syntax scope listings.

Similarly, in the extension map:

```cson
'runner':
  'extensions':
    'js': 'phantom'
```

Note that the `.` extension prefix is ignored for extension listings.

## License

Released under the MIT license.

Copyright, 2014, by Loren Segal.
Copyright, 2014, by Ivan Storck.
Copyright, 2014, by Alexandr Lukyanov.
Copyright, 2014, by Robert Ahlberg.
Copyright, 2014, by Samuel G. D. Williams. <http://www.codeotaku.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
