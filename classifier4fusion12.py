import numpy as np
import sys
import os
from skimage import io;
io.use_plugin('matplotlib')
from sklearn.preprocessing import normalize
#import matplotlib.pyplot as plt

# Make sure that caffe is on the python path:
caffe_root = '/home/huogen/git/caffe/'  # this file is expected to be in {caffe_root}/examples
import sys
sys.path.insert(0,caffe_root+'python')
import caffe
GPU_ID = 0 # Switch between 0 and 1 depending on the GPU you want to use.
caffe.set_mode_gpu()
caffe.set_device(GPU_ID)

IMAGENET1 = 'caffe4IsoGD/depth_dif_full/'
MODEL_FILE1 = IMAGENET1 + 'deploy-resnet50.prototxt'
PRETRAINED1 = IMAGENET1 + 'Depth_dif_full_train_vgg_iter_90000.caffemodel'
Depth4valid1 = 'DI4caffe/test/test_DepthDIf_full/'

IMAGENET2 = 'caffe4IsoGD/depth_dir_full/'
MODEL_FILE2 = IMAGENET2 + 'deploy-resnet50.prototxt'
PRETRAINED2 = IMAGENET2 + 'Depth_dir_full_train_vgg_iter_90000.caffemodel'
RGB4valid1 = 'DI4caffe/test/test_DepthDIr_full/'

IMAGENET3 = 'caffe4IsoGD/depth_dif_fullbody/'
MODEL_FILE3 = IMAGENET3 + 'deploy-resnet50.prototxt'
PRETRAINED3 = IMAGENET3 + 'Depth_dif_fullbody_train_vgg_iter_90000.caffemodel'
Depth4valid2 = 'DI4caffe/test/test_DepthFullbodyDif/'

IMAGENET4 =  'caffe4IsoGD/depth_dir_fullbody/'
MODEL_FILE4 = IMAGENET4 + 'deploy-resnet50.prototxt'
PRETRAINED4 = IMAGENET4 + 'Depth_dir_fullbody_train_vgg_iter_90000.caffemodel'
RGB4valid2 =  'caffe4IsoGD/DI4caffe/test/test_DepthFullbodyDir/'

IMAGENET5 = 'caffe4IsoGD/Rgb_dif_full/'
MODEL_FILE5 = IMAGENET5 + 'deploy-resnet50.prototxt'
PRETRAINED5 = IMAGENET5 + 'Rgb_dif_full_train_vgg_iter_90000.caffemodel'
Depth4valid3 = 'DI4caffe/test/test_RgbDIf_full/'

IMAGENET6 = 'caffe4IsoGD/Rgb_dir_full/'
MODEL_FILE6 = IMAGENET6 + 'deploy-resnet50.prototxt'
PRETRAINED6 = IMAGENET6 + 'Rgb_dir_full_train_vgg_iter_90000.caffemodel'
RGB4valid3 = 'DI4caffe/test/test_RgbDIr_full/'

IMAGENET7 = 'caffe4IsoGD/Rgb_dif_fullbody/'
MODEL_FILE7 = IMAGENET7 + 'deploy-resnet50.prototxt'
PRETRAINED7 = IMAGENET7 + 'Rgb_dif_fullbody_train_vgg_iter_90000.caffemodel'
Depth4valid4 = 'DI4caffe/test/test_RGBFullbodyDif/'

IMAGENET8 = 'caffe4IsoGD/Rgb_dir_fullbody/'
MODEL_FILE8 = IMAGENET8 + 'deploy-resnet50.prototxt'
PRETRAINED8 = IMAGENET8 + 'Rgb_dir_fullbody_train_vgg_iter_90000.caffemodel'
RGB4valid4 = 'DI4caffe/test/test_RGBFullbodyDir/'

subfolders1 = os.listdir(Depth4valid1)
num4subfolders1 = len(subfolders1)
TestFileNames1 = []
for n in xrange(num4subfolders1):
    rightname = Depth4valid1+subfolders1[n]
    TestFileNames1.append(rightname)
    TestFileNames1.sort()

subfolders2 = os.listdir(RGB4valid1)
num4subfolders2 = len(subfolders2)
TestFileNames2 = []
for n in xrange(num4subfolders2):
     rightname = RGB4valid1+subfolders2[n]
     TestFileNames2.append(rightname)
     TestFileNames2.sort()

subfolders3 = os.listdir(Depth4valid2)
num4subfolders3 = len(subfolders3)
TestFileNames3 = []
for n in xrange(num4subfolders3):
     rightname = Depth4valid2+subfolders3[n]
     TestFileNames3.append(rightname)
     TestFileNames3.sort()

subfolders4 = os.listdir(RGB4valid2)
num4subfolders4 = len(subfolders4)
TestFileNames4 = []
for n in xrange(num4subfolders4):
     rightname = RGB4valid2+subfolders4[n]
     TestFileNames4.append(rightname)
     TestFileNames4.sort()

subfolders5 = os.listdir(Depth4valid3)
num4subfolders5 = len(subfolders5)
TestFileNames5 = []
for n in xrange(num4subfolders5):
     rightname = Depth4valid3+subfolders5[n]
     TestFileNames5.append(rightname)
     TestFileNames5.sort()

subfolders6 = os.listdir(RGB4valid3)
num4subfolders6 = len(subfolders6)
TestFileNames6 = []
for n in xrange(num4subfolders6):    
     rightname = RGB4valid3+subfolders6[n]
     TestFileNames6.append(rightname)
     TestFileNames6.sort()

subfolders7 = os.listdir(Depth4valid4)
num4subfolders7 = len(subfolders7)
TestFileNames7 = []
for n in xrange(num4subfolders7):
     rightname = Depth4valid4+subfolders7[n]
     TestFileNames7.append(rightname)
     TestFileNames7.sort()

subfolders8 = os.listdir(RGB4valid4)
num4subfolders8 = len(subfolders8)
TestFileNames8 = []
for n in xrange(num4subfolders8):    
      rightname = RGB4valid4+subfolders8[n]
      TestFileNames8.append(rightname)
      TestFileNames8.sort()

net1 = caffe.Net(MODEL_FILE1, PRETRAINED1,caffe.TEST)
net2 = caffe.Net(MODEL_FILE2, PRETRAINED2,caffe.TEST)
net3 = caffe.Net(MODEL_FILE3, PRETRAINED3,caffe.TEST)
net4 = caffe.Net(MODEL_FILE4, PRETRAINED4,caffe.TEST)
net5 = caffe.Net(MODEL_FILE5, PRETRAINED5,caffe.TEST)
net6 = caffe.Net(MODEL_FILE6, PRETRAINED6,caffe.TEST)
net7 = caffe.Net(MODEL_FILE7, PRETRAINED7,caffe.TEST)
net8 = caffe.Net(MODEL_FILE8, PRETRAINED8,caffe.TEST)

mu1 = np.load(IMAGENET1 + 'DepthFull_dif_mean_vgg.npy')
mu1 = mu1.mean(1).mean(1)

transformer1 = caffe.io.Transformer({'data':net1.blobs['data'].data.shape})
transformer1.set_transpose('data',(2,0,1))
transformer1.set_mean('data',mu1)
transformer1.set_raw_scale('data',255)
transformer1.set_channel_swap('data',(2,1,0))

net1.blobs['data'].reshape(1,
                          3,
                          224,224)

mu2 = np.load(IMAGENET2 + 'DepthFull_dir_mean_vgg.npy')
mu2 = mu2.mean(1).mean(1)

transformer2 = caffe.io.Transformer({'data':net2.blobs['data'].data.shape})
transformer2.set_transpose('data',(2,0,1))
transformer2.set_mean('data',mu2)
transformer2.set_raw_scale('data',255)
transformer2.set_channel_swap('data',(2,1,0))

net2.blobs['data'].reshape(1,
                          3,
                          224,224)

mu3 = np.load(IMAGENET3 + 'DepthFullbody_dif_mean_vgg.npy')
mu3 = mu3.mean(1).mean(1)

transformer3 = caffe.io.Transformer({'data':net3.blobs['data'].data.shape})
transformer3.set_transpose('data',(2,0,1))
transformer3.set_mean('data',mu3)
transformer3.set_raw_scale('data',255)
transformer3.set_channel_swap('data',(2,1,0))

net3.blobs['data'].reshape(1,
                          3,
                          224,224)

mu4 = np.load(IMAGENET4 + 'DepthFullbody_dir_mean_vgg.npy')
mu4 = mu4.mean(1).mean(1)

transformer4 = caffe.io.Transformer({'data':net4.blobs['data'].data.shape})
transformer4.set_transpose('data',(2,0,1))
transformer4.set_mean('data',mu4)
transformer4.set_raw_scale('data',255)
transformer4.set_channel_swap('data',(2,1,0))

net4.blobs['data'].reshape(1,
                          3,
                          224,224)

mu5 = np.load(IMAGENET5 + 'RgbFull_dif_mean_vgg.npy')
mu5 = mu5.mean(1).mean(1)

transformer5 = caffe.io.Transformer({'data':net5.blobs['data'].data.shape})
transformer5.set_transpose('data',(2,0,1))
transformer5.set_mean('data',mu5)
transformer5.set_raw_scale('data',255)
transformer5.set_channel_swap('data',(2,1,0))

net5.blobs['data'].reshape(1,
                          3,
                          224,224)

mu6 = np.load(IMAGENET6 + 'RgbFull_dir_mean_vgg.npy')
mu6 = mu6.mean(1).mean(1)

transformer6 = caffe.io.Transformer({'data':net6.blobs['data'].data.shape})
transformer6.set_transpose('data',(2,0,1))
transformer6.set_mean('data',mu6)
transformer6.set_raw_scale('data',255)
transformer6.set_channel_swap('data',(2,1,0))

net6.blobs['data'].reshape(1,
                          3,
                          224,224)

mu7 = np.load(IMAGENET7 + 'RgbFullbody_dif_mean_vgg.npy')
mu7 = mu7.mean(1).mean(1)

transformer7 = caffe.io.Transformer({'data':net7.blobs['data'].data.shape})
transformer7.set_transpose('data',(2,0,1))
transformer7.set_mean('data',mu7)
transformer7.set_raw_scale('data',255)
transformer7.set_channel_swap('data',(2,1,0))

net7.blobs['data'].reshape(1,
                          3,
                          224,224)

mu8 = np.load(IMAGENET8 + 'RgbFullbody_dir_mean_vgg.npy')
mu8 = mu8.mean(1).mean(1)

transformer8 = caffe.io.Transformer({'data':net8.blobs['data'].data.shape})
transformer8.set_transpose('data',(2,0,1))
transformer8.set_mean('data',mu8)
transformer8.set_raw_scale('data',255)
transformer8.set_channel_swap('data',(2,1,0))

net8.blobs['data'].reshape(1,
                          3,
                          224,224)


file_object1 = open('test_p.txt','w')

for IMAGE_FILE1, IMAGE_FILE2, IMAGE_FILE3, IMAGE_FILE4,IMAGE_FILE5, IMAGE_FILE6, IMAGE_FILE7, IMAGE_FILE8 in zip(TestFileNames1,TestFileNames2,TestFileNames3,TestFileNames4,TestFileNames5,TestFileNames6,TestFileNames7,TestFileNames8):
    if len(IMAGE_FILE1) == 0:
        continue
    if len(IMAGE_FILE2) == 0:
        continue
    if len(IMAGE_FILE3) == 0:
        continue
    if len(IMAGE_FILE4) == 0:
        continue
    if len(IMAGE_FILE5) == 0:
        continue
    if len(IMAGE_FILE6) == 0:
        continue
    if len(IMAGE_FILE7) == 0:
        continue
    if len(IMAGE_FILE8) == 0:
        continue

    input_image1 = caffe.io.load_image(IMAGE_FILE1)
    transformed_image1 = transformer1.preprocess('data',input_image1)
    net1.blobs['data'].data[...] = transformed_image1
    output1= net1.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob1 = output1['prob']

    input_image2 = caffe.io.load_image(IMAGE_FILE2)
    transformed_image2 = transformer2.preprocess('data',input_image2)
    net2.blobs['data'].data[...] = transformed_image2
    output2= net2.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob2 = output2['prob']

    input_image3 = caffe.io.load_image(IMAGE_FILE3)
    transformed_image3 = transformer3.preprocess('data',input_image3)
    net3.blobs['data'].data[...] = transformed_image3
    output3= net3.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob3 = output3['prob']

    input_image4 = caffe.io.load_image(IMAGE_FILE4)
    transformed_image4 = transformer4.preprocess('data',input_image4)
    net4.blobs['data'].data[...] = transformed_image4
    output4= net4.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob4 = output4['prob']

    input_image5 = caffe.io.load_image(IMAGE_FILE5)
    transformed_image5 = transformer5.preprocess('data',input_image5)
    net5.blobs['data'].data[...] = transformed_image5
    output5= net5.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob5 = output5['prob']

    input_image6 = caffe.io.load_image(IMAGE_FILE6)
    transformed_image6 = transformer6.preprocess('data',input_image6)
    net6.blobs['data'].data[...] = transformed_image6
    output6= net6.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob6 = output6['prob']

    input_image7 = caffe.io.load_image(IMAGE_FILE7)
    transformed_image7 = transformer7.preprocess('data',input_image7)
    net7.blobs['data'].data[...] = transformed_image7
    output7= net7.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob7 = output7['prob']

    input_image8 = caffe.io.load_image(IMAGE_FILE8)
    transformed_image8 = transformer8.preprocess('data',input_image8)
    net8.blobs['data'].data[...] = transformed_image8
    output8= net8.forward() # predict takes any number of images, and formats them for the Caffe net automatically
    output_prob8 = output8['prob']

    output_prob9 = np.load('LSTM/test_rgb_fullbody_predict/'+IMAGE_FILE5[-11:-4]+'.npy')
    output_prob10 = np.load('LSTM/test_depth_fullbody_predict/'+IMAGE_FILE1[-11:-4]+'.npy')
    output_prob11 = np.load('LSTM/test_rgb_full_predict/'+IMAGE_FILE5[-11:-4]+'.npy')
    output_prob12 = np.load('LSTM/test_depth_fullbody_predict/'+IMAGE_FILE1[-11:-4]+'.npy')

    output_prob_ava = normalize((output_prob1+output_prob2+output_prob3+output_prob4+0.7*output_prob5+0.7*output_prob6+0.7*output_prob7+0.7*output_prob8),axis=1, norm='l1')+normalize((output_prob9+output_prob10+0.6*output_prob11 + output_prob12),axis=1, norm='l1')



    tem1 = output_prob_ava.argmax()+1


    print tem1

    strall = str(tem1)+'\n'
    file_object1.write(strall)
    



file_object1.close()
print 'Done.'
