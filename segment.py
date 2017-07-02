import cv2
import numpy as np
import matplotlib.pyplot as plt
import math
import copy


def segment(file_path, L, threshold=60, tail_length=14, play=False, plot=False):
    def QOM(frame, first_frame):
        tmp = np.abs(frame - first_frame)> threshold
        return float(np.sum(tmp))

    def search(bc, s, e):
        dummy_bc = copy.copy(bc)
        min_QOM = 1
        min_iterm = -1
        for item in dummy_bc:
            if s <= item <= e:
                if QOMs[item] < min_QOM:
                    min_iterm = item
                    min_QOM = QOMs[item]
                bc.remove(item)
        if min_iterm != -1:
            bc.append(min_iterm)
        return bc

    cap = cv2.VideoCapture(file_path)
    if not cap.isOpened():
        print "Fail to read video from: %s" % file_path
        return False
    if play:
        fps = cap.get(cv2.cv.CV_CAP_PROP_FPS)
    n_frames = int(cap.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))
    ret, frame = cap.read()
    first_frame = frame[:, :, 1]
    QOMs = []
    while ret:
        if play:
            cv2.imshow(file_path, frame)
            if math.isnan(fps):
                fps = 25.
            cv2.waitKey(1 * int(round(1000/fps)))
        frame = frame[:, :, 1]
        QOMs.append(QOM(frame, first_frame))
        ret, frame = cap.read()
    QOMs = np.array(QOMs)
    QOMs = QOMs / QOMs.max()
    if plot:
        plt.plot(QOMs)
    # print QOMs
    # head_QOM
    base_QOM = []
    base_QOM.extend(QOMs[0:4].tolist())
    base_QOM.extend(QOMs[n_frames - L/tail_length:].tolist())
    base_QOM = np.array(base_QOM)

    interThreshold = base_QOM.mean() + base_QOM.std() * 2
    Boundary_candidates = []
    f_idx = 0
    for x in QOMs:
        if x <= interThreshold:
            Boundary_candidates.append(f_idx)
        f_idx += 1
    window_size = int(math.ceil(L/4))
    if window_size >= n_frames:
        window_size = n_frames / 2
    for s_at in range(n_frames - window_size):
        e_at = s_at + window_size
        search(Boundary_candidates, s_at, e_at)
    if plot:
        y = np.zeros(len(Boundary_candidates)) + 0.025
        plt.plot(Boundary_candidates, y, 'o', color="red")
        plt.show()
    cap.release()
    cv2.destroyAllWindows()
    bc = list((np.array(Boundary_candidates) + 1).tolist())
    bc.sort()
    bc.remove(bc[0])
    if len(bc) > 0:
        bc.remove(bc[-1])
    start = 1
    end_ = n_frames
    seg_at = []
    for f in bc:
        seg_at.append((start, f))
        start = f + 1
    seg_at.append((start, end_))
    return seg_at
