ChildProcess = require('child_process')
PTY = require('pty.js')
Path = require('path')
Shellwords = require('shellwords')

module.exports =
class ScriptRunnerProcess
  @run: (view, cmd, env, editor) ->
    scriptRunnerProcess = new ScriptRunnerProcess(view)
    
    scriptRunnerProcess.execute(cmd, env, editor)
    
    return scriptRunnerProcess
  
  constructor: (view) ->
    @view = view
    @child = null
  
  detach: ->
    @view = null
  
  stop: (signal = 'SIGINT') ->
    if @child
      console.log("Sending", signal, "to child", @child, "pid", @child.pid)
      process.kill(-@child.pid, signal)
      if @view
        @view.append('<Sending ' + signal + '>', 'stdin')
  
  resolvePath: (editor, callback) ->
    if editor.getPath()
      cwd = Path.dirname(editor.getPath())
      
      # Save the file if it has been modified:
      editor.save()
      
      callback(editor.getPath(), cwd)
      
      return true
    
    # Otherwise it was not handled:
    return false
  
  resolveSelection: (editor, callback) ->
    cwd = atom.project.path
    
    selection = editor.getLastSelection()
    
    if selection? and !selection.isEmpty()
      callback(selection.getText(), cwd)
      return true
    else
      callback(editor.getText(), cwd)
      return true
  
    # Otherwise it was not handled:
    return false
  
  execute: (cmd, env, editor) ->
    # Split the incoming command so we can modify it
    args = Shellwords.split cmd
    
    return true if @resolvePath editor, (path, cwd) =>
      args.push path
      @spawn args, cwd, env
    
    return true if @resolveSelection editor, (text, cwd) =>
      @spawn args, cwd, env
      
      @child.stdin.write(text)
      @child.stdin.write("\n\x04")
      @child.stdin.end()
    
    @view.header("Don't know how to run" + cmd.join(' '))
    return false
  
  spawn: (args, cwd, env, callback) ->
    # Spawn the child process:
    console.log("ScriptRunner.spawn", args[0], args.slice(1), cwd, env)
    
    @child = PTY.spawn(args[0], args.slice(1), cwd: cwd, env: env, stdio: ['pipe', 'pty', 'pty'])
    @startTime = new Date
    
    # Update the status (*Shellwords.join doesn't exist yet):
    @view.header('Running: ' + args.join(' ') + ' (pid ' + @child.pid + ')')
    
    # Handle various events relating to the child process:
    @child.on 'data', (data) =>
      if @view?
        lines = data.toString().split '\n'
        for line in lines
          @view.append(line, 'stdout')
        
        @view.scrollToBottom()
    
    @child.on 'close', (code, signal) =>
      @child = null
      @endTime = new Date
      if @view
        duration = ' after ' + ((@endTime - @startTime) / 1000) + ' seconds'
        if signal
          @view.footer('Exited with signal ' + signal + duration)
        else
          # Sometimes code seems to be null too, not sure why, perhaps a bug in node.
          code ||= 0
          @view.footer('Exited with status ' + code + duration)
