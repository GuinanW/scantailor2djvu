#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
import os
import math
import random
import re

sys.path.insert(0, '/opt/opencv/lib/python2.7/dist-packages/')

import cv2
import numpy

print cv2.__version__

FLANN_INDEX_KDTREE = 1
flann_params = dict(algorithm = FLANN_INDEX_KDTREE,
                    trees = 5)
__features__cached__ = {}

def drawKeyPoints(img, template, skp, tkp, num=-1, z=0):
    "Отрисовываем связи между характерными точками для проверки"
    h1, w1 = img.shape[:2]
    h2, w2 = template.shape[:2]
    nWidth = w1+w2
    nHeight = max(h1, h2)
    hdif = (h1-h2)/2
    newimg = numpy.zeros((nHeight, nWidth, 3), numpy.uint8)
    newimg[hdif:hdif+h2, :w2] = cv2.cvtColor( template, cv2.COLOR_GRAY2RGB ) 
    newimg[:h1, w2:w1+w2] = cv2.cvtColor( img, cv2.COLOR_GRAY2RGB ) 

    maxlen = min(len(skp), len(tkp))
    if num < 0 or num > maxlen:
        num = maxlen
    for i in range(num):
        pt_a = (int(tkp[i][0]), int(tkp[i][1]+hdif))
        pt_b = (int(skp[i][0]+w2), int(skp[i][1]))
        cv2.line(newimg, pt_a, pt_b, (random.randint(1,255), random.randint(1,255), random.randint(1,255)))
    cv2.imwrite('/dev/shm/match-%s.png' % (z, ), newimg)
    return newimg

def match_flann(desc1, desc2, r_threshold = 0.6):
    flann = cv2.flann_Index(desc2, flann_params)
    idx2, dist = flann.knnSearch(desc1, 2, params = {}) # bug: need to provide empty dict
    mask = dist[:,0] / dist[:,1] < r_threshold
    idx1 = numpy.arange(len(desc1))
    pairs = numpy.int32( zip(idx1, idx2[:,0]) )
    return pairs[mask]

def get_features(img1):
    "Ищем характерные точки"
    detector = cv2.FeatureDetector_create('SIFT')
    descriptor = cv2.DescriptorExtractor_create('SIFT')

    kp = detector.detect(img1)
    kp, desc = descriptor.compute(img1, kp)
    return (kp, desc)

def get_different(img1, img2):
    kp1, desc1 = get_features(img1)
    kp2, desc2 = get_features(img2)
    return get_homography((kp1, desc1), (kp2, desc2))

def get_homography((kp1, desc1), (kp2, desc2)):
    "Определяем параметры для гомографического преобразования"
    #img1 = template
    r_threshold = 0.6

    print 'img1 - %d features, img2 - %d features' % (len(kp1), len(kp2))

    res = {}
    good_H, good_val = 0,0
    for zi in xrange(20):
        m = match_flann(desc1, desc2, r_threshold)
#       рисуем для дебага точки
#        drawKeyPoints(img1, img2, 
#                      [kp1[i] for i, j in m], 
#                      [kp2[i] for i, j in m], 
#                      z=zi)

        matched_p1 = numpy.array([kp1[i].pt for i, j in m])
        matched_p2 = numpy.array([kp2[j].pt for i, j in m])

        H, status = cv2.findHomography(matched_p1, matched_p2, cv2.RANSAC, 5.0)

        #ищем гомография для большего числа точек
        if (float(numpy.sum(status))/len(status)) > good_val:
            good_H = H
            good_val = float(numpy.sum(status))/len(status)
    print ':3', good_val

    return good_H


def fix_pages(
            img_path, #где ищем
            img_small_path, #что ищем
            out_path, #куда сохраняем
            small_factor = 2, #коэффициент уменьшения изображения, чтоб памяти меньше жрало
            bad_factor = 1e-4 #предел искривления для отбраковки картинки
            ):
    "Пытаемся вклеить другую картинку"
    #orig_img = cv2.imread(img_path)
    print "test: %s vs %s" % (img_small_path, img_path)

    small_img = cv2.imread(img_small_path)
    
    array_img = cv2.imread(img_path, cv2.cv.CV_LOAD_IMAGE_GRAYSCALE)
    array_tmpl = cv2.imread(img_small_path, cv2.cv.CV_LOAD_IMAGE_GRAYSCALE)

    h, w = array_img.shape
    
    if small_img.shape[2] == 3:
        small_img = cv2.cvtColor(small_img, cv2.COLOR_BGR2BGRA)

    #пытаемся найти параметры преобразования
    try: 
        if not img_path in __features__cached__:
            __features__cached__[img_path] = get_features( cv2.resize(array_img, (w/small_factor, h/small_factor)) )
        if not img_small_path in __features__cached__:
            __features__cached__[img_small_path] = get_features( array_tmpl )

        diff_homo = get_homography(__features__cached__[img_small_path], __features__cached__[img_path])
        #diff_homo = get_different(array_tmpl, cv2.resize(array_img, (w/small_factor, h/small_factor)))
    except:
        print sys.exc_info()[1]
        return None

    #проверка на слишком большое искривление
    #print '?', diff_homo
    if abs(diff_homo[2,0]) > bad_factor or (abs(diff_homo[2,1])) > bad_factor or (abs(diff_homo[2,2] - 1))>0.2:
        return None
    
    print img_path, img_small_path, '\n', diff_homo
    #преобразуем изображение
    try:
        dst = cv2.warpPerspective(small_img, diff_homo, (w/small_factor, h/small_factor), 
                flags = cv2.INTER_NEAREST
                )# [, dst[, flags[, borderMode[, borderValue]]]]) → dst¶
        dst = cv2.resize(dst, (w,h), interpolation=cv2.INTER_NEAREST)
        cv2.imwrite(out_path, dst)
    except:
        pass
    return ''
    
if __name__ == "__main__":
    import optparse
    
    parser = optparse.OptionParser(u"usage: %prog <файлы, которые вклеивать>")
    parser.add_option("-d", "--from-dir", dest="from_dir", type="string", 
                      default=".", help=u'каталог в котором искать оригинальные страницы')
    parser.add_option("-o", "--out-dir", dest="out_dir", type="string", 
                      default="fix_pages", help=u'каталог в который складывать обработанные изображения')
    parser.add_option("--all", dest="all", action="store_true", 
                      default=False, help=u'сравниваются картинки все со всеми')
    parser.add_option("-n", "--diff-num", dest="diff_num", type="int", 
                      default=10, help=u'в пределах скольки страниц искать подобие')

    (options, infiles) = parser.parse_args()
    
    #список файлов со страницами
    test_files = {}
    for name in os.listdir(options.from_dir):
        z = re.match('^([0-9]+)', name)
        if z:
            test_files[int(z.group())] = os.path.join(options.from_dir, name)

    print test_files

    if not os.path.isdir(options.out_dir): os.makedirs(options.out_dir)
    
    if options.all:
        #перебор всех со всеми
        for name in sorted(os.listdir(options.from_dir)):
            fn = os.path.join(options.from_dir, name)
            if os.path.islink(fn):
                fn = os.readlink(fn)
            if not os.path.isfile(fn): continue
            
            for inf in sorted(infiles):
                inf_basename = os.path.basename(inf)
                outname = '%s/%s-%s.png' % (options.out_dir, os.path.basename(fn), inf_basename)
                fix_pages(fn, inf, outname)
    else:
        #сравниваем ищем картинку в пределах +- options.diff_num страниц
        for inf in infiles:
            inf_basename = os.path.basename(inf)
            try:
                #ищем номер страницы
                inf_num = int(re.match('^-?([0-9]+)', inf_basename).groups()[0])
            except: 
                continue

            #ищем подобие на страницам с номерами в пределах +/- options.diff_num
            for page_num in xrange( inf_num - options.diff_num, inf_num + options.diff_num ):
                if page_num not in test_files: continue
                fix_pages(test_files[page_num], inf, '%s/%.4i-%s.png' % (options.out_dir, page_num, inf_basename))
