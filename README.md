# Robot-Jam-Sesh
Tempo detection and time-shifting in MATLAB

Read accompanying post [here.](https://avivgoldgeier.com/#!/projects/robot-jam-sesh)

Sadly, this repo contains no audio nor links to audio, as I totally don't have the rights to share the audio I personally used to test the code.

## matlab_superjam.m
This is the main file - put some loops in a directory called loops/, alter lines 24-32 accordingly, and it should be ready to work its magic! First choose a head loop, and it will automatically find its tempo and align and mix in the remaining loops.

## eval_method.m
Compares vanilla autocorrelation with my variant. You must provide your own dataset of loops and put them in a directory test_loops/. Depending on how the files in the dataset are named, you may have to rewrite get_tempo.m
