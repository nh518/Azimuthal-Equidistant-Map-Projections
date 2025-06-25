# 🗺️ Azimuthal Equidistant Mapping and Projection of Head CT Scans for Fracture Visualization

## 📌 Overview
This repository provides the MATLAB code accompanying the paper **"Azimuthal Equidistant Map Projections"**. The code implements several map projection algorithms, with a primary focus on the **Azimuthal Equidistant Projection**. This method flattens the spherical anatomy of the skull into a 2D plane, offering radiologists an alternative view of each hemisphere.

By applying this projection to head CT scans, subtle fractures—especially those perpendicular to the skull surface—become more visible. This increased visibility is particularly beneficial for detecting challenging basilar or facial fractures. The method was evaluated using the publicly available **CQ500** dataset and can significantly assist radiologists and emergency department personnel in improving fracture detection efficiency and accuracy.

> 🔹 **Note**: For demonstration purposes, only a subset of the data is included. To run the full dataset, update the paths pointing to the CQ500 data accordingly.

---

## 📄 Paper Reference

- **Title**: *Azimuthal Equidistant Map Projections*  
- **Authors**: Nicolas Hadjittoouli, Christos Nicolaou, Costas Pitris  
- **Published in**: *IEEE Access*, 2025  
- **DOI**: [10.1109/ACCESS.2025.3565672](https://doi.org/10.1109/ACCESS.2025.3565672)

> 📚 **Citation**:  
```bibtex
@ARTICLE{10980247,
  author={Hadjittoouli, Nicolas and Nikolaou, Christos and Pitris, Costas},
  journal={IEEE Access}, 
  title={Azimuthal Equidistant Mapping and Projection of Head CT Scans for Fracture Visualization}, 
  year={2025},
  volume={13},
  pages={78214--78220},
  keywords={Skull;Computed tomography;Distortion;Biomedical imaging;Cartography;Anatomy;Bones;Cranial;Azimuth;Accuracy;Computed tomography;computer-aided diagnosis;fracture detection;image processing;medical imaging;skull fracture},
  doi={10.1109/ACCESS.2025.3565672}
}


## 📂 Features
- Azimuthal Equidistant Map Projection implementation
- Preparing the data from the CQ500 dataset
- Registration algorithm for the Rigid, Similarity, and Affine transformations
- Implementation of the transformations to the head CT images
- Visualization tools to display projected maps
- Example scripts for reproducing results from the paper

## 🛠️ Requirements
- MATLAB (Recommended version: R2020b or later)

## 🚀 Usage
For fast and intuitive execution of the method you can set the *patient_code='globe.mat'* in the *main.m* and skip to step 5.
To run the code and reproduce the results from the paper:
1. Clone the repository:
   ```bash
   git clone https://github.com/nh518/Azimuthal-Equidistant-Map-Projections.git
   cd Azimuthal-Equidistant-Map-Projections

2. Prepare the data:
    
    Run prepare_data.sh script to download and unzip the data. 
    ```bash
    mkdir data
    sh prepare_data.sh

3. Registration step:
    
    Run registration.m script to register and save the registration transformation for each patient. The registration.m script registers all the patients with the suspicious fracture to the normal patient (105). The script produces the triple_transformation.mat, which are the transformations used to register the patient to patient 105. 

4. Transformation step:
    
    Apply those transformations and save the registered volume you should run the rsa_transforn.m script.

5. Azimuthal Equidistant Map Projections:
    
    The main script applies azimuthal equidistant map to the head CT data. It outputs all figures to the output directory.

**NOTE:** The initial time to run each script is quite long but after the first time the necessary data are saved each step to make the reproduction of the code faster.
