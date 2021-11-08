# Image analysis rosette </br> *Fogo-SantoAntão-Morocco*

## Requirements

 * ImageJ or Fiji with SIOX plugin (version 2.1.0/1.53c)
 * Python (version >= 3.0)

## Description

The pictures were done in a photostation with a tripod. The camera was setted with fixed focus and white balance.

#### Split pots from each tray

Select tray area in an image and measure length and width. For this study we used the dimensions in [rectangle.ijm](rectangle.ijm). The dimensions have be added within the script [54Splitter.ijm]([54Splitter.ijm]). Run the script [54Splitter.ijm]([54Splitter.ijm]) in ImageJ or Fiji. This will generate a picture for each pot.


#### Generate segmentator

Generate a segmentator from a single pot image using the SIOX Simple Interactive Object Extraction plugin. For this study, we generated and used the segmentator [segmentator-DSC_0017_Plant_19.siox]([segmentator-DSC_0017_Plant_19.siox]).

#### Segmentation

Segment rosette for each plant and extract measurements (RGB values and segmentated area) with the script [macroRosette.ijm]([macroRosette.ijm]).

#### Results parsing

```python
./parsePictures.py

```


