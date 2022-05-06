#!/bin/octave --persist

close all; clear all;

graphics_toolkit qt

function p = project()
    p.file = "";
    p.data = [];
    p.FS = 0;
    p.volume = 1;
endfunction

function file_chooser(handle, evt) 
  #TODO: Add exceptions 
  #FIXME: uigetfile returns current directory, not target
  
  # dirname = uigetdir();
  # fname = uigetfile("*.wav",
  #                    dirname);
  # fname = uigetfile("../joe.wav",
  #                   "Choose File",
  #                   "/media/data/Documents/Projects/speaker_toolbox/");

  # project.file = (fullfile(dirname, fname));
  #
  h = guidata(gcf);
  h.project.file = "/media/data/Documents/Projects/speaker_toolbox/joe.wav";
  [h.project.data, h.project.FS] = audioread(h.project.file);
  h.player = audioplayer(h.project.data, h.project.FS);
  guidata(gcf, h);
  update_plot();
end

function update_plot()
  h = guidata(gcf);
  plot((1:size(h.project.data)(:, 1))/h.project.FS, h.project.data);
  guidata(gcf, h);
end

function set_volume()
  h = guidata(gcf);
  h.project.volume = get(h.editor_volume, "value");
  guidata(gcf, h);
end

function player_play()
  h = guidata(gcf);
  samples = 4096;
  fragments = size(h.project.data)(:, 1) / samples;
  remainder = rem(size(h.project.data)(:, 1), samples);
  for i = 1:fragments
    h = guidata(gcf);
    if i < floor(fragments)
      player = audioplayer(h.project.data(i*samples:i*samples+samples) * h.project.volume, h.project.FS,8,7);
    else
      player = audioplayer(h.project.data(i*samples:i*samples+remainder) * h.project.volume, h.project.FS,8,7);
    end;
    playblocking(player);
    drawnow()
  end
end

function terminate()
  # FIXME: Throws a seg fault
  clear gcf;
  clear all;
  closereq();
  close all;
  exit(0);
end

# --- Main ---

window.project = project();

window.main = figure("graphicssmoothing", "on",
                     "menubar", "none",
                     "numbertitle", "off",
                     "closerequestfcn", "terminate",
                     "name", "Speaker Toolbox");

window.file_menu = uimenu(window.main,
                          "label", "File");

uimenu(window.file_menu,
       "label", "Open",
       "callback", @file_chooser);
                        
window.editor = uipanel("position", [0 .35 1 .65],
                        "backgroundcolor", "black");

window.editor_volume = uicontrol(window.editor,
                                 # "units", "normalized",
                                 "interruptible", "off",
                                 "style", "slider",
                                 "horizontalalignment", "left",
                                 "position", [0 0 100 30],
                                 "value", 0.4,
                                 "callback", @set_volume,
                                 "string", "volume");
                                 
window.control = uibuttongroup("position", [0 .25 1 .10]);

window.control_play = uicontrol(window.control,
                                "busyaction", "queue",
                                "style", "pushbutton",
                                "position", [0 0 25 25],
                                "callback", @player_play,
                                "string", "▶");

window.axes = axes("position", [0 0 1 .25]);

guidata (gcf, window);
