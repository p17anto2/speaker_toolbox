#!/usr/bin/env -S /bin/octave -qf --persist

close all; clear all;

pkg load parallel

function p = project()
    p.file = "";
    p.orig_data = [];
    p.data = [];
    p.peak = 0;
    p.FS = 0;
    p.volume = 1;
endfunction

function file_chooser_test(handle, evt) 
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
  [h.project.orig_data, h.project.FS] = audioread(h.project.file);
  h.project.data = h.project.orig_data;
  h.project.peak = max(fft(h.project.data));
  disp(h.project.peak);
  h.player = audioplayer(h.project.data, h.project.FS);
  guidata(gcf, h);
  update_plot();
end

function update_plot()
  h = guidata(gcf);
  plot((1:size(h.project.data)(:, 1))/h.project.FS, h.project.data);
  guidata(gcf, h);
end

# function player_play()
#   h = guidata(gcf);
#   samples = 4096;
#   fragments = size(h.project.data)(:, 1) / samples;
#   remainder = rem(size(h.project.data)(:, 1), samples);
#   for i = 1:fragments
#     h = guidata(gcf);
#     if i < floor(fragments)
#       player = audioplayer(h.project.data(i*samples:i*samples+samples) * h.project.volume, h.project.FS,8,7);
#     else
#       player = audioplayer(h.project.data(i*samples:i*samples+remainder) * h.project.volume, h.project.FS,8,7);
#     end
#     playblocking(player);
#     drawnow()
#   end
# end

function player_play()
  h = guidata(gcf);
  samples = 4096;
  fragments = size(h.project.data)(:, 1) / samples;
  remainder = rem(size(h.project.data)(:, 1), samples);
  for i = 1:fragments
    if i < floor(fragments)
      data = h.project.data(i * samples: i * samples + samples);
    else
      data = h.project.data(i*samples:i*samples+remainder);
    end
    drawnow();
    proc_data = audio(data);
    player = audioplayer(proc_data, h.project.FS, 8, 7);
    playblocking(player);
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
       "label", "Open (Test)",
       "callback", @file_chooser_test);
                        
window.editor = uipanel("position", [0 .35 1 .65],
                        "backgroundcolor", "black");

window.editor_lvfm = uipanel(window.editor,
                             "units", "normalized",
                             "position", [0 .5 .33 .5]);

window.editor_lvfm_threshold = uicontrol(window.editor_lvfm,
                                         "units", "normalized",
                                         "interruptible", "off",
                                         "style", "slider",
                                         "position", [0 .5 1 .5],
                                         "value", 0,
                                         # "callback", @audio,
                                         "string", "Threshold");

window.editor_lvfm_volume = uicontrol(window.editor_lvfm,
                                      "units", "normalized",
                                      "interruptible", "off",
                                      "style", "slider",
                                      "position", [0 0 1 .5],
                                      "value", 1,
                                      # "callback", @audio,
                                      "string", "Volume");

window.editor_volume = uicontrol(window.editor,
                                 "interruptible", "off",
                                 "style", "slider",
                                 "horizontalalignment", "left",
                                 "position", [0 0 100 30],
                                 "value", 1,
                                 # "callback", @audio,
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
