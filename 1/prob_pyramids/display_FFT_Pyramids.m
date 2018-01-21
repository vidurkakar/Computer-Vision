function display_FFT_Pyramids(G, L);
GL = [G L];
N = length(GL) ;
for j=1:(((N+1)*2))-1
GL_fft{j} = log(abs(fftshift(fft2(GL{j}))));
subplot(2,(N+1) / 2,j),imagesc(GL_fft{j});
end
end

