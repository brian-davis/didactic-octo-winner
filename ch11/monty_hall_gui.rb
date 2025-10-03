require "tk"

# GUI application for Monty Hall Problem game.
class Game

  # REFACTOR: too much
  attr_accessor :parent, :img_file, :choice, :winner,
    :reveal, :first_choice_wins, :pick_change_wins,
    :photo_lbl,
    :door_choice,
    :change_door,
    :yes,
    :no,
    :unchanged_wins_txt,
    :changed_wins_txt

  DOORS = ["a", "b", "c"]

  def initialize(tk_frame)
    @parent = tk_frame
    @img_file = "images/all_closed.png"  # current image of doors
    @choice = ""  # player's door choice
    @winner = ""  # winning door
    @reveal = ""  # revealed goat door
    @first_choice_wins = 0  # counter for statistics
    @pick_change_wins = 0  # counter for statistics

    # REFACTOR: Python code sets these dynamically, not in initializer.
    # REFACTOR: weak object-orientation, state-machine, method isolation, DRY, magic numbers, missing constants in Python
    @photo_lbl = nil
    @door_choice = nil
    @change_door = nil
    @yes = nil
    @no = nil
    @unchanged_wins_txt = nil
    @changed_wins_txt = nil
  end

  # Create label, button and text widgets for game.
  def create_widgets!

    # create label to hold image of doors
    img = TkPhotoImage.new(:file => self.img_file)
    self.photo_lbl = Tk::Tile::Label.new(self.parent) do
      image(img)
      text("")
      borderwidth(0)
    end
    self.photo_lbl.grid({
      :row => 0,
      :column => 0,
      :columnspan => 10,
      :sticky => "W"
    })

    # create the instruction label

    instr_input = [
      ['Behind one door is CASH!',     1, 0, 5, 'W'],
      ['Behind the others:  GOATS!!!', 2, 0, 5, 'W'],
      ['Pick a door:',                 1, 3, 1, 'E']
    ]

    for itext, irow, icolumn, icolumnspan, isticky in instr_input
      # instr_lbl = tk.Label(self.parent, text=text)
      instr_lbl = Tk::Tile::Label.new(self.parent) { text(itext) }
      instr_lbl.grid({
        :row => irow,
        :column => icolumn,
        :columnspan => icolumnspan,
        :sticky => isticky,
        :ipadx => 30 #padx?
      })
    end

    # create radio buttons for getting initial user choice

    self.door_choice = TkVariable.new(String)
    self.door_choice.set_string(nil)

    radio_callback = self.method(:win_reveal)
    var_object = self.door_choice
    a = Tk::RadioButton.new(self.parent) do
      text("A")
      variable(var_object)
      value("a")
      command(radio_callback)
    end

    b = Tk::RadioButton.new(self.parent) do
      text("B")
      variable(var_object)
      value("b")
      command(radio_callback)
    end

    c = Tk::RadioButton.new(self.parent) do
      text("C")
      variable(var_object)
      value("c")
      command(radio_callback)
    end

    # create widgets for changing door choice

    self.change_door = TkVariable.new(String)
    self.change_door.set_string(nil)

    instr_lbl = Tk::Tile::Label.new(self.parent) do
      text("Change doors?")
    end
    instr_lbl.grid({
      :row => 2,
      :column => 3,
      :columnspan => 1,
      :sticky => "E"
    })

    var_object = self.change_door
    radio_callback = self.method(:show_final)
    self.yes = Tk::RadioButton.new(self.parent) do
      state("disabled")
      text("Y")
      variable(var_object)
      value("y")
      command(radio_callback)
    end

    self.no = Tk::RadioButton.new(self.parent) do
      state("disabled")
      text("N")
      variable(var_object)
      value("n")
      command(radio_callback)
    end

    # create text widgets for win statistics
    defaultbg = self.parent.cget('bg')
    self.unchanged_wins_txt = TkText.new(self.parent) do
      width(20)
      height(1)
      wrap("word")
      bg(defaultbg)
      fg("black")
      borderwidth(0)
    end
    self.changed_wins_txt = TkText.new(self.parent) do
      width(20)
      height(1)
      wrap("word")
      bg(defaultbg)
      fg("black")
      borderwidth(0)
    end

    # place the widgets in the frame

    a.grid({
      :row => 1,
      :column => 4,
      :sticky => 'W',
      :padx => 20
    })

    b.grid({
      :row => 1,
      :column => 4,
      :sticky => 'N',
      :padx => 20
    })

    c.grid({
      :row => 1,
      :column => 4,
      :sticky => 'E',
      :padx => 20
    })

    self.yes.grid({
      :row => 2,
      :column => 4,
      :sticky => 'W',
      :padx => 20
    })


    self.no.grid({
      :row => 2,
      :column => 4,
      :sticky => 'N',
      :padx => 20
    })

    self.unchanged_wins_txt.grid({
      :row => 1,
      :column => 5,
      :columnspan => 5
    })

    self.changed_wins_txt.grid({
      :row => 2,
      :column => 5,
      :columnspan => 5
    })
  end

  # Update current doors image.
  def update_image
    img = TkPhotoImage.new(:file => self.img_file)
    self.photo_lbl['image'] = img
  end

  # Randomly pick winner and reveal unchosen door with goat.
  def win_reveal
    # puts "win_reveal"
    # puts "self.door_choice: #{self.door_choice}"
    door_list = DOORS.dup
    self.choice = self.door_choice
    self.winner = door_list.sample
    # Python .remove() deletes only 1st match
    door_list.delete_at(door_list.index(self.winner))

    if door_list.include?(self.choice)
      door_list.delete_at(door_list.index(self.choice))
      self.reveal = door_list.first
    else
      self.reveal = door_list.sample
    end

    self.img_file = ("images/reveal_#{self.reveal}.png")
    self.update_image()

    # turn on and clear yes/no buttons
    self.yes['state'] = 'normal'
    self.no['state'] = 'normal'

    self.change_door.set_string(nil)

    self.img_file = "images/all_closed.png"
    self.parent.after(2000, self.method(:update_image))
  end

  # Reveal image behind user's final door choice & count wins.
  def show_final
    door_list = DOORS.dup
    switch_doors = self.change_door
    if switch_doors == "y"
      door_list.delete_at(door_list.index(self.choice))
      door_list.delete_at(door_list.index(self.reveal))
      new_pick = door_list.first
      if new_pick == self.winner
        self.img_file = "images/money_#{new_pick}.png"
        self.pick_change_wins += 1
      else
        self.img_file = "images/goat_#{new_pick}.png"
        self.first_choice_wins += 1
      end
    elsif switch_doors == "n"
      if self.choice == self.winner
        self.img_file = "images/money_#{self.choice}.png"
        self.first_choice_wins += 1
      else
        self.img_file = "images/goat_#{self.choice}.png"
        self.pick_change_wins += 1
      end
    end

    # update door image
    self.update_image()

    # update displayed statistics
    self.unchanged_wins_txt.delete(1.0, "end")
    self.unchanged_wins_txt.insert(1.0, "Unchanged wins = #{self.first_choice_wins}")

    self.changed_wins_txt.delete(1.0, "end")
    self.changed_wins_txt.insert(1.0, "Changed wins = #{self.pick_change_wins}")

    # turn off yes/no buttons and clear door choice buttons
    self.yes['state'] = 'disabled'
    self.no['state'] = 'disabled'
    self.door_choice.set_string(nil)

    # close doors 2 seconds after opening
    self.img_file = "images/all_closed.png"
    self.parent.after(2000, self.method(:update_image))
  end
end


root = TkRoot.new { title("Monty Hall Problem") }
# set up root window & run event loop
root['geometry'] = '1280x820' # pics are 1280 x 720

game = Game.new(root)
game.create_widgets!

root.mainloop()