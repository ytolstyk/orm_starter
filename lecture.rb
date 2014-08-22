class Crow
  def set_black_wind_thrusters(pct)
    puts "setting black_wind thrusters to #{pct}%"
    @black_wind_thrusters = pct
  end

  def fire_talon_cannon
    puts "caw caw caw goes the talon cannon"
  end

  def store_in_egg_shell_bay(stuff)
    @egg_shell_bay = stuff
  end

  def store_in_nest_bay(stuff)
    @nest_bay = stuff
  end

  def inventory
    [@egg_shell_bay, @nest_bay]
  end

  def unload_cargo
    items = inventory
    @egg_shell_bay, @nest_bay = nil, nil
    items
  end

  def self.motto
    puts "caw caw kick your ass"
  end
end



class SpaceBase

  def self.build_thrusters(thruster_name) #class
    define_method "set_thruster_#{thruster_name}" do |pct| #class
      puts "setting thruster #{thruster_name} to #{pct}%" #instance
      instance_variable_set("@thruster_#{thruster_name}", pct) #instance
    end
  end

  def self.construct_cannons(cannon, sound)
    define_method "fire_#{canonn}_cannon" do #class
      puts "#{sound * 3} goes the #{cannon}" #instance
    end
  end

  def self.build_bays(*names) #class
    names.each do |name| #class
      define_method "store_in_#{name}_bay" do |item| #class
        instance_variable_set("@#{name}_bay", item) #instance
      end
    end
    define_method(:inventory) do
      names.map do |name|
        instance_variable_get("@#{name}_bay")
      end
    end

    # don't dwell on this - example, is all
    define_method :get_2nd_item do |name|
      val = instance_variable_get("@#{name}_bay")
      val[1]
    end
    # -------------

    define_method(:unload_items) do #class
      items = inventory #instance
      names.each do |name| #instance
        instance_variable_set("@#{name}_bay", nil) #instance
      end #instance
      items #instance
    end
  end

  def self.motto
    puts @motto #class
  end
end



class Condor < SpaceBase
  @motto = "he or she who dates, wins" #class
  build_thrusters :silver_wind #class
  construct_cannons "death_beak", "gneaw " #class
  build_bays(:false_bay, :stomach, :aft) #class
end