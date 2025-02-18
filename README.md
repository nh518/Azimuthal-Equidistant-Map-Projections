# Azimuthal equidistant mapping and projection of head CT scans for fracture visualization

## 📌 Overview
This repository contains the MATLAB code developed as part of the supplementary material for the paper **"Azimuthal Equidistant Map Projections"**. The code implements various map projection algorithms, focusing on the **Azimuthal Equidistant projection**. For simplicity, only a sample of the data is downloaded, but if you want to run the full dataset change the paths CQ500 for the all files. 
The proposed method maps the inherently spherical shape of the skull into a planar representation, providing radiologists with an alternative view of each complete hemisphere. Applying azimuthal equidistant mapping to CT volumetric data preserves the skull's anatomy, while fractures, which are usually perpendicular to the bone's surface, become more visible in projection views. The enhanced visibility is particularly useful for subtle basilar or facial fractures and increases the likelihood of detection. The effectiveness of the technique was evaluated using the CQ500 dataset. Azimuthal equidistant mapping and projection can become a valuable addition to conventional radiologic evaluation, offering an alternative view for radiologists and emergency department staff, which can increase the effectiveness and time efficiency of skull fracture detection.

## 📄 Paper Reference
- **Title**: Azimuthal Equidistant Map Projections  
- **Authors**: Nicolas Hadjittoouli, Christos Nicolaou, Costas Pitris  
- **Journal/Conference**: IEEE Access 
- **DOI/Link**: [Link to Paper or DOI]

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
