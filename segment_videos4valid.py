import segment
import os

video_root_dir = 'DATA/ConGD_phase1/valid'
with open('DATA/con_list/valid.txt') as input:
    valid_list = input.readlines()
output = open('valid_segmented.list', 'w')

for line in valid_list:
    video_path = os.path.join(video_root_dir, line[:-1] + '.K.avi')
    try:
        ret = segment.segment(video_path, L=92, threshold=50, tail_length=8, play=False, plot=False)
    except:
        ret = False
    if ret:
        s = '%s' % line[:-1]
        for fragment in ret:
            s += ' %d,%d:0' % fragment
        print s
        output.write(s + '\n')
    else:
        s = '%s %d error' % (line[:-1], 0)
        print s
        raise Exception
