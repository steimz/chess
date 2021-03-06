class Game < Gosu::Window
  attr_accessor :state

  def initialize
    super 800, 800, fullscreen: true
    self.caption = 'Chess'
  end

  def update
    @state.update
  end

  def draw
    @state.draw
  end

  def button_down(id)
    @state.button_down(id)
  end

  def button_up(id)
    @state.button_up(id)
  end

  def needs_cursor?
    true
  end
end
