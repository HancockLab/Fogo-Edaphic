# Image analysis - rosette </br> *Fogo-SantoAntão-Morocco*

## Description

Pipeline used to analyse pictures

## Requirements

 * ImageJ or Fiji with SIOX plugin (version 2.1.0/1.53c)
 * Python (version >= 3.0)

## Comments

The pictures were done with a tripod in a photostation. The camera was set with fixed focus and white balance.

#### Split pots from each tray

The tray area was selected in a picture with the rectangle tool and the coordinates saved in [rectangle.ijm](rectangle.ijm). We added within [54Splitter.ijm](54Splitter.ijm) the width (in pixels) of the pots used (, the number of rows and columns in the tray. We used here squared pots and define width to 380 pixels. Each tray contained 54 pots organized in 6 rows and 9 columns. Run the script [54Splitter.ijm](54Splitter.ijm) in ImageJ or Fiji to generate a picture for each pot.

#### Generate segmentator

Generate a segmentator from a single pot image using the SIOX Simple Interactive Object Extraction plugin. For this study, we generated and used the segmentator [segmentator-DSC_0017_Plant_19.siox](segmentator-DSC_0017_Plant_19.siox).

#### Segmentation

Segment rosette for each plant and extract measurements (RGB values and segmentated area) with the script [macroRosette.ijm](macroRosette.ijm).

#### Results parsing

Parse the results with the python script [parsePictures.py](parsePictures.py).

```python
python ./parsePictures.py

```

#### Convert pixels to cm

We took pictures of the trays together with a [color checker](https://www.xrite.com/categories/calibration-profiling/colorchecker-classic) to set the scale


