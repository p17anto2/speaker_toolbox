# function audio(data)
#   h = guidata(gcf);
#   fft_data = fft(h.project.orig_data);
#   # Audio pipeline
#   h = low_volume_frequency_removal(h, fft_data);
#   h = finalise(h, fft_data);
#   h = set_volume(h);
#   guidata(gcf, h);
#   update_plot();
# end

function data = audio(data)
  h = guidata(gcf);
  fft_data = fft(data);
  data = low_volume_frequency_removal(h, data, fft_data);
  data = ifft(fft_data);
  data = data * get(h.editor_volume, "value");
end

# TODO: Try it by calling it from player_play

function data = low_volume_frequency_removal(h, data, fft_data)
  threshold = h.project.peak * get(h.editor_lvfm_threshold, "value");
  vol = get(h.editor_lvfm_volume, "value");
  pararrayfun(nproc - 1, @(data, fft_data) data - data.*((real(fft_data)>threshold)*vol), data);
  # for i = 1:size(fft_data)(:, 1)
  #   if real(fft_data(i)) < threshold
  #     data(i) = data(i) * vol;
  #   end
  #   pararrayfun(nproc - 1, @
  # end
end
