Azimuthal equidistant maps and projections of fracture visualization

To run the script run prepare_data.sh first to download and unzip the data. Only a sample of the data is downloaded, but if you want to run the full dataset go to CQ500 for the all files.

The registration.m script registers all the patients with the suspicious fracture to the normal patient (105). The script produces the triple_transformation.mat, which are the transformations used to register the patient to patient 105. To apply those transformations and save the registered volume you should run the rsa_transforn.m script. After this you are ready to run the main script to apply the azimuthal equidistant map to the data.

NOTE: The initial time to run the script is quite long but after the first time the necessary data are saved each step to make the reproduction of the code faster.