function audio()
  h = guidata(gcf);
  fft_data = fft(h.project.orig_data);
  # Audio pipeline
  h = low_volume_frequency_removal(h, fft_data);
  h = finalise(h, fft_data);
  h = set_volume(h);
  guidata(gcf, h);
  update_plot();
end

# TODO: Try it by calling it from player_play

function h = low_volume_frequency_removal(h, fft_data)
  threshold = h.project.peak * get(h.editor_lvfm_threshold, "value");
  vol = get(h.editor_lvfm_volume, "value");
  for i = 1:size(fft_data)(:, 1)
    if fft_data(i) < threshold
      h.project.data(i) = h.project.orig_data(i) * vol;
    end
  end
end

function h = finalise(h, fft_data)
  h.project.data = ifft(fft_data);
end

function h = set_volume(h)
  h.project.volume = get(h.editor_volume, "value");
end
