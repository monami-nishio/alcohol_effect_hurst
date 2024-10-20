from nilearn.maskers import NiftiMasker, NiftiLabelsMasker
from nilearn.image import load_img
from nilearn.connectome import ConnectivityMeasure
from nilearn import plotting
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import glob
import os

mask_path = '/mnt/DataDrive3/NishioM/rodent_alcohol/template/Rat_CAMRI_400um_ATLAS.nii.gz'
mouse_path = glob.glob(os.path.join('/mnt/DataDrive3/NishioM/rodent_alcohol/bold/sub-*/*.nii.gz'))
reverse = list(reversed(mouse_path))
masker = NiftiLabelsMasker(labels_img=mask_path, standardize=False,memory="nilearn_cache",verbose=5)

all_mouse = []
for i, mouse in enumerate(mouse_path):
    print(mouse)
    if not os.path.exists(os.path.join('/mnt/DataDrive3/NishioM/rodent_alcohol/connectivity', os.path.basename(mouse).replace('.nii.gz', '_connectivity.csv'))):
        mouse_img = load_img(mouse)
        timeseries = masker.fit_transform(mouse_img)
        pd.DataFrame(timeseries).to_csv(os.path.join('/mnt/DataDrive3/NishioM/rodent_alcohol/timeseries', os.path.basename(mouse).replace('.nii.gz', '_timeseries.csv')), index=False)
        correlation_measure = ConnectivityMeasure(kind="correlation") #,standardize=True
        correlation_matrix = correlation_measure.fit_transform([timeseries])[0]
        pd.DataFrame(correlation_matrix).to_csv(os.path.join('/mnt/DataDrive3/NishioM/rodent_alcohol/connectivity', os.path.basename(mouse).replace('.nii.gz', '_connectivity.csv')), index=False)
