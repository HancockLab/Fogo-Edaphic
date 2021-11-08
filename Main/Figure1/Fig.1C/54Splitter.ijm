/**
*AUTHOR : Emmanuel Tergemina
*DATE: 20201216
*/


setBatchMode(true);

source_folder = getDirectory("Select source directory:");
File.makeDirectory(source_folder + "grid/")

function grid_ROI() {
	x = 0;
	y = 0;
	width = 380; 
	height = 380;
	numRow = 6;
	numCol = 9;
	for (i = 0; i < numRow; i++) {
    	for (j = 0; j < numCol; j++) {
        	xOffset = j * (width);
        	yOffset = i * (height);
        	makeRectangle(x + xOffset, y + yOffset, width, height);
        	roiManager("Add");
    	}
	}
}

function grid_crop(fileName) {
	roiManager("Show All with labels");
	mainTitle=getTitle();
	for (u = 0; u < roiManager("count"); ++u) {
    	run("Duplicate...", "title=crop");
    	roiManager("Select", u);
    	run("Crop");
    	saveAs("Tiff", source_folder + "grid/" + fileName + "_Plant_" + (u + 1) + ".tif");
   		close();
    	selectWindow(mainTitle);
	}
}


files = getFileList(source_folder);
extensions = newArray(".jpg",".tiff",".tif");

for (i=0; i<files.length; i++) {
    	showProgress(i, files.length);
		for (j=0; j<extensions.length; j++) {
			if (endsWith(toLowerCase(files[i]), extensions[j])) {
				open(files[i]);
				index = indexOf(toLowerCase(files[i]), extensions[j]);
				fileName = substring(files[i], 0, index);
				file = files[i];
				selectWindow(files[i]);
				grid_ROI();
				grid_crop(fileName);
				roiManager("reset");
				run("Close All");
		}
	}
}



