from scipy.spatial import distance
import math
import numpy as np
from nd2reader import ND2Reader
import trackpy as tp
import pandas as pd
from skimage.morphology import white_tophat, black_tophat, disk

def func_distance_2d(x_1, y_1, x_2, y_2):  # all are values
    dis = distance.euclidean((x_1, y_1), (x_2, y_2))
    
    return dis

#def func_dis_min_2d(a, b, c, d):  # a and b are values, c, d are list or df
#    dis_spot = []
#    for x, y in zip(c, d):
#        dis = distance.euclidean((a, b), (x, y))
#        dis_spot.append(dis)
#    aa = dis_spot.index(min(dis_spot)) #index
#    bb = min(dis_spot) #distance
#    
#    return aa, bb


def func_dis_min_2d(a, b, c, d):  # a and b are values, c, d are list or df
    dis_spot = []
    a = float(a.values)
    b = float(b.values)
    c = c.values
    d = d.values\
    #print (a, b, c, d)
    for x, y in zip(c, d):
        dis = distance.euclidean([a, b], [float(x), float(y)])
        dis_spot.append(dis)
    aa = dis_spot.index(min(dis_spot)) #index
    bb = min(dis_spot) #distance
    
    return aa, bb

def func_intensity(yx, target_image):
    mean_value = target_image.mean()
    df = pd.DataFrame()
    pad_width = radius_refinement = 3
    y, x = yx.T.copy()
    yx = yx + pad_width
    target_image = np.pad(
        target_image, pad_width=pad_width, mode='constant', constant_values=0
    )

    df_curr = tp.refine_com(
        raw_image=target_image, image=target_image, radius=radius_refinement, coords=yx
    )

    df_curr["x"] = x
    df_curr["y"] = y

    df = df.append(df_curr, ignore_index=True)
    df['mean_back_int'] = mean_value
    df['mean_mass'] = df['mass'] / (3 * 3 * math.pi)
    df['r_mass'] = df['mean_mass'] / df['mean_back_int']

    return df

def func_read_noFOV(path, iter, col):
    img = ND2Reader(path)
    img.bundle_axes = 'yx'
    img.iter_axes = iter
    img.default_coords['c'] = col
    
    return img

def func_roi_to_df(roi):
    df_anno = pd.DataFrame()
    for name, ROI in roi.items():
        df_roi = pd.DataFrame(data =[[ROI['y'][0],ROI['x'][0]]], columns = ['y', 'x'])
        df_anno = pd.concat([df_anno, df_roi])

    return df_anno

def subtract_background(image, radius=50, light_bg=False):
        str_el = disk(radius) #you can also use 'ball' here to get a slightly smoother result at the cost of increased computing time
        if light_bg:
            return black_tophat(image, str_el)
        else:
            return white_tophat(image, str_el)