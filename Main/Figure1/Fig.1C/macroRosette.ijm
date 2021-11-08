/**
*AUTHOR : Emmanuel Tergemina
*DATE: 20201217
*/
setBatchMode(true);
macro "Rosette Analysis"{
    Dialog.create("Dialog Windows");


	source_folder = getDirectory("Select source directory:");
	segmentator = File.openDialog("Select the segmentator:");

	////Create Directories
	File.makeDirectory(source_folder+"results" + File.separator)
	File.makeDirectory(source_folder+"segmented" + File.separator)
	
	function define_roi() {
		for (k=0; k<nResults; k++) {
      		x = getResult('XStart', k);
     		y = getResult('YStart', k);
     		doWand(x,y);
    		roiManager("add");
  		}
	}

	if (isOpen("ROI Manager")) {
     	selectWindow("ROI Manager");
     	run("Close");
	 }

	files = getFileList(source_folder);
	extensions = newArray(".jpg",".tiff",".tif");

	for (i=0; i<files.length; i++) {
    	showProgress(i, files.length);
		for (j=0; j<extensions.length; j++) {
			if (endsWith(toLowerCase(files[i]), extensions[j])) {
				//print(files[i]);
				open(files[i]);
				index = indexOf(toLowerCase(files[i]), extensions[j]);
				fileName = substring(files[i], 0, index);
				file = files[i];
				
				

				//////Rosette segmentation
				selectWindow(files[i]);
      			run("Apply saved SIOX segmentator", "browse=" + segmentator + " siox=" + segmentator);
				////Define ROI
				run("Analyze Particles...", "clear add");
				selectWindow(files[i]);
				define_roi();
				roiManager("Combine");
				
				if (roiManager("count") > 0){
					roiManager("reset");
      				run("Clear Outside");
      				saveAs(".jpg", source_folder + "segmented/" + fileName + "_Segmented");    
      				f = File.open(source_folder + "results/" + fileName + ".txt");	
      				print(f, "Red\tGreen\tBlue\tArea\tPerim\tMajor");
      				//Extract Red values
      				setRGBWeights(1, 0, 0);
					red=getValue("Mean");
					setRGBWeights(0, 1, 0);
					//Extract Green values
					green=getValue("Mean");
					setRGBWeights(0, 0, 1);
					//Extract Blue values
					blue=getValue("Mean");
					//Extract Area, Perim and Major values
					area=getValue("Area");
					perim=getValue("Perim.");
					major=getValue("Major");
					print(f,red + "\t" + green+ "\t" + blue + "\t" + area + "\t" + perim + "\t" + major);
      				File.close(f);
      			}
      			run("Close All");
			}
		}
	}
}

