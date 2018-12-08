# segment_files.praat
# Ricardo A. H. Bion, 02/05/2009

form SEGMENT FILES
	sentence File_to_read_from: /Users/ricardoh/Desktop/example/Anne
	sentence Directory_to_save_segmented_files: /Users/ricardoh/Desktop/example/segmented/
endform

select all
nocheck Remove

sound = Read from file... 'file_to_read_from$'
text = To TextGrid (silences)...  100 0  -40 0.4 0.1 silent sounding
select all
Extract intervals where... 1 no "is equal to" sounding
select text
plus sound
Remove

select all
numberOfSounds = numberOfSelected()

for i to numberOfSounds
	sound_'i' = selected("Sound", 'i')
endfor

for i to numberOfSounds
	select sound_'i'
	Write to AIFF file... 'directory_to_save_segmented_files$''i'.aiff
endfor

select all
Remove