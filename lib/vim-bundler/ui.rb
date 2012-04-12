module VimBundler
  class UI
    def initialize(shell)
      @shell = shell
    end
    def info(msg)
      @shell.say(msg)
    end

    def confirm(msg)
      @shell.say(msg, :green)
    end

    def warn(msg)
      @shell.say(msg, :yellow)
    end

    def error(msg)
      @shell.say(msg, :red)
    end
  end
end
