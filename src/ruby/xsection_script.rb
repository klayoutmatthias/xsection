#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

module XS

  # ----------------------------------------------------------------
  # The cross section script environment
  
  class XSectionScriptEnvironment
  
    def initialize
  
      app = RBA::Application.instance
      mw = app.main_window
      mw || return
  
      @action = RBA::Action.new
      @action.title = "XSection Script"
      @action.on_triggered do
  
        view = RBA::Application.instance.main_window.current_view
        if !view
          raise "No view open for running the xsection script on"
        end
          
        fn = RBA::FileDialog::get_open_file_name("Select Script", "", "XSection Scripts (*.xs);;All Files (*)");
        if fn.has_value?
          run_script(fn.value)
          make_mru(fn.value)
        end
  
      end
  
      @active_tech = RBA::Action.new
      @active_tech.title = "XSection: Active Technolgy"
      @active_tech.shortcut = "Ctrl+Shift+X"
      @active_tech.on_triggered do
  
        view = RBA::Application.instance.main_window.current_view
        if !view
          raise "No view open for running the xsection script on"
        end
        tech_name = view.active_cellview.technology
        tech = RBA::Technology.technology_by_name(tech_name)
        xsect_dir = File.join(tech.base_path, 'xsect')
        unless File.exist?(xsect_dir)
          raise "No Xsection directory present for #{tech_name}"
        end
        xsect_fileglob = File.join(xsect_dir, '*.xs')
  
        files = []
        Dir.glob(xsect_fileglob) do |xs_file|
          files << xs_file.to_s
        end
        if files.length < 1
          raise "No XSection file found for technology #{tech_name}."
        elsif files.length > 1
          raise "More than one .xs file found for technology #{tech_name}. Found #{files.length}"
        else
          xs_file = files[0]
          run_script(xs_file)
        end
  
      end
  
      menu = mw.menu
      menu.insert_separator("tools_menu.end", "xsection_script_group")
      menu.insert_menu("tools_menu.end", "xsection_script_submenu", "XSection Scripts")
      menu.insert_item("tools_menu.xsection_script_submenu.end", "xsection_script_load", @action)
      menu.insert_item("tools_menu.xsection_script_submenu.end", "xsection_for_technology", @active_tech)
      menu.insert_separator("tools_menu.xsection_script_submenu.end.end", "xsection_script_mru_group")
  
      @mru_actions = []
      (1..4).each do |i|
  
        a = XSectionMRUAction.new do |action|
          run_script(action.script)
          make_mru(action.script)
        end
  
        @mru_actions.push(a)
        menu.insert_item("tools_menu.xsection_script_submenu.end", "xsection_script_mru#{i}", a)
  
        a.script = nil
  
      end
  
      # try to save the MRU list to $HOME/.klayout-processing-mru
      i = 0
      home = ENV["HOME"]
      if $xsection_scripts
        $xsection_scripts.split(":").each_with_index do |script,i|
          if i < @mru_actions.size
            @mru_actions[i].script = script
          end
        end
      elsif home
        fn = File.join(home, ".klayout-xsection")
        begin
          File.open(fn, "r") do |file|
            file.readlines.each do |line|
              if line =~ /<mru>(.*)<\/mru>/
                if i < @mru_actions.size
                  @mru_actions[i].script = $1
                end
                i += 1
              end
            end
          end
        rescue
        end
  
      end
  
    end
  
    def run_script(fn, p1 = nil, p2 = nil)
  
      begin
  
        if !p1 || !p2
  
          # locate the layout and the (single) ruler
          app = RBA::Application.instance
          view = app.main_window.current_view
          if !view
            raise("No view open for creating the cross section from")
            return
          end
  
          ruler = nil
          nrulers = 0
          view.each_annotation do |a|
            ruler = a
            nrulers += 1
          end
  
          if nrulers == 0
            raise("No ruler present for the cross section line")
          end
          if nrulers > 1
            raise("More than one ruler present for the cross section line")
          end
  
          p1 = ruler.p1
          p2 = ruler.p2
  
        end
  
        XSectionGenerator.new(fn).run(p1, p2)
  
      # Without this rescue block stack traces are shown (for development)
      rescue => ex
        
        if $xs_run || $xs_debug
          raise ex
        else
  
          # Extract the error location in the script.
          # The backtrace line is something like "(filename).xs:(line):in ...".
  
          location = "(not found)"
          ex.backtrace.each do |bt|
            if !bt.to_s.start_with?(File.dirname(__FILE__))
              location = bt.sub(/:in .*$/, "")
              break
            end
          end
  
          RBA::MessageBox.critical("Error", ex.to_s + "\nin " + location, RBA::MessageBox.b_ok)
          nil
  
        end
  
      end
  
    end
  
    def make_mru(script)
  
      # don't maintain MRU if an external list is provided
      if $xsection_scripts
        return
      end
  
      scripts = [script]
      @mru_actions.each do |a|
        if a.script != script
          scripts.push(a.script)
        end
      end
  
      while scripts.size < @mru_actions.size
        scripts.push(nil)
      end
  
      (0..(@mru_actions.size-1)).each do |i|
        @mru_actions[i].script = scripts[i]
      end
  
      # try to save the MRU list to $HOME/.klayout-xsection
      home = ENV["HOME"]
      if home
        fn = File.join(home, ".klayout-xsection")
        File.open(fn, "w") do |file|
          file.puts("<xsection>");
          @mru_actions.each do |a|
            if a.script
              file.puts("<mru>#{a.script}</mru>")
            end
          end
          file.puts("</xsection>");
        end
  
      end
  
    end
  
  end
  
end